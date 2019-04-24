# Since configuration is shared in umbrella projects, this file
# should only configure the :gigpillar_web application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# General application configuration
config :gigpillar_web,
  ecto_repos: [Gigpillar.Repo],
  generators: [context_app: :gigpillar]

# Configures the endpoint
config :gigpillar_web, GigpillarWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "OJnY+aiLLv/irP92vuF6KxLuMiIp2oySfogRBEmP/QYmr5b0mPW6wqRhkX/BSSXO",
  render_errors: [view: GigpillarWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: GigpillarWeb.PubSub, adapter: Phoenix.PubSub.PG2]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"