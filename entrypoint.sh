#!/bin/bash
set -e

rm -f /easy_pallet_api/tmp/pids/server.pid

exec "$@"