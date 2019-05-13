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
      "performer" => Enum.map(gig.gig_artists, &jsonld/1),
      "offers" => jsonld(:offer, gig.tickets)
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

  def jsonld(:offer, nil), do: nil

  def jsonld(:offer, tickets) do
    %{
      "@type" => "Offer",
      "url" => tickets
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
    |> Enum.filter_map(
      fn ch ->
        case ch do
          %{artist: _} -> true
          _ -> false
        end
      end,
      fn gig_artist ->
        gig_artist
        |> Map.take([:order, :plays_at])
        |> Map.put(:id, gig_artist.artist.id)
        |> Map.put(:name, gig_artist.artist.name)
      end
    )
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

  defp dec2float(d) do
    d.coef * :math.pow(10, d.exp) * d.sign
  end

  defp rad2deg(rad) do
    rad * 180 / :math.pi()
  end

  defp deg2rad(deg) do
    deg * :math.pi() / 180
  end

  defp lng2tile(lng, zoom) do
    :math.floor((lng + 180) / 360 * :math.pow(2, zoom))
  end

  defp lat2tile(lat, zoom) do
    :math.floor(
      (1 - :math.log(:math.tan(deg2rad(lat)) + 1 / :math.cos(deg2rad(lat))) / :math.pi()) / 2 *
        :math.pow(2, zoom)
    )
  end

  defp get_tile(lat, lng, zoom) do
    {lat2tile(lat, zoom), lng2tile(lng, zoom)}
  end

  defp get_lat_lng(xtile, ytile, zoom) do
    n = :math.pow(2, zoom)
    lat_deg = rad2deg(:math.atan(:math.sinh(:math.pi() * (1 - 2 * ytile / n))))
    lng_deg = xtile / n * 360 - 180
    {lat_deg, lng_deg}
  end

  # https://gis.stackexchange.com/questions/42998/how-to-get-bounding-box-from-coordinates-latitude-longitude-zoom-level-and-s
  def osm_bbox(%{lat: lat, lng: lng}, opts \\ []) do
    zoom = opts[:zoom] || 10
    width = opts[:width] || 425
    height = opts[:height] || 350
    tile_size = 256

    lat = dec2float(lat)
    lng = dec2float(lng)

    {ytile, xtile} = get_tile(lat, lng, zoom)

    xtile_s = (xtile * tile_size - width / 2) / tile_size
    ytile_s = (ytile * tile_size - height / 2) / tile_size
    xtile_e = (xtile * tile_size + width / 2) / tile_size
    ytile_e = (ytile * tile_size + height / 2) / tile_size

    {lat_s, lng_s} = get_lat_lng(xtile_s, ytile_s, zoom)
    {lat_e, lng_e} = get_lat_lng(xtile_e, ytile_e, zoom)

    "#{lng_s},#{lat_s},#{lng_e},#{lat_e}"
  end

  def osm_url(%{lat: lat, lng: lng} = coords, opts \\ []) do
    "https://www.openstreetmap.org/export/embed.html?bbox=#{osm_bbox(coords, opts)}&marker=#{lat},#{
      lng
    }&layer=mapnik"
  end
end
