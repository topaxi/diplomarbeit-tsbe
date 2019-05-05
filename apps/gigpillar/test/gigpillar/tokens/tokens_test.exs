defmodule Gigpillar.TokensTest do
  use Gigpillar.DataCase

  alias Gigpillar.Tokens

  describe "tokens" do
    alias Gigpillar.Tokens.Token

    @valid_attrs %{expires_at: "2010-04-17T14:00:00Z", type: "some type", value: "some value"}
    @update_attrs %{expires_at: "2011-05-18T15:01:01Z", type: "some updated type", value: "some updated value"}
    @invalid_attrs %{expires_at: nil, type: nil, value: nil}

    def token_fixture(attrs \\ %{}) do
      {:ok, token} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Tokens.create_token()

      token
    end

    test "list_tokens/0 returns all tokens" do
      token = token_fixture()
      assert Tokens.list_tokens() == [token]
    end

    test "get_token!/1 returns the token with given id" do
      token = token_fixture()
      assert Tokens.get_token!(token.id) == token
    end

    test "create_token/1 with valid data creates a token" do
      assert {:ok, %Token{} = token} = Tokens.create_token(@valid_attrs)
      assert token.expires_at == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
      assert token.type == "some type"
      assert token.value == "some value"
    end

    test "create_token/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tokens.create_token(@invalid_attrs)
    end

    test "update_token/2 with valid data updates the token" do
      token = token_fixture()
      assert {:ok, %Token{} = token} = Tokens.update_token(token, @update_attrs)
      assert token.expires_at == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
      assert token.type == "some updated type"
      assert token.value == "some updated value"
    end

    test "update_token/2 with invalid data returns error changeset" do
      token = token_fixture()
      assert {:error, %Ecto.Changeset{}} = Tokens.update_token(token, @invalid_attrs)
      assert token == Tokens.get_token!(token.id)
    end

    test "delete_token/1 deletes the token" do
      token = token_fixture()
      assert {:ok, %Token{}} = Tokens.delete_token(token)
      assert_raise Ecto.NoResultsError, fn -> Tokens.get_token!(token.id) end
    end

    test "change_token/1 returns a token changeset" do
      token = token_fixture()
      assert %Ecto.Changeset{} = Tokens.change_token(token)
    end
  end
end
