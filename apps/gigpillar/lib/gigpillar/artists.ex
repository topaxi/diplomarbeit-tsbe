defmodule Gigpillar.Artists do
  @moduledoc """
  The Artists context.
  """

  import Ecto.Query, warn: false
  alias Gigpillar.Repo

  alias Gigpillar.Artists.Artist

  @doc """
  Returns the list of artists.

  ## Examples

      iex> list_artists()
      [%Artist{}, ...]

  """
  def list_artists do
    Repo.all(Artist)
  end

  @doc """
  Gets a single artist.

  Raises `Ecto.NoResultsError` if the Artist does not exist.

  ## Examples

      iex> get_artist!(123)
      %Artist{}

      iex> get_artist!(456)
      ** (Ecto.NoResultsError)

  """
  def get_artist!(id), do: Repo.get!(Artist, id)

  @doc """
  Gets a single artist by name.

  Raises `Ecto.NoResultsError` if the Artist does not exist.

  ## Examples

      iex> get_artist!("Parkway Drive")
      %Artist{}

      iex> get_artist!("Unknown Artist")
      ** (Ecto.NoResultsError)

  """
  def get_artist_by_name!(name), do: Repo.get_by!(Artist, name: name)

  @doc """
  Creates a artist.

  ## Examples

      iex> create_artist(%{field: value})
      {:ok, %Artist{}}

      iex> create_artist(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_artist(attrs \\ %{}) do
    %Artist{}
    |> Artist.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a artist.

  ## Examples

      iex> update_artist(artist, %{field: new_value})
      {:ok, %Artist{}}

      iex> update_artist(artist, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_artist(%Artist{} = artist, attrs) do
    artist
    |> Artist.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Artist.

  ## Examples

      iex> delete_artist(artist)
      {:ok, %Artist{}}

      iex> delete_artist(artist)
      {:error, %Ecto.Changeset{}}

  """
  def delete_artist(%Artist{} = artist) do
    Repo.delete(artist)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking artist changes.

  ## Examples

      iex> change_artist(artist)
      %Ecto.Changeset{source: %Artist{}}

  """
  def change_artist(%Artist{} = artist) do
    Artist.changeset(artist, %{})
  end

  @doc """
  Searches artists by name.

  ## Examples

      iex> search_artists(name: "The%")
      [%Artist{}, ...]

  """
  def search_artists(name: name) do
    Repo.all(from(a in Artist, where: ilike(a.name, ^"%#{name}%")))
  end
end
