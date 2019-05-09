defmodule GigpillarWeb.GigView do
  use GigpillarWeb, :view

  def json(value) do
    Poison.encode!(value)
  end
end
