defmodule GigpillarWeb.GigController do
  use GigpillarWeb, :controller

  alias Gigpillar.Gigs
  alias Gigpillar.Gigs.Gig

  plug(:load_and_authorize_resource,
    model: Gig,
    unauthorized_handler: {GigpillarWeb.Helpers, :handle_unauthorized},
    not_found_handler: {GigpillarWeb.Helpers, :handle_not_found}
  )

  def index(conn, _params) do
    gigs = Gigs.list_gigs()
    render(conn, "index.html", gigs: gigs)
  end

  def new(conn, _params) do
    changeset = Gigs.change_gig(%Gig{location: nil})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"gig" => gig_params}) do
    gig_params = Map.put(gig_params, "creator_id", conn.assigns.current_user.id)

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
    gig = Gigs.get_gig!(id)
    render(conn, "show.html", gig: gig)
  end

  def edit(conn, %{"id" => id}) do
    gig = Gigs.get_gig!(id)
    changeset = Gigs.change_gig(gig)
    render(conn, "edit.html", gig: gig, changeset: changeset)
  end

  def update(conn, %{"id" => id, "gig" => gig_params}) do
    gig = Gigs.get_gig!(id)

    gig_params = cast_location(gig_params)

    case Gigs.update_gig(gig, gig_params) do
      {:ok, gig} ->
        conn
        |> put_flash(:info, "Gig updated successfully.")
        |> redirect(to: Routes.gig_path(conn, :show, gig))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", gig: gig, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    gig = Gigs.get_gig!(id)
    {:ok, _gig} = Gigs.delete_gig(gig)

    conn
    |> put_flash(:info, "Gig deleted successfully.")
    |> redirect(to: Routes.gig_path(conn, :index))
  end

  defp should_fetch_place_details(%{"location" => %{"google_place_id" => place_id}}) do
    {success} = Gigpillar.Locations.get_location_by_google_place_id(place_id)
    success == :error
  end

  defp cast_location(%{"location" => %{"id" => id}} = gig_params) when is_number(id),
    do: gig_params

  defp cast_location(%{"location" => %{"google_place_id" => place_id}} = gig_params) do
    case Gigpillar.Locations.get_location_by_google_place_id(place_id) do
      {:ok, location} ->
        Kernel.put_in(gig_params, ["location", "id"], location.id)

      _ ->
        Map.put(
          gig_params,
          "location",
          Map.merge(gig_params["location"], get_place_details(place_id))
        )
    end
  end

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
end
