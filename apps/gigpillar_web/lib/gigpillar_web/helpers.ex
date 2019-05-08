defmodule GigpillarWeb.Helpers do
  import Plug.Conn, only: [halt: 1]
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]

  def handle_unauthorized(conn) do
    conn
    |> put_flash(:error, "You are not allowed to view this page!")
    |> redirect(to: "/")
    |> halt
  end

  def not_found_handler(conn) do
    conn
    |> put_flash(:error, "Resource not found!")
    |> redirect(to: "/")
    |> halt
  end
end
