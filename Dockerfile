FROM alpine:3.17.0

ENV NEWRELIC_ACCOUNT_ID="your_New_Relic_account_id_goes_here"
ENV NEWRELIC_TEMPLATE="<%pri%>%protocol-version% %timestamp:::date-rfc3339% %hostname% %app-name% %procid% %msgid% %structured-data% %msg%"
ENV NEWRELIC_ENDPOINT="newrelic.syslog.nr-data.net"
ENV NEWRELIC_PEERS="*.syslog.nr-data.net"
ENV NEWRELIC_PROTOCOL="tcp"
ENV NEWRELIC_PORT="6514"
ENV RSYSLOG_PORT="514"
ENV RSYSLOG_LOG_FILE="/var/log/syslog"
ENV SSL_CERT="/etc/ssl/certs/ca-certificates.crt"

LABEL org.opencontainers.image.source https://github.com/wesley-dean/rsyslog-newrelic-forwarder

RUN apk update \
  && apk add --no-cache \
    gettext==0.21.1-r1 \
    openssl==3.0.7-r0 \
    rsyslog==8.2210.0-r0 \
    rsyslog-tls==8.2210.0-r0 \
    ca-certificates==20220614-r2 \
  && mkdir -p /etc/rsyslog.d/ /usr/src/app/ \
  && rm -rf /var/cache/apk/

WORKDIR /usr/src/app/

COPY . /usr/src/app/
RUN chmod 755 /usr/src/app/entrypoint.sh

ENTRYPOINT ["/usr/src/app/entrypoint.sh"]
CMD ["-n"]
