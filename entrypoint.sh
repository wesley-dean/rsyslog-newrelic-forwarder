#!/bin/sh

TEMPLATE_DIRECTORY="$(realpath "${TEMPLATE_DIRECTORY:-templates}")/"
TEMPLATE_PATTERN="${TEMPLATE_PATTERN:-*}"
PREFIX="${PREFIX:-/}"

find "${TEMPLATE_DIRECTORY}" \
  -name "$TEMPLATE_PATTERN" \
  -type f \
  -print \
  | while read -r template_filename ; do

  output_filename="${PREFIX}${template_filename#$TEMPLATE_DIRECTORY}"

  output_directory="$(dirname "$output_filename")"

  if [ ! -d "$output_directory" ] ; then
    mkdir -p "$output_directory"
  fi

  echo "processing '$template_filename' => '$output_filename'" 1>&2
  envsubst < "$template_filename" > "$output_filename"
  
done

rsyslogd "$@"
