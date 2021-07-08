# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :unox, UnoxWeb.Endpoint,
  url: [host: "127.0.0.1"],
  secret_key_base: "GXY040WB33iQc1HBoKPNKd7bwV7X/PDojrinKgZcYLDPY4WmJugWix9CbfZ9YqEI",
  render_errors: [view: UnoxWeb.ErrorView, accepts: ~w(html json)],
  pubsub_server: Unox.PubSub,
  live_view: [
    signing_salt: "xJvUG1PnlouZcILfDGCzIKwli+zdVf1/EBckrM8uJaFK58BmjCC1vVyhnTc6+vfu"
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
