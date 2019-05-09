defmodule GigpillarWeb.AutocompleteController do
  use GigpillarWeb, :controller

  def location(conn, %{"query" => query}) do
    {:ok, response} = Google.Apis.Places.autocomplete(query)
    render(conn, "location.json", locations: response)
  end

  def artist(conn, %{"query" => query}) do
    render(conn, "artist.json", artists: Gigpillar.Artists.search_artists(name: query))
  end
end
