defmodule GigpillarWeb.AutocompleteView do
  use GigpillarWeb, :view

  def render("location.json", %{locations: %{"predictions" => predictions}}) do
    predictions
    |> Enum.map(fn p -> Map.take(p, ["description", "place_id"]) end)
  end

  def render("artist.json", %{artists: artists}) do
    artists
    |> Enum.map(fn a -> Map.take(a, [:id, :name]) end)
  end

  def render("city.json", %{cities: %{"predictions" => predictions}}) do
    predictions
    |> Enum.map(fn p -> Map.take(p, ["description", "place_id"]) end)
  end

  def render("search.json", %{results: results}) do
    %{results: results |> Enum.map(&render_gig/1)}
  end

  defp render_gig(gig) do
    gig
    |> Map.take([:id, :name, :date])
    |> Map.put(:location, render_location(gig.location))
    |> Map.put(:artists, Enum.map(gig.artists, &render_artist/1))
  end

  defp render_artist(artist) do
    artist
    |> Map.take([:name])
  end

  defp render_location(location) do
    location
    |> Map.take([:name, :address])
  end
end
