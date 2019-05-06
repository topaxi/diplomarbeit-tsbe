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
  end

  scope "/", GigpillarWeb do
    pipe_through(:browser)

    get("/", PageController, :index)
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

  # Other scopes may use custom stacks.
  # scope "/api", GigpillarWeb do
  #   pipe_through :api
  # end
end
