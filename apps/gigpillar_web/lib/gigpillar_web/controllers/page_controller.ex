defmodule GigpillarWeb.PageController do
  use GigpillarWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html",
      page_class: "index",
      city: "Bern",
      gigs: Gigpillar.Gigs.list_latest_gigs()
    )
  end
end
