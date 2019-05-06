defmodule GigpillarWeb.Plug.AssignCurrentUser do
  import Plug.Conn
  import Phoenix.Controller

  def init(opts), do: opts

  def call(conn, _opts) do
    conn
    |> assign(:current_user, get_user(conn))
  end

  def get_user(conn) do
    conn.assigns[:current_user] || get_session(conn, :current_user)
  end
end
