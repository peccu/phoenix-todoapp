## Gigalixir config with mix release version
# https://blog.gigalixir.com/elixir-releases-on-gigalixir/
# https://gigalixir.readthedocs.io/en/latest/main.html#modifying-existing-app-with-mix
# https://hexdocs.pm/phoenix/releases.html
# $ export SECRET_KEY_BASE=$(mix phx.gen.secret)
# $ export DATABASE_URL=ecto://USER:PASS@HOST/database
# $ mix deps.get --only prod
# $ MIX_ENV=prod mix compile
# $ npm run deploy --prefix ./assets
# $ mix phx.digest
# $ MIX_ENV=prod mix release
# $ _build/prod/rel/app/bin/app start
import Config

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

config :app, AppWeb.Endpoint,
  url: [host: System.get_env("APP_NAME", "APP_NAME_NOT_SPECIFIED") <> ".gigalixirapp.com", port: 80],
  secret_key_base: secret_key_base,
  server: true

database_url =
  System.get_env("DATABASE_URL") ||
    raise """
    environment variable DATABASE_URL is missing.
    For example: ecto://USER:PASS@HOST/DATABASE
    """
config :app, App.Repo,
  url: database_url,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "2")
