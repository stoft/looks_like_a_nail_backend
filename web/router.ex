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
    # plug :func_plug
  end

  scope "/", LooksLikeANailBackend do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api/v1", LooksLikeANailBackend do
    pipe_through :api

    # get "/", ApiController

    resources "/tools", ToolController
    resources "/tasks", TaskController
    resources "/features", FeatureController
  end

  def func_plug(conn, opts) do
    IO.inspect opts
    IO.inspect conn
  end
  
end
