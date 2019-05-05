defmodule Gigpillar.Repo.Migrations.AddGigImage do
  use Ecto.Migration

  def change do
    alter table(:gigs) do
      add(:picture, :string)
    end
  end
end
