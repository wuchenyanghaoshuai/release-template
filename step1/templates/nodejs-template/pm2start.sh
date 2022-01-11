#!/bin/sh


echo $NODE_ENV

pm2-runtime start ecosystem.config.js --env $NODE_ENV