gen-release.sh is a simple&stupid release generator.

***!!!IMPORTENT!!!***

GNU sed and jq needed! if use macOS,execute commands list below:
```shell
brew install coreutils
brew install gnu-sed --with-default-names
brew install jq
```
***USAGE:***
```shell
gen-release.sh -r sourceProjectRepo -p port -n nodePort -t template [-s subDir] -u upload
```
***SUPPORTED TEMPLATES:***

general-template  (kuick mos2 market kkb-cms )

mvn-new-template  (corgi)

mvn-old-template  (kkb-cloud)

nodejs-template   (kkb-plat-open)

web-template      (kkb-plat-cms)

***EXAMPLE:***
```shell
gen-release.sh -r git@192.168.100.11:corgi/kkb-corgi-upms-push-service.git -p 8080 -n 20789 -t mvn-new-template -s kkb-corgi-upms-push-service-sdk -u upload

gen-release.sh -r git@192.168.100.11:corgi/kkb-corgi-upms-push-service.git -p 8080 -n 20789 -t mvn-new-template -u upload
```
***DEBUG:***
```shell
sh -x gen-release.sh -r git@192.168.100.11:corgi/kkb-corgi-upms-push-service.git -p 8080 -n 20789 -t mvn-new-template -u upload
```

