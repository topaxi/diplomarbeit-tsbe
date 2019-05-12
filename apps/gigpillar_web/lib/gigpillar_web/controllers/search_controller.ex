defmodule GigpillarWeb.SearchController do
  use GigpillarWeb, :controller

  import Ecto.Query, only: [limit: 2, offset: 2]

  def search(conn, params) do
    results =
      if has_query(params) do
        Gigpillar.Gigs.search_gigs(params["query"],
          from: parse_date_param(params["from"]),
          to: parse_date_param(params["to"]),
          genre: params["genre"]
        )
        |> limit(^get_limit(params))
        |> offset(^get_offset(params))
        |> Gigpillar.Repo.all()
      else
        []
      end

    conn =
      conn
      |> Map.put(
        :params,
        conn.params
        |> Map.put_new(
          "from",
          Date.utc_today()
          |> Date.to_iso8601()
        )
      )

    render(conn, "search.html",
      results: results,
      genres: Gigpillar.Genres.list_genres()
    )
  end

  defp parse_date_param(date_str) do
    case Elixir.Timex.Parse.DateTime.Parser.parse(date_str || "", "{ISOdate}") do
      {:ok, date} -> date
      _ -> nil
    end
  end

  defp has_query(%{"query" => query}) do
    query |> String.trim() |> String.length() > 0
  end

  defp has_query(_), do: false

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
