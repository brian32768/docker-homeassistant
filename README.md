# home-assistant

Information on Node-Red in docker: https://nodered.org/docs/getting-started/docker

I'm running home-assistant, node-red, and mosquitto here.

## Volumes

There are docker volumes to store home assistant data
and to store node-red data.
Mosquitto is configured via a local file, mosquitto.conf.

## Deploy

Swarm mode does not work because of the "devices" option needed to talk to the USB devices.

Instead use
    docker-compose build
    docker-compose up -d

## Backups

The script backup.sh will do a nightly backup to the Synology when invoked from cron.

## URLs

    https://home-assistant.wildsong.biz/

    http://bellman:1880/

