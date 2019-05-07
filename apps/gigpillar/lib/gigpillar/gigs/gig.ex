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

    timestamps()
  end

  @doc false
  def changeset(gig, attrs) do
    gig
    |> cast(attrs, [:name, :description, :picture, :date])
    |> cast_assoc(:location, required: true)
    |> cast_assoc(:creator)
    |> validate_required([:name, :description, :date])
  end
end
