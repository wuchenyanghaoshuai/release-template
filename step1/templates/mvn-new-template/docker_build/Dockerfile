FROM 192.168.100.36:1179/kkb/jre-sky-agent:alpine_v1

ADD run.sh /
RUN chmod +x /run.sh

# RUN echo -e "https://mirror.tuna.tsinghua.edu.cn/alpine/v3.4/main\n\
# https://mirror.tuna.tsinghua.edu.cn/alpine/v3.4/community" > /etc/apk/repositories

RUN sed -i 's/dl-cdn\.alpinelinux\.org/mirrors\.aliyun\.com/g' /etc/apk/repositories


ADD app.jar /

CMD ["/run.sh"]
