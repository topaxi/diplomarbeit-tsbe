defmodule Gigpillar.Repo.Migrations.CreateGigsArtists do
  use Ecto.Migration

  def change do
    create table(:gigs_artists) do
      add(:plays_at, :time)
      add(:order, :integer)
      add(:gig_id, references(:gigs, on_delete: :delete_all), null: false)
      add(:artist_id, references(:artists, on_delete: :restrict), null: false)
    end

    create(unique_index(:gigs_artists, [:gig_id, :artist_id]))
  end
end
