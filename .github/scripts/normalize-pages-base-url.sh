#!/usr/bin/env bash

set -euo pipefail

raw_url="${1-}"

if [[ -z "${raw_url}" ]]; then
  echo "::error::GitHub Pages base URL is empty"
  exit 1
fi

if [[ "${raw_url}" =~ [[:space:]] ]] || [[ "${raw_url}" == *"?"* ]] || [[ "${raw_url}" == *"#"* ]]; then
  echo "::error::GitHub Pages base URL contains unsupported characters"
  exit 1
fi

case "${raw_url}" in
  http://*)
    base_url="https://${raw_url#http://}"
    ;;
  https://*)
    base_url="${raw_url}"
    ;;
  *)
    echo "::error::GitHub Pages base URL must use HTTP or HTTPS"
    exit 1
    ;;
esac

base_url="${base_url%/}/"
authority_and_path="${base_url#https://}"
host="${authority_and_path%%/*}"

if [[ -z "${host}" ]] || [[ "${host}" == *"@"* ]]; then
  echo "::error::GitHub Pages base URL does not contain a valid host"
  exit 1
fi

printf 'base_url=%s\n' "${base_url}"
printf 'host=%s\n' "${host}"
