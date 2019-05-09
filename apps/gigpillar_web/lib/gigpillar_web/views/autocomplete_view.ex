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
end
