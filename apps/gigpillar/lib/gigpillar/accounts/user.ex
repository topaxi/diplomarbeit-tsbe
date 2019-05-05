defmodule Gigpillar.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:email, :string)
    field(:username, :string)

    field(:password, :string)
    field(:password_confirmation, :string, virtual: true)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password])
    |> validate_required([:username, :password])
    |> validate_email
  end

  def register_changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password, :password_confirmation])
    |> validate_required([:username, :password])
    |> validate_password
    |> hash_password
  end

  defp validate_password(changeset) do
    changeset
    |> validate_length(:password, min: 8)
    |> validate_confirmation(:password)
  end

  defp validate_email(changeset) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end

  defp hash_password(%{valid?: false} = changeset), do: changeset

  defp hash_password(%{valid?: true} = changeset) do
    changeset
    |> Ecto.Changeset.put_change(
      :password,
      Argon2.add_hash(Ecto.Changeset.get_field(changeset, :password))
    )
  end
end
