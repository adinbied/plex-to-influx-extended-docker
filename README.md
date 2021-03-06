# plex-to-influx-extended
Repo for dockerized [KurzonDax/Plex-to-InfluxDB-Extended](https://github.com/KurzonDax/Plex-to-InfluxDB-Extended.git)

This docker image is currently under active development and may have bugs that are updated.

## About

The plex-to-influx-extended python script is a fork of the original awesome work by github user
[barrycarey](https://github.com/barrycarey) with [Plex-Data-Collector-For-InfluxDB](https://github.com/barrycarey/Plex-Data-Collector-For-InfluxDB).

However, the original script didn't collect some of the info that I wanted to include in my [Grafana](https://grafana.com/)
dashboard.  My goal is not to completely replace the functionality of something like [Tautulli](http://tautulli.com/),
Instead, I am more focused on providing more info about what is currently streaming that what the original
script offered.  A list of all available fields (aka points) and tags can be found on my github repo for
the [plex-to-influx-extended script](https://github.com/KurzonDax/Plex-to-InfluxDB-Extended.git).

## Usage

1. Download the example config file from the [github repo](https://github.com/KurzonDax/plex-to-influx-extended-docker/plex-to-influx-extended-docker/config.ini).
2. Edit the config file to insert the url of your InfluxDB instance, database name, username, and password.
You will also need to enter your Plex server info in the appropriate fields.  Full explanation of config file options is provided below.
3. Use `docker run` to start the container. Be sure to modify the following with the path to
your local, edited copy of config.ini:

```
docker run --name plexdata \
    -v <path to local config file>/config.ini:/plexdata/config.ini \
    -v /etc/timezone:/etc/timezone:ro \
    -v /etc/localtime:/etc/localtime:ro \
    kurzondax/plex-to-influx-extended
```

Optionally, if you would like to have direct access to the output log file generated by
the python script, you can create an empty file using `touch output.log` and mount that file
to `/plexdata/output.log` by adding
 ```
 -v <path/to/local/>output.log:/plexdata/output.log
 ```

#### Notes
* Logging to stdout and stderr is not working correctly.  I hope to address this
in future update.
* There is no functionality to temporarily store measurements in cases where influxdb is unavailable. This
is also on my list of future enhancements.
* Currently, the python script assumes your plex server is using the default port 32400. I will be adding
an option to specify a different port soon.

## CONFIG.INI Description

#### GENERAL
|Key            |Description                                                                                                         |
|:--------------|:-------------------------------------------------------------------------------------------------------------------|
|Delay          |Delay between updating metrics                                                                                      |
|Output         |Write console output while tool is running. (Not working currently)                                                                          |
#### INFLUXDB
|Key            |Description                                                                                                         |
|:--------------|:-------------------------------------------------------------------------------------------------------------------|
|Address        |IP address or FQDN of influxdb server                                                                               |
|Port           |InfluxDB port to connect to.  8086 in most cases.                                                                    |
|Database       |Database to write collected stats to                                                                                |
|Username       |User that has access to the database                                                                                |
|Password       |Password for above user                                                                                             |
#### PLEX
|Key            |Description                                                                                                         |
|:--------------|:-------------------------------------------------------------------------------------------------------------------|
|Username       |Plex username                                                                                                       |
|Password       |Plex Password                                                                                                       |
|Servers        |A comma separated list of servers you wish to pull data from.                                                       |
#### LOGGING
|Key            |Description                                                                                                         |
|:--------------|:-------------------------------------------------------------------------------------------------------------------|
|Enable         |Output logging messages to provided log file                                                                        |
|Level          |Minimum type of message to log.  Valid options are: critical, error, warning, info, debug                           |
|LogFile        |File to log messages to.  Can be relative or absolute path                                                          |
|CensorLogs     |Censor certain things like server names and IP addresses from logs                                                  |

## Docker Compose Example

```
version: 3
services:
    plex-to-influx-extended:
        container_name: plexdata
        volumes:
            - '<path/to/local>/config.ini:/plexdata/config.ini'
            - '/etc/timezone:/etc/timezone:ro'
            - '/etc/localtime:/etc/localtime:ro'
        image: kurzondax/plex-to-influx-extended
```

## Issues

Any issues with getting the docker container running should be logged under the github
repo for the [docker image](https://github.com/KurzonDax/plex-to-influx-extended-docker/issues).

Issues with the python script itself should be logged under the
[Plex-to-InfluxDB-Extended](https://github.com/KurzonDax/Plex-to-InfluxDB-Extended/issues)
repo on github.

