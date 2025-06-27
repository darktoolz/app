#!/bin/sh

app=/root/app
if [ -f "$app/docker-entrypoint.sh" ]; then
  exec sh $app/docker-entrypoint.sh "$@"
fi
