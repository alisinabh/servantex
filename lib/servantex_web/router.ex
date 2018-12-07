defmodule ServantexWeb.Router do
  use ServantexWeb, :router

  alias ServantexWeb.Plugs.ThingAuthPlug

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :thing_api do
    plug :accepts, ["html"]
    plug ThingAuthPlug
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ServantexWeb do
    pipe_through :browser

    get "/", PageController, :index
    get("/auth/google", PageController, :google_auth)
    post("/auth/google", PageController, :check_auth)
  end

  scope "/thing_api", ServantexWeb do
    pipe_through :thing_api

    get "/pin_modes", ThingController, :pin_modes
    get "/pull", ThingController, :pull
    post "/push", ThingController, :push
  end

  scope "/api", ServantexWeb do
    pipe_through :api

    post "/google_action", GactionController, :gaction
  end

  # Other scopes may use custom stacks.
  # scope "/api", ServantexWeb do
  #   pipe_through :api
  # end
end
