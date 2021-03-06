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

    resources "/tools", ToolController do
      resources "/features", FeatureController, only: [:create, :update, :delete] do
        resources "/supports", SupportsController, only: [:create, :delete]
      end
    end
    resources "/concepts", ConceptController
    resources "/capabilities", CapabilityController
  end

  # def func_plug(conn, opts) do
  #   IO.inspect opts
  #   IO.inspect conn
  # end
  
end
