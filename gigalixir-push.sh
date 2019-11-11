#!/bin/bash
SCRIPT_DIR=$(cd $(dirname "${BASH_SOURCE:-$0}"); pwd)
cd $SCRIPT_DIR
# .gigalixir-run.sh -c 'export APP_NAME=$(gigalixir apps | jq -r ".[]|.unique_name") && gigalixir git:remote $APP_NAME && git -c http.extraheader="GIGALIXIR-CLEAN: true" push -f gigalixir master'
./gigalixir.sh -c 'export APP_NAME=$(gigalixir apps | jq -r ".[]|.unique_name") && gigalixir git:remote $APP_NAME && git push -f gigalixir master'
