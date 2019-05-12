defmodule GigpillarWeb.GigView do
  use GigpillarWeb, :view

  def json(value) do
    Poison.encode!(value)
  end

  def value(f, :location) do
    case input_value(f, :location) do
      nil ->
        "null"

      location ->
        location
        |> Map.take([:id, :name, :google_place_id])
        |> json()
    end
  end

  def value(f, :gig_artists) do
    input_value(f, :gig_artists)
    |> Enum.map(fn gig_artist ->
      gig_artist
      |> Map.take([:order, :plays_at])
      |> Map.put(:id, gig_artist.artist.id)
      |> Map.put(:name, gig_artist.artist.name)
    end)
    |> json()
  end

  def value(f, :date) do
    case input_value(f, :date) do
      %DateTime{} = datetime -> DateTime.to_iso8601(datetime)
      _ -> nil
    end
  end

  def value(f, :picture) do
    case input_value(f, :picture) do
      %{} = file -> Gigpillar.Storage.Uploader.Picture.url(file)
      _ -> nil
    end
  end
end
