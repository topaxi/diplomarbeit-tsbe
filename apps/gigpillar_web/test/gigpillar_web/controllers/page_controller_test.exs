defmodule GigpillarWeb.PageControllerTest do
  use GigpillarWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Add Gig"
  end
end
