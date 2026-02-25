#!/bin/bash
set -e

# Start cron in the background so logrotate runs daily
cron

# Hand off to the official MariaDB entrypoint
exec docker-entrypoint.sh "$@"
