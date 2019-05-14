defmodule GigpillarWeb.Features.SignUpTest do
  use GigpillarWeb.FeatureCase, async: true

  import Wallaby.Query

  test "can sign up", %{session: session} do
    session
    |> visit("/")
    |> click(css(".page-navigation a", text: "Add Gig"))
    |> assert_has(css(".alert-danger", text: "You are not allowed to view this page!"))
    |> click(link("Sign up now"))
    |> assert_has(css(".register-page"))
    |> fill_in(text_field("Username"), with: "Topaxci")
    |> fill_in(text_field("Email"), with: "topaxci@example.com")
    |> fill_in(text_field("Password"), with: "12345678")
    |> fill_in(text_field("Repeat password"), with: "12345678")
    |> click(button("Create your Account"))
    |> assert_has(css(".page-index"))
    |> assert_has(css(".page-navigation li:last-child > span", text: "Topaxci"))
  end
end
