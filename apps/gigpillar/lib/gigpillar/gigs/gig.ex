defmodule Gigpillar.Gigs.Gig do
  use Ecto.Schema
  import Ecto.Changeset

  schema "gigs" do
    field(:date, :utc_datetime)
    field(:description, :string)
    field(:name, :string)
    field(:picture, :string)

    belongs_to(:location, Gigpillar.Locations.Location)
    belongs_to(:creator, Gigpillar.Accounts.User)

    has_many(:gig_artists, Gigpillar.Gigs.GigArtist)

    many_to_many(:artists, Gigpillar.Artists.Artist,
      join_through: Gigpillar.Gigs.GigArtist,
      unique: true
    )

    timestamps()
  end

  @doc false
  def changeset(gig, attrs) do
    gig
    |> cast(attrs, [:name, :description, :picture, :date, :location_id, :creator_id])
    |> cast_assoc(:location, required: true)
    |> cast_assoc(:creator)
    |> validate_required([:name, :description, :date])
  end
end
