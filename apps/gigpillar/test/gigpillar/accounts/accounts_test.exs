defmodule Gigpillar.AccountsTest do
  use Gigpillar.DataCase

  alias Gigpillar.Accounts
  alias Gigpillar.Tokens

  describe "users" do
    alias Gigpillar.Accounts.User

    @valid_attrs %{
      email: "test@example.com",
      password: "some password",
      username: "some username"
    }
    @update_attrs %{
      email: "updated@example.com",
      password: "some updated password",
      username: "some updated username"
    }
    @invalid_attrs %{email: nil, password: nil, username: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "test@example.com"
      assert Argon2.check_pass(user, "some password") == {:ok, user}
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.email == "updated@example.com"
      assert Argon2.check_pass(user, "some updated password") == {:ok, user}
      assert user.username == "some updated username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "accounts_tokens" do
    alias Gigpillar.Accounts.AccountToken

    @valid_attrs %{user_id: 1, token_id: 1}
    @update_attrs %{}
    @invalid_attrs %{}

    def account_token_fixture(attrs \\ %{}) do
      {:ok} =
        Accounts.create_user(%{
          username: 'testuser',
          email: 'testuser@example.com',
          password: '123456'
        })

      {:ok} =
        Tokens.create_token(%{
          type: 'password-reset',
          value: '123456',
          expires_at: DateTime.add(DateTime.utc_now(), 60 * 60 * 24, :second)
        })

      {:ok, account_token} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_account_token()

      account_token
    end

    test "list_accounts_tokens/0 returns all accounts_tokens" do
      account_token = account_token_fixture()
      assert Accounts.list_accounts_tokens() == [account_token]
    end

    test "get_account_token!/1 returns the account_token with given id" do
      account_token = account_token_fixture()
      assert Accounts.get_account_token!(account_token.id) == account_token
    end

    test "create_account_token/1 with valid data creates a account_token" do
      assert {:ok, %AccountToken{} = account_token} = Accounts.create_account_token(@valid_attrs)
    end

    test "create_account_token/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_account_token(@invalid_attrs)
    end

    test "update_account_token/2 with valid data updates the account_token" do
      account_token = account_token_fixture()

      assert {:ok, %AccountToken{} = account_token} =
               Accounts.update_account_token(account_token, @update_attrs)
    end

    test "update_account_token/2 with invalid data returns error changeset" do
      account_token = account_token_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Accounts.update_account_token(account_token, @invalid_attrs)

      assert account_token == Accounts.get_account_token!(account_token.id)
    end

    test "delete_account_token/1 deletes the account_token" do
      account_token = account_token_fixture()
      assert {:ok, %AccountToken{}} = Accounts.delete_account_token(account_token)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_account_token!(account_token.id) end
    end

    test "change_account_token/1 returns a account_token changeset" do
      account_token = account_token_fixture()
      assert %Ecto.Changeset{} = Accounts.change_account_token(account_token)
    end
  end
end
