defmodule Gigpillar.Repo.Migrations.CreateGigs do
  use Ecto.Migration

  def change do
    create table(:gigs) do
      add(:name, :string)
      add(:description, :text)
      add(:date, :utc_datetime)
      add(:location_id, references(:locations, on_delete: :restrict), null: false)
      add(:creator_id, references(:users, on_delete: :nilify_all))

      timestamps()
    end

    create(index(:gigs, [:location_id]))
    create(index(:gigs, [:creator_id]))
  end
end
