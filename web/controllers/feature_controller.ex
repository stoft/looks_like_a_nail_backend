defmodule LooksLikeANailBackend.FeatureController do
  use LooksLikeANailBackend.Web, :controller

  alias LooksLikeANailBackend.Feature
  alias LooksLikeANailBackend.Tool
  alias LooksLikeANailBackend.Capability
  alias LooksLikeANailBackend.Supports

  def create(conn, %{"feature" => feature, "tool_id" => tool_id}) do
    tool_id = (is_integer(tool_id) && tool_id || String.to_integer(tool_id))
    capability_id = Dict.get(feature, "capability")
    capability_id = (is_integer(capability_id) && capability_id || String.to_integer(capability_id))
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

  # used when adding a concept supported by the feature
  def create(conn, %{"id" => id, "feature_id" => f_id}) do
    id = (is_integer(id) && id || String.to_integer(id))
    f_id = (is_integer(f_id) && f_id || String.to_integer(id))
    concept = Neo4J.Repo.get!(Concept, id)
    feature = Neo4J.Repo.get!(Feature, f_id)
    if(feature && concept) do
      Neo4J.Repo.create!(Supports, %{"feature_id" => f_id, "concept_id" => id})
      feature = Neo4J.Repo.get!(Feature, f_id)
      render conn, :show, feature: feature
    else
      conn
      |> put_status(:not_found)
      |> render(LooksLikeANailBackend.ErrorView, "404.json")
    end
  end

  def update(conn, %{"id" => id, "feature" => feature_params}) do
    id = (is_integer(id) && id || String.to_integer(id))
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

  # used when removing a supported concept from a feature
  def delete(conn, %{"id" => id, "feature_id" => f_id}) do
    id = (is_integer(id) && id || String.to_integer(id))
    f_id = (is_integer(f_id) && f_id || String.to_integer(f_id))
    concept = Neo4J.Repo.get!(Concept, id)
    feature = Neo4J.Repo.get!(Feature, f_id)
    if(feature && concept) do
      Neo4J.Repo.delete!(Supports, %{"id" => id, "feature_id" => f_id})
      render(conn, :new, feature: %{})
    else
      conn
      |> put_status(:not_found)
      |> render LooksLikeANailBackend.ErrorView, "404.json"
    end
  end

  def delete(conn, %{"id" => id}) do
    id = (is_integer(id) && id || String.to_integer(id))
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
