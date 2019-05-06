defmodule Gigpillar.Gigs.GigGenre do
  use Ecto.Schema
  import Ecto.Changeset

  schema "gigs_genres" do
    field(:gig_id, :id)
    field(:genre_id, :id)
  end

  @doc false
  def changeset(gig_genre, attrs) do
    gig_genre
    |> cast(attrs, [])
    |> validate_required([])
  end
end
