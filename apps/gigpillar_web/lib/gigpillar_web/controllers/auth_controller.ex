defmodule GigpillarWeb.AuthController do
  use GigpillarWeb, :controller

  plug(Ueberauth)

  alias Gigpillar.Accounts
  alias Gigpillar.Accounts.User
  alias Ueberauth.Strategy.Helpers

  def request(conn, _params) do
    if get_session(conn, :current_user) do
      redirect(conn, to: "/")
    else
      render(conn, "login.html", callback_url: Helpers.callback_url(conn))
    end
  end

  def register(conn, _params) do
    if get_session(conn, :current_user) do
      redirect(conn, to: "/")
    else
      render(conn, "register.html", callback_url: "/auth/identity/register_callback")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_failure: fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/auth/identity")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    with %User{} = user <- Accounts.get_user_by_email(auth.uid),
         {:ok, _} <- {:ok, nil} do
      conn
      |> put_session(:current_user, user)
      |> configure_session(renew: true)
      |> put_flash(:info, "Successfully authenticated.")
      |> redirect(to: "/")
    else
      nil ->
        conn
        |> put_flash(:error, "User not found")
        |> redirect(to: "/auth/identity")

      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/auth/identity")

      {:error} ->
        conn
        |> put_flash(:error, "Something went wrong")
        |> redirect(to: "/auth/identity")
    end
  end

  def register_callback(conn, params) do
    case Accounts.register_user(params) do
      {:ok, user} ->
        conn
        |> put_session(:current_user, user)
        |> configure_session(renew: true)
        |> redirect(to: "/")

      _ ->
        conn
        |> put_flash(:error, "Something went wrong")
        |> redirect(to: "/auth/identity/register")
    end
  end
end
