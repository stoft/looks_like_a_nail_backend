defmodule LooksLikeANailBackend.ConceptController do
  use LooksLikeANailBackend.Web, :controller

  # alias LooksLikeANailBackend.Concept
  # alias LooksLikeANailBackend.Tool
  # alias LooksLikeANailBackend.Capability
  
  # def create(conn, %{"feature" => feature, "tool_id" => tool_id}) do
  #   tool_id = (is_integer(tool_id) && tool_id || String.to_integer(tool_id))
  #   capability_id = Dict.get(feature, "capability")
  #   capability_id = (is_integer(capability_id) && capability_id || String.to_integer(capability_id))
  #   tool = Neo4J.Repo.get!(Tool, tool_id)
  #   capability = Neo4J.Repo.get!(Capability, capability_id)
  #   if(tool && capability) do
  #     feature = Dict.put(feature, "capability", capability_id)
  #     feature = Dict.put(feature, "tool", tool_id)
  #     feature = Neo4J.Repo.create!(Concept, feature)
  #     render(conn, :new, feature: feature)
  #   else
  #     conn
  #     |> put_status(:not_found)
  #     |> render(LooksLikeANailBackend.ErrorView, "404.json")
  #   end
  # end
  
  # def create(conn, %{"feature" => feature}) do
  #   feature = Neo4J.Repo.create!(Concept, feature)
  #   render(conn, :new, feature: feature)

  #   # if changeset.valid? do
  #   #   # Repo.insert!(changeset)
  #   #   Neo4jConnector.insert!(changeset)
  #   #
  #   #   conn
  #   #   |> put_flash(:info, "Article created successfully.")
  #   #   |> redirect(to: article_path(conn, :index))
  #   # else
  #   #   render(conn, :new, changeset: changeset)
  #   # end
  # end
  

end
