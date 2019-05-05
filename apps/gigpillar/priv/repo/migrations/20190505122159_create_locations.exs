defmodule Gigpillar.Repo.Migrations.CreateLocations do
  use Ecto.Migration

  def change do
    create table(:locations) do
      add(:name, :string, null: false)
      add(:lat, :decimal, null: false)
      add(:lng, :decimal, null: false)

      timestamps()
    end
  end
end
