defmodule LooksLikeANailBackend.FeatureController do
  use LooksLikeANailBackend.Web, :controller

  alias LooksLikeANailBackend.Feature
  alias LooksLikeANailBackend.Tool
  alias LooksLikeANailBackend.Capability
  alias LooksLikeANailBackend.Supports
  alias LooksLikeANailBackend.ConversionHelper

  def create(conn, %{"feature" => feature, "tool_id" => tool_id}) do
    tool_id = ConversionHelper.convert_to_integer(tool_id)
    capability_id = Dict.get(feature, "capability")
    capability_id = ConversionHelper.convert_to_integer(capability_id)
    tool = Neo4J.Repo.get!(Tool, tool_id)
    capability = Neo4J.Repo.get!(Capability, capability_id)
    if(tool && capability) do
      feature = Dict.put(feature, "capability", capability_id)
      feature = Dict.put(feature, "tool", tool_id)
      feature = Neo4J.Repo.create!(Feature, feature)
      render(conn, :new, feature: feature)
    else
      conn
      |> put_status(:not_found)
      |> render(LooksLikeANailBackend.ErrorView, "404.json")
    end
  end
  
  def create(conn, %{"feature" => feature}) do
    feature = Neo4J.Repo.create!(Feature, feature)
    render(conn, :new, feature: feature)

    # if changeset.valid? do
    #   # Repo.insert!(changeset)
    #   Neo4jConnector.insert!(changeset)
    #
    #   conn
    #   |> put_flash(:info, "Article created successfully.")
    #   |> redirect(to: article_path(conn, :index))
    # else
    #   render(conn, :new, changeset: changeset)
    # end
  end

  def update(conn, %{"id" => id, "feature" => feature_params}) do
    id = ConversionHelper.convert_to_integer(id)
    feature = Neo4J.Repo.get!(Feature, id)
    if(feature) do
      feature_params = Map.put(feature_params, "id", id)
      feature = Neo4J.Repo.update!(Feature, feature_params)
      render conn, :show, feature: feature
    else
      conn
      |> put_status(:not_found)
      |> render(LooksLikeANailBackend.ErrorView, "404.json")
    end
  end

  def delete(conn, %{"id" => id}) do
    id = ConversionHelper.convert_to_integer(id)
    feature = Neo4J.Repo.get!(Feature, id)
    if(feature != nil) do
      Neo4J.Repo.delete!(Feature, id)
      render(conn, :new, feature: %{})
    else
      conn
      |> put_status(:not_found)
      |> render LooksLikeANailBackend.ErrorView, "404.json"
    end
  end
  
end
