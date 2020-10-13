#!/bin/bash 


set -e
exec 1>>/var/log/mongo_backup.log 2>&1

echo "$(date -u) start backup"

mongodump --out /raw_files --host $MONGO_HOST:$MONGO_PORT
tar -zcvf /mongo_backup/"$(date '+%Y-%m-%d-%H-%M-%S').tar.gz" /raw_files/
aws s3 sync /mongo_backup/ $S3_DESTINATION
rm -rf /raw_files/* /mongo_backup/*

echo "$(date -u) finished backup"

