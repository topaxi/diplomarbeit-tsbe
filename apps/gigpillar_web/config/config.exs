# Since configuration is shared in umbrella projects, this file
# should only configure the :gigpillar_web application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# General application configuration
config :gigpillar_web,
  ecto_repos: [Gigpillar.Repo],
  generators: [context_app: :gigpillar],
  default_city: System.get_env("GIGPILLAR_WEB_DEFAULT_CITY") || "Zurich"

# Configures the endpoint
config :gigpillar_web, GigpillarWeb.Endpoint,
  url: [host: System.get_env("GIGPILLAR_WEB_HOST") || "localhost"],
  secret_key_base:
    System.get_env("GIGPILLAR_WEB_SECRET_KEY_BASE") ||
      "wcR6neHuJjwErwFAbZPLUPGj5yo3ciue4dLRNz6ECwQImSGLYhL0T5PexUfyx/zC",
  render_errors: [view: GigpillarWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: GigpillarWeb.PubSub, adapter: Phoenix.PubSub.PG2]

config :ueberauth, Ueberauth,
  providers: [
    identity:
      {Ueberauth.Strategy.Identity,
       [
         callback_methods: ["POST"],
         uid_field: :email,
         nickname_field: :username
       ]}
  ]

config :plug_session_redis, :config,
  name: :gigpillar_sessions,
  pool: [size: 2, max_overflow: 5],
  redis: [
    host: System.get_env("REDIS_HOST") || "127.0.0.1",
    port: System.get_env("REDIS_PORT") || 6379
  ]

config :canary, repo: Gigpillar.Repo

config :google_api_client,
  api_key: System.get_env("GOOGLE_API_KEY")

config :geolix,
  databases: [
    %{
      id: :mmdb2,
      adapter: Geolix.Adapter.MMDB2,
      source: System.get_env("GEOIP_DATABASE_FILE")
    }
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
