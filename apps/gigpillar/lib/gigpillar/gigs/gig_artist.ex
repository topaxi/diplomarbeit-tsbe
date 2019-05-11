defmodule Gigpillar.Gigs.GigArtist do
  use Ecto.Schema
  import Ecto.Changeset

  schema "gigs_artists" do
    field(:order, :integer)
    field(:plays_at, :time)

    belongs_to(:gig, Gigpillar.Gigs.Gig)
    belongs_to(:artist, Gigpillar.Artists.Artist)
  end

  @doc false
  def changeset(gig_artist, attrs) do
    gig_artist
    |> cast(attrs, [:plays_at, :order])
    |> validate_required([:plays_at, :order])
  end
end
