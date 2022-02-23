# rsyslog-newrelic-forwarder

Containerized rsyslog forwarder to push logs to New Relic

## Purpose

This creates an image that will run rsyslogd locally, accept logs
from over the network, and forward them to New Relic.  While the
logs may be spooled locally, they'll only be written to disk when
the forwarder can't keep up.

The image is intended to be very small (13.1MB at the time of
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

### RSYSLOG\_PORT

The `RSYSLOG_PORT` environment variable is used to specify the
port that rsyslog should bind to and accept connections on.  By
default, `RSYSLOG_PORT` is set to '`514`', the default port for
rsyslog.  Note: rsyslog is configured to listen on this port for
both TCP and UDP connections.  To change this, either update the
templates (not recommended) or only publish the desired ports
when running `docker run`.
