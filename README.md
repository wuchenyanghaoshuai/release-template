# 本文介绍如何使用release-template下的脚本生成k8s的deployment跟svc
```
1. 将该git克隆到本地
2. 修改step1下的gen-release.sh
3. 需要修改以下几点
   3.1 ICODETOKEN=CX4Hvj-rMyQTBNFDBRAe(gitlab点击右上角头像,然后点击左侧accesstokn创建即可记得复制出来生成的码)
   3.2 KKBRELEASE=6(在gitlab上创建一个名字为kkb-release的group并且记录id)
   3.3 还有就是我这边的git地址跟你的地址不一样，要记得更改
   
4. 脚本要自己领悟其中的秘密
5. usage ./gen-release.sh  -r git@192.168.1.17:code/tupian.git -p 80 -n 10001 -t web-template -u upload
         (-p 是项目端口,前端一般是80,如果是java项目则是8080,-p 为nodeport,一次性会生成4个,分别为dev test pre prod 如果给定的dev环境的是10001则对应的dev:10001 
          test:10101 pre:10201 prod:10301)
6. 最后一张图就是配合5来使用的，就会自动帮我们创建一个kkb-release/code/tupian,该git是为了配合下面的部署到k8s里来使用的
```
![image](https://user-images.githubusercontent.com/39818267/148771704-04147d39-55c1-416c-aba8-48760bd5a625.png)
![image](https://user-images.githubusercontent.com/39818267/148771793-13ddba98-5f0f-45a7-b2c4-ce41dfc35d5f.png)
![image](https://user-images.githubusercontent.com/39818267/148771890-bcedda91-fa61-45bb-8416-984c01938ac2.png)
![image](https://user-images.githubusercontent.com/39818267/148772688-b8be47e5-5889-4b49-ab75-b63ebf186223.png)

