defmodule Gigpillar.Repo.Migrations.CreateGigsGenres do
  use Ecto.Migration

  def change do
    create table(:gigs_genres) do
      add(:gig_id, references(:gigs, on_delete: :delete_all), null: false)
      add(:genre_id, references(:genres, on_delete: :delete_all), null: false)
    end

    create(unique_index(:gigs_genres, [:gig_id, :genre_id]))
  end
end
