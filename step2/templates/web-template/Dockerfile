FROM 192.168.100.36:1179/xiaoke/node:12.15.0 AS builder
WORKDIR /home/node/app
COPY package.json /home/node/app/
COPY . /home/node/app
RUN yarn config set registry https://registry.npm.taobao.org/ && yarn
RUN npm run build:test

FROM 192.168.100.36:1179/xiaoke/nginx:alpine
COPY --from=builder /home/node/app/nginx.default.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /home/node/app/build /usr/share/nginx/html
EXPOSE 80
EXPOSE 6020
