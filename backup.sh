#!/bin/bash
#
#  Back up the critical files for Home Assistant to the Synology server.
#
# I wish this was part of the compose file

# How many old files to keep online
KEEPDAYS=30

datestamp=`date "+%Y%m%d"`

# 2021-09 I changed config from a Docker volume to a local directory
# Name of Home Assistant config volume
#HOME_ASSISTANT=home-assistant_config
HOME_ASSISTANT=${PWD}/config

# Where to write output data
OUTPUT_DIR=/net/Wenda/volume1/Wildsong/Backups/home-assistant
if [ ! -e ${OUTPUT_DIR} ]; then
    mkdir -p $OUTPUT_DIR
fi

echo Backing up home assistant on $datestamp to $OUTPUT_DIR

# docker buildx build -f Dockerfile.backup sqlite3

for database in home-assistant_v2 zigbee; do
    echo -n "...working on $database"
    docker run --rm --net=proxy -v $HOME_ASSISTANT:/config -v $OUTPUT_DIR:/target \
       sqlite3:latest \
       sqlite3 ${database}.db ".backup /target/${database}-$datestamp.db"
    echo
done

echo Backing up home assistant files to files-$datestamp.tgz
docker run --rm --net=proxy -v $HOME_ASSISTANT:/config -v $OUTPUT_DIR:/target \
       sqlite3:latest \
       tar czf /target/files-$datestamp.tgz --exclude='*.db' .

# Make things a little more private
docker run --rm --net=proxy -v $OUTPUT_DIR:/target sqlite3:latest chmod 600 '/target/*tgz'

# NB doing this with dockers works better because the files are owned by root.

echo Deleting $KEEPDAYS day old backup files.

docker run --rm --net=proxy -v $OUTPUT_DIR:/target sqlite3:latest \
  find /target/ -name '*.db' -mtime +$KEEPDAYS -print -exec rm -f {} \;

docker run --rm --net=proxy -v $OUTPUT_DIR:/target sqlite3:latest \
  find /target/ -name '*.tgz' -mtime +$KEEPDAYS -print -exec rm -f {} \;
