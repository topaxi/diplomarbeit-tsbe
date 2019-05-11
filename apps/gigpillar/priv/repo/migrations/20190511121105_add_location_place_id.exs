defmodule Gigpillar.Repo.Migrations.AddLocationPlaceId do
  use Ecto.Migration

  def change do
    alter table(:locations) do
      add(:address, :string)
      add(:google_place_id, :string)
    end

    create(unique_index(:locations, [:google_place_id]))
  end
end
