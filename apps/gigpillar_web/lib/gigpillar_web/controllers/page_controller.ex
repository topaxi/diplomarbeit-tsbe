defmodule GigpillarWeb.PageController do
  use GigpillarWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html", page_class: 'index', city: "Bern", gigs: [])
  end
end
