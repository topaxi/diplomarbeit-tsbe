defmodule Gigpillar.Gigs do
  @moduledoc """
  The Gigs context.
  """

  import Ecto.Query, warn: false
  alias Gigpillar.Repo

  alias Gigpillar.Gigs.Gig

  @doc """
  Returns the list of gigs.

  ## Examples

      iex> list_gigs()
      [%Gig{}, ...]

  """
  def list_gigs do
    Repo.all(from(g in Gig, preload: [:location]))
  end

  def list_latest_gigs do
    Repo.all(
      from(g in Gig,
        distinct: [asc: g.date, desc: g.id],
        preload: [:location, :artists],
        limit: 12
      )
    )
  end

  def list_user_gigs(user_id) do
    Repo.all(from(g in Gig, where: g.creator_id == ^user_id))
  end

  @doc """
  Gets a single gig.

  Raises `Ecto.NoResultsError` if the Gig does not exist.

  ## Examples

      iex> get_gig!(123)
      %Gig{}

      iex> get_gig!(456)
      ** (Ecto.NoResultsError)

  """
  def get_gig!(id) do
    Repo.one! from g in Gig,
      left_join: l in assoc(g, :location),
      left_join: c in assoc(g, :creator),
      left_join: ga in assoc(g, :gig_artists),
      left_join: a in assoc(ga, :artist),
      where: g.id == ^id,
      preload: [location: l, creator: c, gig_artists: {ga, artist: a}]
  end

  @doc """
  Creates a gig.

  ## Examples

      iex> create_gig(%{field: value})
      {:ok, %Gig{}}

      iex> create_gig(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_gig(attrs \\ %{}) do
    %Gig{}
    |> Gig.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a gig.

  ## Examples

      iex> update_gig(gig, %{field: new_value})
      {:ok, %Gig{}}

      iex> update_gig(gig, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_gig(%Gig{} = gig, attrs) do
    gig
    |> Gig.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Gig.

  ## Examples

      iex> delete_gig(gig)
      {:ok, %Gig{}}

      iex> delete_gig(gig)
      {:error, %Ecto.Changeset{}}

  """
  def delete_gig(%Gig{} = gig) do
    Repo.delete(gig)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking gig changes.

  ## Examples

      iex> change_gig(gig)
      %Ecto.Changeset{source: %Gig{}}

  """
  def change_gig(%Gig{} = gig) do
    Gig.changeset(gig, %{})
  end

  def search_gigs(query, opts) when is_list(opts) do
    search_gigs(
      query,
      opts
      |> Enum.filter(fn {_, v} -> v && v != "" end)
      |> Enum.into(%{})
    )
  end

  def search_gigs(query, %{from: from} = options) do
    search_gigs(query, Map.delete(options, :from))
    |> where([g], g.date >= ^from)
  end

  def search_gigs(query, %{to: to} = options) do
    search_gigs(query, Map.delete(options, :to))
    |> where([g], g.date <= ^to)
  end

  def search_gigs(query, %{genre: genre} = options) do
    search_gigs(query, Map.delete(options, :genre))
    |> where([g, l, a, gg], gg.genre_id == ^genre)
  end

  def search_gigs(query, _options \\ []) do
    query
    |> String.split(" ")
    |> Enum.reduce(
      from(g in Gig,
        distinct: [asc: g.date, desc: g.id],
        left_join: l in assoc(g, :location),
        left_join: a in assoc(g, :artists),
        left_join: gg in assoc(g, :gig_genres),
        preload: [:location, :artists]
      ),
      fn term, query ->
        query
        |> where(
          [g, l, a],
          ilike(g.name, ^"%#{term}%") or
            ilike(l.name, ^"%#{term}%") or
            ilike(l.address, ^"%#{term}%") or
            ilike(a.name, ^"%#{term}%")
        )
      end
    )
  end

  alias Gigpillar.Gigs.GigGenre

  @doc """
  Returns the list of gigs_genres.

  ## Examples

      iex> list_gigs_genres()
      [%GigGenre{}, ...]

  """
  def list_gigs_genres do
    Repo.all(GigGenre)
  end

  @doc """
  Gets a single gig_genre.

  Raises `Ecto.NoResultsError` if the Gig genre does not exist.

  ## Examples

      iex> get_gig_genre!(123)
      %GigGenre{}

      iex> get_gig_genre!(456)
      ** (Ecto.NoResultsError)

  """
  def get_gig_genre!(id), do: Repo.get!(GigGenre, id)

  @doc """
  Creates a gig_genre.

  ## Examples

      iex> create_gig_genre(%{field: value})
      {:ok, %GigGenre{}}

      iex> create_gig_genre(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_gig_genre(attrs \\ %{}) do
    %GigGenre{}
    |> GigGenre.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a gig_genre.

  ## Examples

      iex> update_gig_genre(gig_genre, %{field: new_value})
      {:ok, %GigGenre{}}

      iex> update_gig_genre(gig_genre, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_gig_genre(%GigGenre{} = gig_genre, attrs) do
    gig_genre
    |> GigGenre.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a GigGenre.

  ## Examples

      iex> delete_gig_genre(gig_genre)
      {:ok, %GigGenre{}}

      iex> delete_gig_genre(gig_genre)
      {:error, %Ecto.Changeset{}}

  """
  def delete_gig_genre(%GigGenre{} = gig_genre) do
    Repo.delete(gig_genre)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking gig_genre changes.

  ## Examples

      iex> change_gig_genre(gig_genre)
      %Ecto.Changeset{source: %GigGenre{}}

  """
  def change_gig_genre(%GigGenre{} = gig_genre) do
    GigGenre.changeset(gig_genre, %{})
  end

  alias Gigpillar.Gigs.GigArtist

  @doc """
  Returns the list of gigs_artists.

  ## Examples

      iex> list_gigs_artists()
      [%GigArtist{}, ...]

  """
  def list_gigs_artists do
    Repo.all(GigArtist)
  end

  @doc """
  Gets a single gig_artist.

  Raises `Ecto.NoResultsError` if the Gig artist does not exist.

  ## Examples

      iex> get_gig_artist!(123)
      %GigArtist{}

      iex> get_gig_artist!(456)
      ** (Ecto.NoResultsError)

  """
  def get_gig_artist!(id), do: Repo.get!(GigArtist, id)

  @doc """
  Creates a gig_artist.

  ## Examples

      iex> create_gig_artist(%{field: value})
      {:ok, %GigArtist{}}

      iex> create_gig_artist(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_gig_artist(attrs \\ %{}) do
    %GigArtist{}
    |> GigArtist.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a gig_artist.

  ## Examples

      iex> update_gig_artist(gig_artist, %{field: new_value})
      {:ok, %GigArtist{}}

      iex> update_gig_artist(gig_artist, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_gig_artist(%GigArtist{} = gig_artist, attrs) do
    gig_artist
    |> GigArtist.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a GigArtist.

  ## Examples

      iex> delete_gig_artist(gig_artist)
      {:ok, %GigArtist{}}

      iex> delete_gig_artist(gig_artist)
      {:error, %Ecto.Changeset{}}

  """
  def delete_gig_artist(%GigArtist{} = gig_artist) do
    Repo.delete(gig_artist)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking gig_artist changes.

  ## Examples

      iex> change_gig_artist(gig_artist)
      %Ecto.Changeset{source: %GigArtist{}}

  """
  def change_gig_artist(%GigArtist{} = gig_artist) do
    GigArtist.changeset(gig_artist, %{})
  end
end
