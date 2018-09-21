#!/usr/bin/env bash

remove_example () {
  [[ -d "$1/example" ]] && rm -r "$1/example"
}

process_row () {
  IFS="|" read VENDOR PROJECT VERSION <<< "$1"
  echo "Download ${PROJECT}"
  curl -L "${VENDOR}/${PROJECT}/archive/${VERSION}.tar.gz" | tar xz
  mv "${PROJECT}-${VERSION}" "${PROJECT}"
  remove_example "${PROJECT}"
}

readarray -t rows < vendor_list

rm -rf vendor
mkdir -p vendor && cd vendor

for row in "${rows[@]}";do
  [[ ! "${row}" =~ ^[^#].*\|.*\|.*$ ]] && continue
  process_row "${row}"
  echo -e "\n"
done
