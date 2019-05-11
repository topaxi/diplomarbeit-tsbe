defmodule Gigpillar.Locations.Location do
  use Ecto.Schema
  import Ecto.Changeset

  schema "locations" do
    field(:lat, :decimal)
    field(:lng, :decimal)
    field(:name, :string)
    field(:address, :string)
    field(:google_place_id, :string)

    timestamps()
  end

  @doc false
  def changeset(location, attrs) do
    location
    |> cast(attrs, [
      :name,
      :address,
      :lat,
      :lng,
      :google_place_id
    ])
    |> validate_required([:name, :lat, :lng])
  end
end
