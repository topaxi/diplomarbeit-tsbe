defmodule GigpillarWeb.AutocompleteController do
  use GigpillarWeb, :controller
  import Ecto.Query, only: [limit: 2, offset: 2]

  def location(conn, %{"query" => query, "id" => id}) do
    {:ok, response} =
      Google.Apis.Places.autocomplete(query, types: "establishment", sessiontoken: id)

    render(conn, "location.json", locations: response)
  end

  def artist(conn, %{"query" => query}) do
    render(conn, "artist.json", artists: Gigpillar.Artists.search_artists(name: query))
  end

  def city(conn, %{"query" => query}) do
    {:ok, response} = Google.Apis.Places.autocomplete(query, types: "(cities)")
    render(conn, "city.json", cities: response)
  end

  def search(conn, %{"query" => query}) do
    results =
      Gigpillar.Gigs.search_gigs(query)
      |> limit(10)
      |> offset(0)
      |> Gigpillar.Repo.all()

    render(conn, "search.json", results: results)
  end
end
