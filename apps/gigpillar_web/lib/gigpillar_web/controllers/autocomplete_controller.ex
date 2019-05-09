defmodule GigpillarWeb.AutocompleteController do
  use GigpillarWeb, :controller

  def location(conn, params) do
    {:ok, response} = Google.Apis.Places.autocomplete(params["query"])
    render(conn, "location.json", locations: response)
  end

  def artist(conn, %{"query" => query}) do
  end
end
