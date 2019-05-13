defmodule Gigpillar.Repo.Migrations.AddGigImage do
  use Ecto.Migration

  def change do
    alter table(:gigs) do
      add(:uuid, :uuid)
      add(:picture, :string)
    end
  end
end
