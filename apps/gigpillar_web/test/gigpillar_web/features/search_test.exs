defmodule GigpillarWeb.Features.SearchTest do
  use GigpillarWeb.FeatureCase, async: false

  import Wallaby.Query

  setup do
    Code.eval_file("../../../../gigpillar/priv/repo/test_seeds.exs", __DIR__)
    :ok
  end

  test "search location", %{session: session} do
    session
    |> visit("/")
    |> fill_in(text_field("search"), with: "Dachstock")
    |> send_keys([:enter])
    |> assert_has(css(".page-search-result > li", count: 1))
  end

  test "search artist", %{session: session} do
    session
    |> visit("/")
    |> fill_in(text_field("search"), with: "Mobina")
    |> send_keys([:enter])
    |> assert_has(css(".page-search-result > li", count: 1))
    |> assert_has(css(".page-search-result-artists li", count: 1, text: "Mobina Galore"))
  end

  test "search city", %{session: session} do
    session
    |> visit("/")
    |> fill_in(text_field("search"), with: "Bern")
    |> send_keys([:enter])
    |> assert_has(css(".page-search-result > li", count: 1))
    |> assert_has(css(".page-search-result-artists li", count: 2))
  end

  @tag :skip
  test "search genre", %{session: session} do
    session
  end
end
