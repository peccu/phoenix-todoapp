#!/bin/bash
SCRIPT_DIR=$(cd $(dirname "${BASH_SOURCE:-$0}"); pwd)
cd $SCRIPT_DIR
set -x
if [ -f ../.env ]
then
  . ../.env
else
  export SECRET_KEY_BASE=$(mix phx.gen.secret)
  export DATABASE_URL=ecto://postgres:postgres@db/app
fi
mix deps.get --only prod
MIX_ENV=prod mix compile
npm run deploy --prefix ./assets
mix phx.digest
MIX_ENV=prod mix release
_build/prod/rel/app/bin/app start
