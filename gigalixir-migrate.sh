#!/bin/bash
SCRIPT_DIR=$(cd $(dirname "${BASH_SOURCE:-$0}"); pwd)
cd $SCRIPT_DIR
./gigalixir.sh -c 'export APP_NAME=$(gigalixir apps | jq -r ".[]|.unique_name") && gigalixir git:remote $APP_NAME && gigalixir migrate -o "-i /app/.ssh/id_rsa"'
