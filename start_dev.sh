#!/bin/bash
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export RUBYOPT=-Eutf-8

cd "$(dirname "$0")"
bundle exec jekyll server \
  --watch \
  --incremental \
  --baseurl "" \
  --port 4000 \
  --force_polling
