defmodule GigpillarWeb.Plug.UserLocation do
  import Plug.Conn
  import Phoenix.Controller

  def init(opts), do: opts

  def call(conn, _opts) do
    conn
    |> assign(:current_user_location, get_user_location(conn))
    |> IO.inspect()
  end

  def get_user_location(conn) do
    with nil <- get_session(conn, :current_user_location),
         %{mmdb2: %{city: %{name: name}}} <- Geolix.lookup(conn.remote_ip) do
      name
    else
      %{mmdb2: nil} -> Application.get_env(:gigpillar_web, :default_city)
      location -> location
    end
  end
end
