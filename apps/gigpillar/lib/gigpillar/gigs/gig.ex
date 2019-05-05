defmodule Gigpillar.Gigs.Gig do
  use Ecto.Schema
  import Ecto.Changeset

  schema "gigs" do
    field :date, :utc_datetime
    field :description, :string
    field :name, :string
    field :location_id, :id
    field :creator_id, :id

    timestamps()
  end

  @doc false
  def changeset(gig, attrs) do
    gig
    |> cast(attrs, [:name, :description, :date])
    |> validate_required([:name, :description, :date])
  end
end
