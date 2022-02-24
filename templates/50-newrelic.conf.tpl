# load modules
# module(load="builtin:omfwd")
module(load="imudp")
module(load="imtcp")
# module(load="imfile" PollingInterval="10")

# template expected by the New Relic Syslog endpoint
template(
  name="NRLogFormat"
  type="string"
  string="${NEWRELIC_ACCOUNT_ID} ${NEWRELIC_TEMPLATE}\n"
)

## monitor local logs
#input(
#  type="imfile"
#  File="${RSYSLOG_LOG_FILE}"
#  Tag="syslog"
#  ruleset="newrelic"
#)

# accept remote TCP logs
input(
  type="imtcp"
  port="${RSYSLOG_PORT}"
  ruleset="newrelic"
 )

# accept remote UDP logs
input(
  type="imudp"
  port="${RSYSLOG_PORT}"
  ruleset="newrelic"
)

# configure TLS
global(
  DefaultNetstreamDriver="gtls"
  DefaultNetstreamDriverCAFile="${SSL_CERT}"
)

# forward logs to New Relic
ruleset(name="newrelic") {
  action(
    type="omfwd"
    target="${NEWRELIC_ENDPOINT}"
    port="${NEWRELIC_PORT}"
    protocol="${NEWRELIC_PROTOCOL}"
    template="NRLogFormat"
    action.resumeRetryCount="-1"
    queue.type="linkedList"
    queue.saveOnShutdown="on"
    queue.maxDiskSpace="1g"
    queue.fileName="forwardrule"
    ResendLastMSGOnReconnect="on"
    StreamDriver="gtls"
    StreamDriverAuthMode="x509/name"
    StreamDriverPermittedPeers="${NEWRELIC_PEERS}"
    StreamDriverMode="1"
  )
}