#!/bin/sh
set -e

if [ "${1}" = "pm2-runtime" ]; then
  echo "running yarn install"
  yarn install
fi

if [ "${1#-}" != "${1}" ] || [ -z "$(command -v "${1}")" ]; then
  set -- node "$@"
fi

exec "$@"
