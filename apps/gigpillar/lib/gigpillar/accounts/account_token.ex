defmodule Gigpillar.Accounts.AccountToken do
  use Ecto.Schema
  import Ecto.Changeset

  schema "accounts_tokens" do
    field(:user_id, :id)
    field(:token_id, :id)

    timestamps()
  end

  @doc false
  def changeset(account_token, attrs) do
    account_token
    |> cast(attrs, [:user_id, :token_id])
    |> validate_required([:user_id, :token_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:token_id)
  end
end
