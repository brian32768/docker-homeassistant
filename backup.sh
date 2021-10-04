#!/bin/bash
#
#  Back up the critical files for Home Assistant to the Synology server.
#
#
# I wish this was part of the compose file
#

datestamp=`date "+%Y%m%d"`

# 2021-09 I changed this from a Docker volume to a local directory
# Name of Home Assistant config volume
#HOME_ASSISTANT=home-assistant_config
HOME_ASSISTANT=${PWD}/config

# Where to write output data
OUTPUT_DIR=/net/wenda/volume1/Wildsong/Backups/home-assistant/
if [ ! -e ${OUTPUT_DIR} ]; then
    mkdir -p $OUTPUT_DIR
fi

echo Backing up home assistant on $datestamp to $OUTPUT_DIR

# docker build wildsong/sqlite3 -f Dockerfile.backup build

for database in home-assistant_v2 zigbee; do
    echo -n "...working on $database"
    docker run --rm --net=proxy_net -v $HOME_ASSISTANT:/config -v $OUTPUT_DIR:/target \
       wildsong/sqlite3:latest \
       sqlite3 ${database}.db ".backup /target/${database}-$datestamp.db"
    echo
done

echo Backing up home assistant files to files-$datestamp.tgz
docker run --rm --net=proxy_net -v $HOME_ASSISTANT:/config -v $OUTPUT_DIR:/target \
       wildsong/sqlite3:latest \
       tar czf /target/files-$datestamp.tgz --exclude='*.db' .
