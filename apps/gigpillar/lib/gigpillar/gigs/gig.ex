defmodule Gigpillar.Gigs.Gig do
  use Ecto.Schema
  use Arc.Ecto.Schema

  import Ecto.Changeset

  schema "gigs" do
    field(:uuid, Ecto.UUID)
    field(:date, :utc_datetime)
    field(:description, :string)
    field(:name, :string)
    field(:tickets, :string)
    field(:picture, Gigpillar.Storage.Uploader.Picture.Type)

    belongs_to(:location, Gigpillar.Locations.Location, on_replace: :nilify)
    belongs_to(:creator, Gigpillar.Accounts.User)

    has_many(:gig_artists, Gigpillar.Gigs.GigArtist,
      on_delete: :delete_all,
      on_replace: :delete
    )

    many_to_many(:artists, Gigpillar.Artists.Artist,
      join_through: Gigpillar.Gigs.GigArtist,
      unique: true
    )

    timestamps()
  end

  @doc false
  def changeset(gig, attrs) do
    gig
    |> cast(attrs, [:name, :description, :date, :tickets, :location_id, :creator_id])
    |> put_change(:uuid, gig.uuid || Ecto.UUID.generate())
    |> cast_attachments(attrs, [:picture])
    |> cast_assoc(:location, required: true)
    |> cast_assoc(:gig_artists, with: &Gigpillar.Gigs.GigArtist.changeset/2)
    |> validate_required([:name, :description, :date])
    |> validate_url(:tickets)
  end

  def picture({file, gig}, version) do
    Gigpillar.Storage.Uploader.Picture.url({file, gig}, version)
  end

  defp validate_url(changeset, field) do
    changeset
    |> validate_change(field, fn _, url ->
      if url == URI.encode(url) |> URI.decode() do
        []
      else
        [{field, "Invalid url"}]
      end
    end)
  end
end
