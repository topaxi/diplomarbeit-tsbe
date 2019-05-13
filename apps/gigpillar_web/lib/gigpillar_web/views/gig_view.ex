defmodule GigpillarWeb.GigView do
  use GigpillarWeb, :view

  def json(value) do
    Poison.encode!(value)
  end

  def jsonld(%Gigpillar.Gigs.Gig{} = gig) do
    %{
      "@type" => "MusicEvent",
      "name" => gig.name,
      "location" => jsonld(gig.location),
      "startDate" => gig.date,
      "description" => gig.description,
      "image" => Gigpillar.Gigs.Gig.picture({gig.picture, gig}, :original),
      "performer" => Enum.map(gig.gig_artists, &jsonld/1)
    }
  end

  def jsonld(%Gigpillar.Locations.Location{} = location) do
    %{
      "@type" => "MusicVenue",
      "name" => location.name,
      "address" => location.address
    }
  end

  def jsonld(%Gigpillar.Gigs.GigArtist{} = gig_artist) do
    jsonld(gig_artist.artist)
  end

  def jsonld(%Gigpillar.Artists.Artist{} = artist) do
    %{
      "@type" => "MusicGroup",
      "name" => artist.name
    }
  end

  def to_jsonld(thing) do
    json(jsonld(thing) |> Map.put("@context", "http://schema.org"))
  end

  def link_to_calendar(gig) do
    start_date = Timex.format!(gig.date, "{YYYY}{0M}{0D}T{h24}{m}{s}")
    end_date = Timex.format!(Timex.shift(gig.date, hours: 3), "{YYYY}{0M}{0D}T{h24}{m}{s}")
    dates = "#{start_date}/#{end_date}"
    query = URI.encode_query(text: gig.name, dates: dates, location: gig.location.address)
    "https://calendar.google.com/calendar/r/eventedit?#{query}"
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
      %{} = file -> Gigpillar.Gigs.Gig.picture({file, f.data}, :thumbnail)
      _ -> nil
    end
  end

  def osm_url(%{lat: lat, lng: lng} = coords, opts \\ []) do
    "https://www.openstreetmap.org/export/embed.html?..."
  end
end
