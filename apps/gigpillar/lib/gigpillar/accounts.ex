defmodule Gigpillar.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Gigpillar.Repo

  alias Gigpillar.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Gets a single user by email.

  ## Examples

      iex> get_user_by_email("foo@example.com")
      %User{}

      iex> get_user_by_email("nonexisting@example.com")
      ** (Ecto.NoResultsError)

  """
  def get_user_by_email(email), do: Repo.get_by(User, email: email)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Registers a new user.

  ## Examples

      iex> register_user(%{field: value})
      {:ok, %User{}}

      iex> register_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def register_user(attrs \\ %{}) do
    %User{}
    |> User.register_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  alias Gigpillar.Accounts.AccountToken

  @doc """
  Returns the list of accounts_tokens.

  ## Examples

      iex> list_accounts_tokens()
      [%AccountToken{}, ...]

  """
  def list_accounts_tokens do
    Repo.all(AccountToken)
  end

  @doc """
  Gets a single account_token.

  Raises `Ecto.NoResultsError` if the Account token does not exist.

  ## Examples

      iex> get_account_token!(123)
      %AccountToken{}

      iex> get_account_token!(456)
      ** (Ecto.NoResultsError)

  """
  def get_account_token!(id), do: Repo.get!(AccountToken, id)

  @doc """
  Creates a account_token.

  ## Examples

      iex> create_account_token(%{field: value})
      {:ok, %AccountToken{}}

      iex> create_account_token(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_account_token(attrs \\ %{}) do
    %AccountToken{}
    |> AccountToken.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a account_token.

  ## Examples

      iex> update_account_token(account_token, %{field: new_value})
      {:ok, %AccountToken{}}

      iex> update_account_token(account_token, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_account_token(%AccountToken{} = account_token, attrs) do
    account_token
    |> AccountToken.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a AccountToken.

  ## Examples

      iex> delete_account_token(account_token)
      {:ok, %AccountToken{}}

      iex> delete_account_token(account_token)
      {:error, %Ecto.Changeset{}}

  """
  def delete_account_token(%AccountToken{} = account_token) do
    Repo.delete(account_token)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking account_token changes.

  ## Examples

      iex> change_account_token(account_token)
      %Ecto.Changeset{source: %AccountToken{}}

  """
  def change_account_token(%AccountToken{} = account_token) do
    AccountToken.changeset(account_token, %{})
  end
end
