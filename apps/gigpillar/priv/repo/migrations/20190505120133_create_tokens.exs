defmodule Gigpillar.Repo.Migrations.CreateTokens do
  use Ecto.Migration

  def change do
    create table(:tokens) do
      add(:type, :string)
      add(:value, :string)
      add(:expires_at, :utc_datetime)

      timestamps()
    end

    create(unique_index(:tokens, [:type, :value]))
  end
end
