FROM alpine:3.15.0

ENV NEWRELIC_ACCOUNT_ID="your_New_Relic_account_id_goes_here"
ENV NEWRELIC_TEMPLATE="<%pri%>%protocol-version% %timestamp:::date-rfc3339% %hostname% %app-name% %procid% %msgid% %structured-data% %msg%"
ENV NEWRELIC_ENDPOINT="newrelic.syslog.nr-data.net"
ENV NEWRELIC_PEERS="*.syslog.nr-data.net"
ENV NEWRELIC_PROTOCOL="tcp"
ENV NEWRELIC_PORT="6514"
ENV RSYSLOG_PORT="514"
ENV RSYSLOG_LOG_FILE="/var/log/messages"
ENV SSL_CERT="/etc/ssl/cert.pem"

RUN apk add --no-cache gettext==0.21-r0 rsyslog==8.2108.0-r1 \
  && mkdir -p /etc/rsyslog.d/
COPY templates/*.tpl.* /etc/rsyslog.d/
COPY entrypoint.sh /
RUN chmod 755 /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
