#!/bin/bash
ICODETOKEN=Fy1vexUnAfPxefNaw2Mu
KKBRELEASE=184
GITSERVER=http://icode.kaikeba.com
RELEASE_REPO=git@192.168.100.101:kkb-release
PGRDIR=$(cd `dirname $0`; pwd)
# params from cli
repo=""
port=""
nodePort=""
template=""
# params from functions
subGroupID=-1
projectID=-1
subGroup=""
projectName=""
subDir=""
upload=""
nodePortTest=""
nodePortPre=""
nodePortProd=""

getOpts() {
  while getopts ":r:p:n:t:s:u:o" opt; do
    case $opt in
      r) repo=$OPTARG
      ;;
      p) port=$OPTARG
      ;;
      n) nodePort=$OPTARG
      ;;
      t) template=$OPTARG
      ;;
      s) subDir=$OPTARG
      ;;
      u) upload=$OPTARG
      ;;
      \?) usage
      ;;
    esac
  done
}

usage() {
  echo """
gen-release.sh is a simple&stupid release generator.

!!!IMPORTENT!!!
GNU sed and jq needed! if use macOS,execute commands list below:

brew install coreutils
brew install gnu-sed --with-default-names
brew install jq

USAGE:

gen-release.sh -r sourceProjectRepo -p port -n nodePort -t template [-s subDir] -u upload

SUPPORTED TEMPLATES:

general-template  (kuick mos2 market kkb-cms )
mvn-new-template  (corgi)
mvn-old-template  (kkb-cloud)
nodejs-template   (kkb-plat-open)
web-template      (kkb-plat-cms)

EXAMPLE:

sh gen-release.sh -r git@192.168.100.101:corgi/kkb-corgi-upms-push-service.git -p 8080 -n 20789 -t mvn-new-template -s kkb-corgi-upms-push-service-sdk -u upload

sh gen-release.sh -r git@192.168.100.101:corgi/kkb-corgi-upms-push-service.git -p 8080 -n 20789 -t mvn-new-template -u upload

DEBUG:

sh -x gen-release.sh -r git@192.168.100.101:corgi/kkb-corgi-upms-push-service.git -p 8080 -n 20789 -t mvn-new-template -u upload
"""
exit 1
}

checkParams() {
  if [[ ! ${repo} ]]; then
    echo -e "ERROR: parameter sourceProjectRepo needed!\n"
    usage
  fi
  if [[ ! ${port} ]]; then
    echo -e "ERROR: parameter port needed!\n"
    usage
  fi
  if [[ ! ${nodePort} ]]; then
    echo -e "ERROR: parameter nodePort needed!\n"
    usage
  fi
  if [[  ${#nodePort} -ne 5 ]]; then
    echo -e "ERROR: parameter nodePort needed length 5!\n"
    usage
  fi
  if [[ ! ${template} ]]; then
    echo -e "ERROR: parameter template needed!\n"
    usage
  fi
  if [[  ${template} == "mvn-old-template" ]]; then
    if [[ ! ${subDir} ]]; then
      echo -e "ERROR: parameter subdir needed when template  is mvn-old-template !\n"
      usage
    fi
  fi
  if [[ ${subGroupID} -lt 0 ]]; then
    echo -e "ERROR: create subGroup on ${GITSERVER} failed!\n"
    exit 1
  fi
  if [[ ${projectID} -lt 0 ]]; then
    echo -e "ERROR: create project on ${GITSERVER} failed!\n"
    exit 1
  fi


}

getSubGroup() {
  subGroup=`echo ${repo//http:\/\/icode.kaikeba.com\//}`
  subGroup=`echo ${subGroup//git@192.168.100.101:/}`
  subGroup=${subGroup%%/*}
}

getProjectName() {
  projectName=`echo ${repo//http:\/\/icode.kaikeba.com\//}`
  projectName=`echo ${projectName//git@192.168.100.101:/}`
  projectName=${projectName##*/}
  projectName=`echo ${projectName//.git/}`
}

getNodePorts() {
  prefix=${nodePort:0:2}
  mid=${nodePort:2:1}
  suffix=${nodePort:3:2}
  if [[ ${mid} -gt 7 ]]; then
    echo "ERROR: the middle bit of nodePort can not greater than 7"
    exit 1
  fi
  nodePortTest="${prefix}$[mid+1]${suffix}"
  nodePortPre="${prefix}$[mid+2]${suffix}"
  nodePortProd="${prefix}$[mid+3]${suffix}"
  echo $nodePortTest $nodePortPre $nodePortProd
}

genRelease() {
  if [[ ! -d ./release-gen ]]; then
    mkdir ./release-gen
  fi
  rm -rf ./release-gen/${projectName}
  if [[ ${subDir} ]]; then
    mkdir -p ./release-gen/${projectName}/${subDir}
    /usr/bin/cp -r ./templates/${template}/* ./release-gen/${projectName}/${subDir}/
  # jenkinsfile
    sed -i "s/{{category}}/${subGroup}/g" ./release-gen/${projectName}/${subDir}/Jenkinsfile
    sed -i "s/{{release_repo}}/${subGroup}\/${projectName}/g" ./release-gen/${projectName}/${subDir}/Jenkinsfile
    sed -i "s/{{subdir}}/${subDir}/g" ./release-gen/${projectName}/${subDir}/Jenkinsfile
  else
    /usr/bin/cp -r ./templates/${template} ./release-gen/${projectName}
  # jenkinsfile
    sed -i "s/{{category}}/${subGroup}/g" ./release-gen/${projectName}/Jenkinsfile
    sed -i "s/{{release_repo}}/${subGroup}\/${projectName}/g" ./release-gen/${projectName}/Jenkinsfile
    sed -i "s/{{subdir}}/${subDir}/g" ./release-gen/${projectName}/Jenkinsfile
  fi
  # port
  grep -lr port: ./release-gen/${projectName} |xargs sed -i "s/8080/${port}/g"
  # name
  grep -lr template ./release-gen/${projectName} |xargs sed -i "s/${template}/${projectName}/g"
  # nodePort
  grep -lr nodePort ./release-gen/${projectName} |grep "prod"|xargs sed -i "s/{{nodePort}}/${nodePortProd}/g"
  grep -lr nodePort ./release-gen/${projectName} |grep "pre"|xargs sed -i "s/{{nodePort}}/${nodePortPre}/g"
  grep -lr nodePort ./release-gen/${projectName} |grep "test"|xargs sed -i "s/{{nodePort}}/${nodePortTest}/g"
  grep -lr nodePort ./release-gen/${projectName} |grep "dev"|xargs sed -i "s/{{nodePort}}/${nodePort}/g"
}

createSubGroup() {
  subGroupID=`curl -s --header "Private-Token: ${ICODETOKEN}"  -X GET  ${GITSERVER}/api/v4/groups/${KKBRELEASE}/subgroups\?search\=${subGroup}|jq '.[0].id'`
  if [[ ${subGroupID} == "null" ]]; then
    subGroupID=-1
  fi
  if [[  $subGroupID -lt 0 ]]; then
    subGroupID=`curl -s --header "Private-Token: ${ICODETOKEN}" -X POST ${GITSERVER}/api/v4/groups\?name\=${subGroup}\&path\=${subGroup}\&parent_id\=${KKBRELEASE}|jq '.id'`
  fi
}

createProject() {
  projectID=`curl -s --header "Private-Token: ${ICODETOKEN}" -X GET ${GITSERVER}/api/v4/groups/${subGroupID}/projects\?search\=${projectName} |jq '.[0].id'`
  if [[ ${projectID} == "null" ]]; then
    projectID=-1
  fi
  if [[ $projectID -lt 0 ]]; then
    projectID=` curl -s --header "Private-Token: ${ICODETOKEN}" -X POST ${GITSERVER}/api/v4/projects\?name\=${projectName}\&path\=${projectName}\&namespace_id\=${subGroupID} |jq .id`
  fi
}

pushProject() {
  cd ./release-gen/${projectName}
  git init>> /dev/null
  git remote add origin ${RELEASE_REPO}/${subGroup}/${projectName}.git>> /dev/null
  git add .>> /dev/null
  git commit -m "Initial commit">> /dev/null
  if [[ ${upload} == "upload" ]]; then
    git push -u origin master -q
  else
    echo -e "小伙子你只是创建部署模板,但是没有上传到gitlab!\n您可以执行如下操作: cd ./release-gen/${projectName} && git push origin master"
  fi
  cd ${PGRDIR}
}

confirmMessage() {
  echo -e  "confirmMessage not implemented ! \n"

}
echoJenkinsFile() {
  echo -e "put Jenkinsfile into ${repo}:\n"
  if [[ ${subDir} ]]; then
    cat ./release-gen/${projectName}/${subDir}/Jenkinsfile
  else
    cat ./release-gen/${projectName}/Jenkinsfile
  fi
  echo -e "\n"
}

main () {
  if [[ ! $1 ]]; then
    getOpts -h
  else
    getOpts $@
  fi
  getSubGroup
  getProjectName
  createSubGroup
  createProject
  checkParams
  getNodePorts
  confirmMessage
  genRelease
  pushProject
  echoJenkinsFile
}

git pull
main $@

