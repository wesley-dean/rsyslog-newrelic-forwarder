#!/bin/sh

DATA_FILENAME="${DATA_FILENAME:-/etc/rsyslog.data.yml}"

python3 /bin/environment_to_yaml.py > "${DATA_FILENAME}"

for template_filename in /etc/rsyslog.d/*.j2.conf ; do
  extension="${template_filename##*.}"
  template_filename_without_extension="${template_filename%%.*}"
  template_filename_without_j2="${template_filename_without_extension%%.*}"
  output_filename="${template_filename_without_j2}.${extension}"

  j2-cli "${template_filename}" < "$DATA_FILENAME" > "$output_filename"
done
