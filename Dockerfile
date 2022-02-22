FROM alpine:latest
COPY requirements.txt /etc/
RUN apk add python3 py3-pip \
&& pip3 install -r /etc/requirements.txt \
&& mkdir -p /etc/rsyslog.d/
COPY templates/*.j2.* /etc/rsyslog.d/
COPY entrypoint.sh environment_to_yaml.py /
RUN chmod 755 /entrypoint.sh /environment_to_yaml.py
ENTRYPOINT /entrypoint.sh
