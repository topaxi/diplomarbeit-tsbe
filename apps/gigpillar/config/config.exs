# Since configuration is shared in umbrella projects, this file
# should only configure the :gigpillar application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

config :gigpillar,
  ecto_repos: [Gigpillar.Repo]

import_config "#{Mix.env()}.exs"
