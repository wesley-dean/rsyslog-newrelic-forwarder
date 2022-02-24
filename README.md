# rsyslog-newrelic-forwarder

[![Semgrep](https://github.com/wesley-dean/rsyslog-newrelic-forwarder/actions/workflows/semgrep.yml/badge.svg)](https://github.com/wesley-dean/rsyslog-newrelic-forwarder/actions/workflows/semgrep.yml) 
[![build_docker_image](https://github.com/wesley-dean/rsyslog-newrelic-forwarder/actions/workflows/build_docker_image.yml/badge.svg)](https://github.com/wesley-dean/rsyslog-newrelic-forwarder/actions/workflows/build_docker_image.yml)
[![MegaLinter](https://github.com/wesley-dean/rsyslog-newrelic-forwarder/actions/workflows/megalinter.yml/badge.svg)](https://github.com/wesley-dean/rsyslog-newrelic-forwarder/actions/workflows/megalinter.yml)

Containerized rsyslog forwarder to push logs to New Relic

## Purpose

This creates an image that will run rsyslogd locally, accept logs
from over the network, and forward them to New Relic.  While the
logs may be spooled locally, they'll only be written to disk when
the forwarder can't keep up.

The image is intended to be very small (18.3MB at the time of
writing) and minimize writes to the filesystem; as a result, it
ought to be suitable for running on an embedded device, a
Raspberry Pi, etc..

## Configuration

Configuration of the container is performed at runtime via
environment variables passed to the container (e.g., `docker
-e NEWRELIC_ACCOUNT_ID=1234567890 [...]`).

### NEWRELIC\_ACCOUNT\_ID

There's an environment variable that must be set in order for
the forwarder to function properly: `NEWRELIC_ACCOUNT_ID`

This variable must have the New Relic account ID so that logs
are correlated with the correct account on the New Relic log
ingestion service.

## Building the Image

The image may be built with the following command:

```sh
docker build -t rsyslog -f Dockerfile .
```

This will build the image starting with an Alpine base.  The
image will be tagged as '`rsyslog`'.

## Running the Forwarder Container

The container may be run with the following command:

```sh
NEWRELIC_LISTEN_PORT=514 \
NEWRELIC_ACCOUNT_ID=0123456789abcdefNRAL \
docker run \
  --detach \
  --env NEWRELIC_ACCOUNT_ID=${NEWRELIC_ACCOUNT_ID?No account id provided} \
  --name rsyslog \
  --expose 0.0.0.0:${NEWRELIC_LISTEN_PORT:-514}:514/tcp \
  --expose 0.0.0.0:${NEWRELIC_LISTEN_PORT:-514}:514/udp \
  --restart unless-stopped \
  rsyslog
```

Note: you must replace '`0123456789abcdefNRAL`' with your actual
New Relic account ID.  If a port other than the default (514) is
required, it may be set using the `NEWRELIC_LISTEN_PORT` variable.
