#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
normalizer="${script_dir}/normalize-pages-base-url.sh"

assert_success() {
  local raw_url="$1"
  local expected_base_url="$2"
  local expected_host="$3"
  local output

  output="$(bash "${normalizer}" "${raw_url}")"

  if ! grep -Fqx "base_url=${expected_base_url}" <<<"${output}"; then
    echo "Expected base_url=${expected_base_url} for ${raw_url}"
    exit 1
  fi

  if ! grep -Fqx "host=${expected_host}" <<<"${output}"; then
    echo "Expected host=${expected_host} for ${raw_url}"
    exit 1
  fi
}

assert_failure() {
  local raw_url="$1"

  if bash "${normalizer}" "${raw_url}" >/dev/null 2>&1; then
    echo "Expected normalization to fail for ${raw_url}"
    exit 1
  fi
}

assert_success "http://jamez.dev" "https://jamez.dev/" "jamez.dev"
assert_success "https://jamez.dev/" "https://jamez.dev/" "jamez.dev"
assert_success "http://example.github.io/project" "https://example.github.io/project/" "example.github.io"

assert_failure "jamez.dev"
assert_failure "ftp://jamez.dev"
assert_failure "http:///missing-host"

echo "Pages base URL normalization tests passed"
