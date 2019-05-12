defmodule GigpillarWeb.SearchController do
  use GigpillarWeb, :controller

  import Ecto.Query, only: [limit: 2, offset: 2]

  def search(conn, params) do
    results =
      if has_query(params) do
        Gigpillar.Gigs.search_gigs(params["query"])
        |> limit(^get_limit(params))
        |> offset(^get_offset(params))
        |> Gigpillar.Repo.all()
      else
        []
      end

    IO.inspect(results)

    render(conn, "search.html", results: results)
  end

  defp has_query(%{"query" => query}) do
    query |> String.trim() |> String.length() > 0
  end

  defp get_page(%{"page" => page}) do
    case Integer.parse(page) do
      {integer} -> integer
      _ -> get_page()
    end
  end

  defp get_page(_), do: get_page()
  defp get_page(), do: 1

  defp get_limit(_), do: 10

  defp get_offset(query) do
    (get_page(query) - 1) * get_limit(query)
  end
end
