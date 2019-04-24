defmodule Gigpillar.Repo do
  use Ecto.Repo,
    otp_app: :gigpillar,
    adapter: Ecto.Adapters.Postgres
end
