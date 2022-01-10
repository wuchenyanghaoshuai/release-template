FROM 192.168.100.36:1179/base/node:v1

WORKDIR /home/node/app/
ENV HOME=/home/node/app/ \
    APP_NAME=home \
    ENABLE_NODE_LOG=YES \
    NODE_LOG_DIR=/tmp

COPY package.json .yarnrc ./
RUN yarn
COPY . ./

RUN npm run build:test

EXPOSE 80
EXPOSE 6020

CMD  ["./release/pm2start.sh"]

