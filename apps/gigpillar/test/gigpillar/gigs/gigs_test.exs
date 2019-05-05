defmodule Gigpillar.GigsTest do
  use Gigpillar.DataCase

  alias Gigpillar.Gigs

  describe "gigs" do
    alias Gigpillar.Gigs.Gig

    @valid_attrs %{date: "2010-04-17T14:00:00Z", description: "some description", name: "some name"}
    @update_attrs %{date: "2011-05-18T15:01:01Z", description: "some updated description", name: "some updated name"}
    @invalid_attrs %{date: nil, description: nil, name: nil}

    def gig_fixture(attrs \\ %{}) do
      {:ok, gig} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Gigs.create_gig()

      gig
    end

    test "list_gigs/0 returns all gigs" do
      gig = gig_fixture()
      assert Gigs.list_gigs() == [gig]
    end

    test "get_gig!/1 returns the gig with given id" do
      gig = gig_fixture()
      assert Gigs.get_gig!(gig.id) == gig
    end

    test "create_gig/1 with valid data creates a gig" do
      assert {:ok, %Gig{} = gig} = Gigs.create_gig(@valid_attrs)
      assert gig.date == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
      assert gig.description == "some description"
      assert gig.name == "some name"
    end

    test "create_gig/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Gigs.create_gig(@invalid_attrs)
    end

    test "update_gig/2 with valid data updates the gig" do
      gig = gig_fixture()
      assert {:ok, %Gig{} = gig} = Gigs.update_gig(gig, @update_attrs)
      assert gig.date == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
      assert gig.description == "some updated description"
      assert gig.name == "some updated name"
    end

    test "update_gig/2 with invalid data returns error changeset" do
      gig = gig_fixture()
      assert {:error, %Ecto.Changeset{}} = Gigs.update_gig(gig, @invalid_attrs)
      assert gig == Gigs.get_gig!(gig.id)
    end

    test "delete_gig/1 deletes the gig" do
      gig = gig_fixture()
      assert {:ok, %Gig{}} = Gigs.delete_gig(gig)
      assert_raise Ecto.NoResultsError, fn -> Gigs.get_gig!(gig.id) end
    end

    test "change_gig/1 returns a gig changeset" do
      gig = gig_fixture()
      assert %Ecto.Changeset{} = Gigs.change_gig(gig)
    end
  end

  describe "gigs_genres" do
    alias Gigpillar.Gigs.GigGenre

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def gig_genre_fixture(attrs \\ %{}) do
      {:ok, gig_genre} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Gigs.create_gig_genre()

      gig_genre
    end

    test "list_gigs_genres/0 returns all gigs_genres" do
      gig_genre = gig_genre_fixture()
      assert Gigs.list_gigs_genres() == [gig_genre]
    end

    test "get_gig_genre!/1 returns the gig_genre with given id" do
      gig_genre = gig_genre_fixture()
      assert Gigs.get_gig_genre!(gig_genre.id) == gig_genre
    end

    test "create_gig_genre/1 with valid data creates a gig_genre" do
      assert {:ok, %GigGenre{} = gig_genre} = Gigs.create_gig_genre(@valid_attrs)
    end

    test "create_gig_genre/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Gigs.create_gig_genre(@invalid_attrs)
    end

    test "update_gig_genre/2 with valid data updates the gig_genre" do
      gig_genre = gig_genre_fixture()
      assert {:ok, %GigGenre{} = gig_genre} = Gigs.update_gig_genre(gig_genre, @update_attrs)
    end

    test "update_gig_genre/2 with invalid data returns error changeset" do
      gig_genre = gig_genre_fixture()
      assert {:error, %Ecto.Changeset{}} = Gigs.update_gig_genre(gig_genre, @invalid_attrs)
      assert gig_genre == Gigs.get_gig_genre!(gig_genre.id)
    end

    test "delete_gig_genre/1 deletes the gig_genre" do
      gig_genre = gig_genre_fixture()
      assert {:ok, %GigGenre{}} = Gigs.delete_gig_genre(gig_genre)
      assert_raise Ecto.NoResultsError, fn -> Gigs.get_gig_genre!(gig_genre.id) end
    end

    test "change_gig_genre/1 returns a gig_genre changeset" do
      gig_genre = gig_genre_fixture()
      assert %Ecto.Changeset{} = Gigs.change_gig_genre(gig_genre)
    end
  end

  describe "gigs_artists" do
    alias Gigpillar.Gigs.GigArtist

    @valid_attrs %{order: 42, plays_at: ~T[14:00:00]}
    @update_attrs %{order: 43, plays_at: ~T[15:01:01]}
    @invalid_attrs %{order: nil, plays_at: nil}

    def gig_artist_fixture(attrs \\ %{}) do
      {:ok, gig_artist} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Gigs.create_gig_artist()

      gig_artist
    end

    test "list_gigs_artists/0 returns all gigs_artists" do
      gig_artist = gig_artist_fixture()
      assert Gigs.list_gigs_artists() == [gig_artist]
    end

    test "get_gig_artist!/1 returns the gig_artist with given id" do
      gig_artist = gig_artist_fixture()
      assert Gigs.get_gig_artist!(gig_artist.id) == gig_artist
    end

    test "create_gig_artist/1 with valid data creates a gig_artist" do
      assert {:ok, %GigArtist{} = gig_artist} = Gigs.create_gig_artist(@valid_attrs)
      assert gig_artist.order == 42
      assert gig_artist.plays_at == ~T[14:00:00]
    end

    test "create_gig_artist/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Gigs.create_gig_artist(@invalid_attrs)
    end

    test "update_gig_artist/2 with valid data updates the gig_artist" do
      gig_artist = gig_artist_fixture()
      assert {:ok, %GigArtist{} = gig_artist} = Gigs.update_gig_artist(gig_artist, @update_attrs)
      assert gig_artist.order == 43
      assert gig_artist.plays_at == ~T[15:01:01]
    end

    test "update_gig_artist/2 with invalid data returns error changeset" do
      gig_artist = gig_artist_fixture()
      assert {:error, %Ecto.Changeset{}} = Gigs.update_gig_artist(gig_artist, @invalid_attrs)
      assert gig_artist == Gigs.get_gig_artist!(gig_artist.id)
    end

    test "delete_gig_artist/1 deletes the gig_artist" do
      gig_artist = gig_artist_fixture()
      assert {:ok, %GigArtist{}} = Gigs.delete_gig_artist(gig_artist)
      assert_raise Ecto.NoResultsError, fn -> Gigs.get_gig_artist!(gig_artist.id) end
    end

    test "change_gig_artist/1 returns a gig_artist changeset" do
      gig_artist = gig_artist_fixture()
      assert %Ecto.Changeset{} = Gigs.change_gig_artist(gig_artist)
    end
  end
end
