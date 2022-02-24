FROM alpine

ENV NEWRELIC_ACCOUNT_ID="your_New_Relic_account_id_goes_here"
ENV NEWRELIC_TEMPLATE="<%pri%>%protocol-version% %timestamp:::date-rfc3339% %hostname% %app-name% %procid% %msgid% %structured-data% %msg%"
ENV NEWRELIC_ENDPOINT="newrelic.syslog.nr-data.net"
ENV NEWRELIC_PEERS="*.syslog.nr-data.net"
ENV NEWRELIC_PROTOCOL="tcp"
ENV NEWRELIC_PORT="6514"
ENV RSYSLOG_PORT="514"
ENV RSYSLOG_LOG_FILE="/var/log/syslog"
ENV SSL_CERT="/etc/ssl/certs/ca-certificates.crt"

RUN apk update \
  && apk add gettext openssl rsyslog rsyslog-tls ca-certificates \
  && mkdir -p /etc/rsyslog.d/

COPY templates/*.tpl /etc/rsyslog.d/
COPY entrypoint.sh /
RUN chmod 755 /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["-n"]
