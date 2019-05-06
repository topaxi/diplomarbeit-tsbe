defmodule GigpillarWeb.GigControllerTest do
  use GigpillarWeb.ConnCase

  alias Gigpillar.Gigs

  @create_attrs %{
    name: "Darkside",
    description: "Gig description",
    picture: "https://example.com/picture.png",
    date: DateTime.utc_now()
  }

  @update_attrs %{
    name: "Darkside 2",
    description: "Gig description 2",
    picture: "https://example.com/picture2.png",
    date: DateTime.utc_now()
  }

  @invalid_attrs %{}

  def fixture(:gig) do
    {:ok, gig} = Gigs.create_gig(@create_attrs)
    gig
  end

  describe "index" do
    @tag :skip
    test "lists all gigs", %{conn: conn} do
      conn = get(conn, Routes.gig_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Gigs"
    end
  end

  describe "new gig" do
    @tag :skip
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.gig_path(conn, :new))
      assert html_response(conn, 200) =~ "New Gig"
    end
  end

  describe "create gig" do
    @tag :skip
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.gig_path(conn, :create), gig: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.gig_path(conn, :show, id)

      conn = get(conn, Routes.gig_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Gig"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.gig_path(conn, :create), gig: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Gig"
    end
  end

  describe "edit gig" do
    setup [:create_gig]

    @tag :skip
    test "renders form for editing chosen gig", %{conn: conn, gig: gig} do
      conn = get(conn, Routes.gig_path(conn, :edit, gig))
      assert html_response(conn, 200) =~ "Edit Gig"
    end
  end

  describe "update gig" do
    setup [:create_gig]

    @tag :skip
    test "redirects when data is valid", %{conn: conn, gig: gig} do
      conn = put(conn, Routes.gig_path(conn, :update, gig), gig: @update_attrs)
      assert redirected_to(conn) == Routes.gig_path(conn, :show, gig)

      conn = get(conn, Routes.gig_path(conn, :show, gig))
      assert html_response(conn, 200)
    end

    @tag :skip
    test "renders errors when data is invalid", %{conn: conn, gig: gig} do
      conn = put(conn, Routes.gig_path(conn, :update, gig), gig: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Gig"
    end
  end

  describe "delete gig" do
    setup [:create_gig]

    @tag :skip
    test "deletes chosen gig", %{conn: conn, gig: gig} do
      conn = delete(conn, Routes.gig_path(conn, :delete, gig))
      assert redirected_to(conn) == Routes.gig_path(conn, :index)

      assert_error_sent(404, fn ->
        get(conn, Routes.gig_path(conn, :show, gig))
      end)
    end
  end

  defp create_gig(_) do
    gig = fixture(:gig)
    {:ok, gig: gig}
  end
end
