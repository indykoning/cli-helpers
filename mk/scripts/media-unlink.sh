#!/usr/bin/env bash

if [ -d "./public/wp" ]; then DIR="public/app/uploads"; fi
if [ -d "./bin/magento" ]; then DIR="pub/media"; fi
[ -z ${DIR} ] && echo "Project not compatible." && exit

[ -f app/etc/.env ] && source app/etc/.env
[ -f .env ] && source .env
[ -f app/etc/.env.${APP_ENV} ] && source app/etc/.env.${APP_ENV}
[ -f .env.${APP_ENV} ] && source .env.${APP_ENV}

if mount | grep "$REMOTE_SERVER_USER@$REMOTE_SERVER_IP" > /dev/null; then
    umount ${DIR}
else
    echo "Project not linked"
    exit
fi
