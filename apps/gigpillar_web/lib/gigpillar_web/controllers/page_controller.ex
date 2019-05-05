defmodule GigpillarWeb.PageController do
  use GigpillarWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html",
      page_class: 'index',
      current_user: get_session(conn, :current_user)
    )
  end
end
