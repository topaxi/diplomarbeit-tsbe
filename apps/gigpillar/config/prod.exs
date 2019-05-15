# Since configuration is shared in umbrella projects, this file
# should only configure the :gigpillar application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

config :arc,
  storage: Arc.Storage.S3,
  bucket: System.get_env("AWS_S3_BUCKET")

config :ex_aws,
  debug_requests: true,
  access_key_id: System.get_env("AWS_ACCESS_KEY_ID"),
  secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY"),
  region: System.get_env("AWS_REGION")

config :ex_aws, :s3,
  scheme: System.get_env("AWS_S3_SCHEME"),
  region: System.get_env("AWS_REGION"),
  host: System.get_env("AWS_S3_HOST"),
  port: System.get_env("AWS_S3_PORT")

config :gigpillar,
  asset_host: System.get_env("GIGPILLAR_ASSET_HOST")

config :gigpillar, Gigpillar.Repo,
  username: System.get_env("POSTGRES_USER"),
  password: System.get_env("POSTGRES_PASSWORD"),
  database: System.get_env("POSTGRES_DB"),
  hostname: System.get_env("POSTGRES_HOSTNAME"),
  pool_size: System.get_env("POSTGRES_POOL_SIZE")

import_config "prod.secret.exs"
