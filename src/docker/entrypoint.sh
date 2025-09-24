#!/bin/bash

# DEBUG Info for pipeline run
if [[ $CI_DEBUG == "true" ]]; then
  # print env info
  env
  # expands variables and prints a little + sign before the li
  set -o xtrace
fi
set -eu

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- docker "$@"
fi

# if our command is a valid Docker subcommand, let's invoke it through Docker instead
# (this allows for "docker run docker ps", etc)
if docker help "$1" > /dev/null 2>&1; then
	set -- docker "$@"
fi

cd ~/
exec "$@"
