defmodule Gigpillar.Locations.Location do
  use Ecto.Schema
  import Ecto.Changeset

  schema "locations" do
    field :lat, :decimal
    field :lng, :decimal
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(location, attrs) do
    location
    |> cast(attrs, [:name, :lat, :lng])
    |> validate_required([:name, :lat, :lng])
  end
end
