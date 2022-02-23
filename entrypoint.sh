#!/bin/sh

TEMPLATE_DIRECTORY="${TEMPLATE_DIRECTORY:-templates/}"
TEMPLATE_PATTERN="${TEMPLATE_PATTERN:-*.tpl.*}"
PREFIX="${PREFIX:-./dist/}"

remove_secondary_extension() {
  filename="${1?Error: no filename passed}"
  extension="${filename##*.}"
  filename_without_extension="${filename%.*}"
  filename_without_secondary="${filename_without_extension%.*}"
  output_filename="${filename_without_secondary}.${extension}"
  printf "%s" "${output_filename}"
}

for template_filename in "${TEMPLATE_DIRECTORY}"$TEMPLATE_PATTERN ; do
  output_filename="${PREFIX}$(remove_secondary_extension "$template_filename")"
  output_directory="$(dirname "$output_filename")"

  if [ ! -d "$output_directory" ] ; then
    mkdir -p "$output_directory"
  fi

  echo "processing '$template_filename' => '$output_filename'"

  envsubst < "$template_filename" > "$output_filename"
  
done

rsyslogd -n
