defmodule GigpillarWeb.AutocompleteView do
  use GigpillarWeb, :view

  def render("location.json", %{locations: %{"predictions" => predictions}}) do
    predictions
    |> Enum.map(fn p -> Map.take(p, ["description", "place_id"]) end)
  end

  def render("location.json", _params) do
    IO.inspect(_params)
  end
end
