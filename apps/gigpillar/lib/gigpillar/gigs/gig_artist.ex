defmodule Gigpillar.Gigs.GigArtist do
  use Ecto.Schema
  import Ecto.Changeset

  schema "gigs_artists" do
    field(:order, :integer)
    field(:plays_at, :time)
    field(:gig_id, :id)
    field(:artist_id, :id)
  end

  @doc false
  def changeset(gig_artist, attrs) do
    gig_artist
    |> cast(attrs, [:plays_at, :order])
    |> validate_required([:plays_at, :order])
  end
end
