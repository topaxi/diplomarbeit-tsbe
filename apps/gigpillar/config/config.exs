# Since configuration is shared in umbrella projects, this file
# should only configure the :gigpillar application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

config :gigpillar,
  ecto_repos: [Gigpillar.Repo]

config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

config :arc,
  storage: Arc.Storage.S3,
  bucket: "gigpillar"

config :ex_aws,
  debug_requests: true,
  access_key_id: "minio",
  secret_access_key: "minio123",
  region: "local"

config :ex_aws, :s3,
  scheme: "http://",
  region: "local",
  host: "localhost",
  port: 9000

import_config "#{Mix.env()}.exs"
