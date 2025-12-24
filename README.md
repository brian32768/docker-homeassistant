# docker-homeassistant

This is my Docker set up for Home Assistant.
I used to include Mosquitto and the hardware setup for the Zigbee dongle
but that's been moved to the docker-z2m project.

I am 150 miles from home right now and want to do some work
with Esphome and an ESP32-C6 device, so I am trying to run
Home Assistant locally on my Windows 11 laptop. Theory is
that I don't need Mosquitto or Zigbee2MQTT to do this.

## Node Red

I've tried it and find it tediously difficult. I want to just code in Python.

Information on Node-Red in docker: https://nodered.org/docs/getting-started/docker

## Volumes

I am not using Docker volumes right now because it's easier here to
keep configuration for home assistant in local folders.

Home Assistant is in config/.

## Deploy

```bash
   docker compose up -d
```

## Backups

The script backup.sh will do a nightly backup to the Synology when invoked from cron.

## URLs

Normally I run my instance here,

   https://homeassistant.wildsong.biz/

## Update firmware in Nortek

(or is it spelled Nortec??)

   docker run --rm --device=/dev/serial/by-id/usb-Silicon_Labs_HubZ_Smart_Home_Controller_81300CEB-if01-port0:/dev/ttyUSB1 -it walthowd/husbzb-firmware bash

## TODO

* build an image with log file redirection (see unifi for example)

### Music Assistant

mkdir music_assistant_data
docker run -v ./music_assistant_data:/data --network host --cap-add=DAC_READ_SEARCH --cap-add=SYS_ADMIN ghcr.io/music-assistant/server

