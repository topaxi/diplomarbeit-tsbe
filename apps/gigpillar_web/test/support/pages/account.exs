defmodule GigpillarWeb.Pages.Account do
  import Wallaby.Query
  import Wallaby.Browser

  def sign_in(session, email, password) do
    session
    |> visit("/auth/identity")
    |> fill_in(text_field("Email"), with: email)
    |> fill_in(text_field("Password"), with: password)
    |> click(button("Login"))
  end
end
