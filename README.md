# home-assistant

Information on Node-Red in docker: https://nodered.org/docs/getting-started/docker

I'm running home-assistant and mosquitto here.

## Node Red

I've tried it and find it tediously difficult. I want to just code in Python.

## MQTT Broker

I chose Mosquitto because it's very minimal and well supported in HA.

I wanted to try RabbitMQ, but let's face it, MQTT is just not that interesting.
I am sticking with Mosquitto and moving along to other things.

2021-09-28 -- I had to add "allow_anonymous true" to  mosquitto.conf
to get rid of an error message that popped up in the log about auth from HA.

### Mosquitto passwords

Let mosquitto create its config volume then fix its permissions

```bash
docker-compose up mosquitto
^C
sudo chmod 660 mosquitto_config/
```

Copy the template mosquitto.conf file into mosquitto_conf and customize it.

Create a new password file using the password entry you put in config/configuration.yml

To create credential pairs, use the mosquitto_passwd command to create a new file and put a password for homeassistant in it.

```bash
docker run -it --rm -v mosquitto_config:/mosquitto/config eclipse-mosquitto:latest mosquitto_passwd -c /mosquitto/config/passwd homeassistant
```

To create additional credentials, leave off the -c. For example, 

```bash
docker run -it --rm -v mosquitto_config:/mosquitto/config eclipse-mosquitto:latest mosquitto_passwd /mosquitto/config/passwd wemos
```

## Volumes

It's just easier here to keep configuration for home assistant in local folders.
Home assistant is in config/ and mosquitto is in mosquitto_config/.

## Deploy

Swarm mode does not work because of the "devices" option needed to talk to the USB devices.

Instead use
    docker-compose build
    docker-compose up -d

## Backups

The script backup.sh will do a nightly backup to the Synology when invoked from cron.

## URLs

Normally I run my instance here,

    https://homeassistant.wildsong.biz/


