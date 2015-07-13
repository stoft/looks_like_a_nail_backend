defmodule LooksLikeANailBackend.Router do
  use LooksLikeANailBackend.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LooksLikeANailBackend do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", LooksLikeANailBackend do
    pipe_through :api

    resources "/api/v1/tool", ToolController
  end
end
