FROM alpine:3.7
MAINTAINER adinbied
# Version: 0.1.3.2
RUN apk add --no-cache python3 && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --upgrade pip setuptools && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
	pip3 install influxdb && \
	apk add --no-cache git && \
    rm -r /root/.cache && \
	mkdir /plexdata && \
    cd /plexdata && \
    git clone https://github.com/adinbied/Plex-to-InfluxDB-Extended.git .
	
CMD python /plexdata/plexInfluxdbCollector.py --config /plexdata/config.ini
