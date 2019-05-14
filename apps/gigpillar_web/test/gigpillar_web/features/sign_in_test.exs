defmodule GigpillarWeb.Features.SignInTest do
  use GigpillarWeb.FeatureCase, async: true

  import Wallaby.Query

  setup do
    Gigpillar.Accounts.User.register_changeset(%Gigpillar.Accounts.User{}, %{
      username: "My Username",
      email: "test@example.com",
      password: "mysecretpassword",
      password_confirmation: "mysecretpassword"
    })
    |> Gigpillar.Repo.insert!()

    :ok
  end

  test "can login", %{session: session} do
    session
    |> visit("/")
    |> GigpillarWeb.Pages.Account.sign_in("test@example.com", "mysecretpassword")
    |> assert_has(css(".page-navigation li:last-child > span", text: "My Username"))
  end
end
