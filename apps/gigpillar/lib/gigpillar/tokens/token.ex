defmodule Gigpillar.Tokens.Token do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tokens" do
    field :expires_at, :utc_datetime
    field :type, :string
    field :value, :string

    timestamps()
  end

  @doc false
  def changeset(token, attrs) do
    token
    |> cast(attrs, [:type, :value, :expires_at])
    |> validate_required([:type, :value, :expires_at])
  end
end
