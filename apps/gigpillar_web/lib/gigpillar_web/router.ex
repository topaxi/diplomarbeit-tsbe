defmodule GigpillarWeb.Router do
  use GigpillarWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
    plug(:fetch_session)
    plug(:put_secure_browser_headers)
  end

  scope "/", GigpillarWeb do
    pipe_through(:browser)

    get("/", PageController, :index)

    resources("/gigs", GigController)
  end

  scope "/auth", GigpillarWeb do
    pipe_through(:browser)

    get("/:provider", AuthController, :request)
    get("/:provider/callback", AuthController, :callback)
    get("/identity/register", AuthController, :register)
    post("/identity/callback", AuthController, :callback)
    post("/identity/register_callback", AuthController, :register_callback)
    post("/logout", AuthController, :delete)
  end

  scope "/api", GigpillarWeb do
    pipe_through(:api)

    get("/autocomplete/location", AutocompleteController, :location)
    get("/autocomplete/artist", AutocompleteController, :artist)
  end
end
