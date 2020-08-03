# home-assistant

Information on Node-Red in docker: https://nodered.org/docs/getting-started/docker

I'm running home-assistant, node-red, and mosquitto here.

## Volumes

There are docker volumes to store home assistant data
and to store node-red data.
Mosquitto is configured via a local file, mosquitto.conf.

## Deploy

"docker stack" does not work because of the needed "devices" option.

Instead use
    docker-compose build
    docker-compose up -d

## URLs

    https://home-assistant.wildsong.biz/

    http://bellman:1880/

