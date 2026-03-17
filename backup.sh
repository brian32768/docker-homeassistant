#!/bin/bash
#
#  Back up the critical files for Home Assistant and Zigbee2MQTT
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
#OUTPUT_DIR=/net/wenda/volume1/Wildsong/Backups/home-assistant
OUTPUT_DIR=/tmp/home-assistant
if [ ! -d $OUTPUT_DIR ]; then
   mkdir -p $OUTPUT_DIR
fi
ls -d $OUTPUT_DIR
# Allow Synology to wake up
#sleep 2

echo Backing up home assistant on $datestamp to $OUTPUT_DIR

SQLITE3=keinos/sqlite3

database=home-assistant_v2
echo -n "...working on $database... "
docker run --rm -v $HOME_ASSISTANT:/config --workdir /config \
       $SQLITE3 \
       sh -c "sqlite3 ${database}.db .dump" > $OUTPUT_DIR/${database}.${datestamp}.sql

echo Backing up home assistant files to files-$datestamp.tgz
cd config && tar czf ${OUTPUT_DIR}/files-${datestamp}.tgz --exclude='*.db' --exclude='.storage/auth' .

echo Backing up Zigbee2MQTT files
cd ../z2m/z2m_data && tar czf $OUTPUT_DIR/z2m_data-${datestamp}.tgz --exclude log .

# Make things a little more private
chmod 600 ${OUTPUT_DIR/*.tgz

echo Deleting $KEEPDAYS day old backup files.

find $OUTPUT_DIR -name '*.db' -mtime +$KEEPDAYS -print -exec rm -f {} \;
find $OUTPUT_DIR -name '*.tgz' -mtime +$KEEPDAYS -print -exec rm -f {} \;

