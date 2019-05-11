defmodule GigpillarWeb.GigView do
  use GigpillarWeb, :view

  def json(value) do
    Poison.encode!(value)
  end

  def value(f, :location) do
    input_value(f, :location)
    |> Map.take([:id, :name, :google_place_id])
    |> json()
  end

  def value(f, :gig_artists) do
    IO.inspect(input_value(f, :gig_artists))

    input_value(f, :gig_artists)
    |> Enum.map(fn gig_artist ->
      gig_artist
      |> Map.take([:order, :plays_at])
      |> Map.put(:id, gig_artist.artist.id)
      |> Map.put(:name, gig_artist.artist.name)
    end)
    |> json()
  end
end
