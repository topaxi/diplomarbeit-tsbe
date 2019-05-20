defmodule GigpillarWeb.Features.CreateNewGigTest do
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

    Gigpillar.Artists.Artist.changeset(%Gigpillar.Artists.Artist{}, %{
      name: "Mobina Galore"
    })
    |> Gigpillar.Repo.insert!()

    :ok
  end

  test "can create new gigs", %{session: session} do
    session
    |> GigpillarWeb.Pages.Account.sign_in("test@example.com", "mysecretpassword")
    |> visit("/gigs/new")
    |> assert_has(css("form.form-vertical"))
    |> fill_in(text_field("gig_name"), with: "Mobina Galore")
    # |> attach_file(file_field("Picture"), path: "../../support/assets/mobina_galore.jpg")
    # |> assert_has(css("img[src^=\"blob:\"]"))
    |> fill_in(text_field("Location"), with: "Dynamo Zürich")
    |> click(button("Jugendkulturhaus Dynamo, Wasserwerkstrasse, Zürich, Switzerland"))
    |> fill_in(text_field("When"), with: "05/14/2019")
    # |> fill_in(text_field("Doors"), with: "0730P")
    |> fill_in(text_field("Gig artists"), with: "Mobina")
    |> click(button("Mobina Galore"))
    |> fill_in(text_field("Description"),
      with:
        "Mobina Galore leben und arbeiten in einem Umfeld, einer Szene, einem Genre, das immer noch von Männern dominiert wird. Seit ihrer Gründung im Jahr 2010 mussten sie sich immer wieder mit den widerlichsten Äußerungen, doofen Kommentaren wie „ihr seid ja eigentlich ziemlich gut“ und herablassenden Clubbesitzern rumschlagen. Dazu kommt die heimtückische Herausforderung der Überwindung der gläsernen Decke der Musikindustrie. Immer wieder werden sie mit Sexismus konfrontiert, doch genau das motiviert Gitarristin/ Sängerin Jenna Priestner und Schlagzeugerin Marcia Hanson nur dazu, noch härter zu arbeiten und an dem festzuhalten, was sie am besten können: großartige Punk Rock Songs zu schreiben, die für sich selbst sprechen."
    )
    |> fill_in(text_field("Tickets"),
      with: "https://www.ticketino.com/de/Event/Mobina-Galore/82201"
    )
    |> click(button("Save"))
    |> assert_has(css(".gig-detail-page"))
  end
end
