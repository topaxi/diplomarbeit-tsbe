defmodule GigpillarWeb.GigController do
  use GigpillarWeb, :controller

  alias Gigpillar.Gigs
  alias Gigpillar.Gigs.Gig

  plug(:fetch_resource)
  plug(:load_and_authorize_resource,
    model: Gig,
    unauthorized_handler: {GigpillarWeb.Helpers, :handle_unauthorized},
    not_found_handler: {GigpillarWeb.Helpers, :handle_not_found}
  )

  def index(conn, _params) do
    gigs = Gigs.list_user_gigs(conn.assigns.current_user.id)

    render(conn, "index.html", gigs: gigs)
  end

  def new(conn, _params) do
    changeset = Gigs.change_gig(%Gig{location: nil, gig_artists: []})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"gig" => gig_params}) do
    gig_params =
      gig_params
      |> Map.put("creator_id", conn.assigns.current_user.id)
      |> Map.put_new("gig_artists", [])
      |> cast_location

    case Gigs.create_gig(gig_params) do
      {:ok, gig} ->
        conn
        |> put_flash(:info, "Gig created successfully.")
        |> redirect(to: Routes.gig_path(conn, :show, gig))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    render(conn, "show.html", gig: conn.assigns.gig)
  end

  def edit(conn, %{"id" => id}) do
    changeset = Gigs.change_gig(conn.assigns.gig)
    render(conn, "edit.html", gig: conn.assigns.gig, changeset: changeset)
  end

  def update(conn, %{"id" => id, "gig" => gig_params}) do
    gig_params = cast_location(gig_params)

    case Gigs.update_gig(conn.assigns.gig, gig_params) do
      {:ok, gig} ->
        conn
        |> put_flash(:info, "Gig updated successfully.")
        |> redirect(to: Routes.gig_path(conn, :show, conn.assigns.gig))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", gig: conn.assigns.gig, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    {:ok, _gig} = Gigs.delete_gig(conn.assigns.gig)

    conn
    |> put_flash(:info, "Gig deleted successfully.")
    |> redirect(to: Routes.gig_path(conn, :index))
  end

  defp cast_location(%{"location" => %{"id" => id}} = gig_params) when id != "null",
    do: gig_params |> Map.put("location", Map.take(gig_params["location"], ["id", "name"]))

  defp cast_location(%{"location" => %{"google_place_id" => place_id}} = gig_params)
       when place_id != "null" do
    case Gigpillar.Locations.get_location_by_google_place_id(place_id) do
      %Gigpillar.Locations.Location{} = location ->
        gig_params |> Map.put("location_id", location.id) |> Map.delete("location")

      nil ->
        Map.put(
          gig_params,
          "location",
          Map.merge(gig_params["location"], get_place_details(place_id))
        )
    end
  end

  defp cast_location(gig_params), do: gig_params

  defp get_place_details(place_id) do
    with {:ok, %{"result" => details}} <-
           Google.Apis.Places.Details.get(place_id, fields: "name,formatted_address,geometry") do
      %{
        "name" => details["name"],
        "address" => details["formatted_address"],
        "lat" => details["geometry"]["location"]["lat"],
        "lng" => details["geometry"]["location"]["lng"]
      }
    end
  end

  defp fetch_resource(%{params: %{"id" => id}} = conn, _opts) do
    Plug.Conn.assign(conn, :gig, Gigs.get_gig!(id))
  end
  defp fetch_resource(conn, _opts), do: conn
end
