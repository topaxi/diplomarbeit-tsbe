defmodule Gigpillar.Gigs.GigArtist do
  use Ecto.Schema
  import Ecto.Changeset

  schema "gigs_artists" do
    field(:order, :integer)
    field(:plays_at, :time)

    belongs_to(:gig, Gigpillar.Gigs.Gig, on_replace: :delete)
    belongs_to(:artist, Gigpillar.Artists.Artist, on_replace: :delete)
  end

  @doc false
  def changeset(gig_artist, attrs) do
    gig_artist
    |> cast(attrs, [:gig_id, :artist_id, :plays_at, :order])
    |> cast_assoc(:gig)
    |> cast_assoc(:artist)
    |> validate_required([:order])
  end
end
