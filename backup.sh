#!/bin/bash
#
#  Back up the critical files for Home Assistant and Zigbee2MQTT
#
# I wish this was part of the compose file

# How many old files to keep online
KEEPDAYS=30

# Dump list of files in tar.
verbose='v'
verbose=''

datestamp=`date "+%Y%m%d"`

# 2021-09 I changed config from a Docker volume to a local directory
# Name of Home Assistant config volume
#HOME_ASSISTANT=home-assistant_config
HOME_ASSISTANT=${PWD}/config

# Where to write output data
#OUTPUT_DIR=/net/wenda/volume1/Wildsong/Backups/home-assistant
OUTPUT_DIR=${HOME}/Backups/home-assistant
#if [ ! -d $OUTPUT_DIR ]; then
#   mkdir ${OUTPUT_DIR}
#fi
ls -d $OUTPUT_DIR
# (When output is synology) allow time to wake up
#sleep 2

echo "Backing up Home Assistant and Z2M on $datestamp to $OUTPUT_DIR"

SQLITE3=keinos/sqlite3

database=home-assistant_v2
echo "Backing up $database."
docker run --rm -v $HOME_ASSISTANT:/config --workdir /config $SQLITE3 sh -c "sqlite3 ${database}.db .dump" > $OUTPUT_DIR/${database}.${datestamp}.sql

echo "Backing up Home Assistant files."
cd config && tar c${verbose}zf ${OUTPUT_DIR}/ha-${datestamp}.tgz --exclude='*.db' --exclude='.storage/auth' .
cd ..

echo "Backing up Zigbee2MQTT files"
cd ../z2m/z2m_data && 
tar c${verbose}zf ${OUTPUT_DIR}/z2m_data-${datestamp}.tgz --exclude='log' .

# Make things a little more private
chmod 600 ${OUTPUT_DIR}/*.tgz ${OUTPUT_DIR}/*.sql

echo Deleting $KEEPDAYS day old backup files.

cd $OUTPUT_DIR
find . -name '*.sql' -mtime +$KEEPDAYS -print -exec rm -f {} \;
find . -name '*.tgz' -mtime +$KEEPDAYS -print -exec rm -f {} \;

ls -l ${OUTPUT_DIR}
