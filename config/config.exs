# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :my_app,
  ecto_repos: [MyApp.Repo]

# Configures the endpoint
config :my_app, MyAppWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "1v00nP3IsAj/6aplT3rJhvUBi06IkAc9L+mtmKC5AwvzeWpmk6wEPjMrUDC+GI0F",
  render_errors: [view: MyAppWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: MyApp.PubSub, adapter: Phoenix.PubSub.PG2],
  # mix phx.gen.secret 32
  live_view: [signing_salt: "KLwLvixJwFb4Neq1NKqD9iTGJ1raO1vy"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
