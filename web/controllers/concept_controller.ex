defmodule LooksLikeANailBackend.ConceptController do
  use LooksLikeANailBackend.Web, :controller

  alias LooksLikeANailBackend.Concept

  def index(conn, _params) do
    concepts = Neo4J.Repo.all!(Concept)
    if(concepts != nil) do
      render conn, :index, concepts: concepts
    else
      render conn, :index, concepts: []
    end
  end

  def show(conn, %{"id" => id}) do
    id = (is_integer(id) && id || String.to_integer(id))
    concept = Neo4J.Repo.get!(Concept, id)
    if(concept != nil) do
      render conn, :show, concept: concept
    else
      conn
      |> put_status(:not_found)
      |> render(LooksLikeANailBackend.ErrorView, "404.json")
    end
  end
  
  def create(conn, %{"concept" => concept}) do
    concept = Neo4J.Repo.create!(Concept, concept)
    render(conn, :new, concept: concept)
  end

  def update(conn, %{"id" => id, "concept" => concept_params}) do
    id = (is_integer(id) && id || String.to_integer(id))
    concept = Neo4J.Repo.get!(Concept, id)
    if(concept != nil) do
      concept_params = Map.put(concept_params, "id", id)
      concept = Neo4J.Repo.update!(Concept, concept_params)
      render conn, :show, concept: concept
    else
      conn
      |> put_status(:not_found)
      |> render(LooksLikeANailBackend.ErrorView, "404.json")
    end
  end

  def delete(conn, %{"id" => id}) do
    id = (is_integer(id) && id || String.to_integer(id))
    concept = Neo4J.Repo.get!(Concept, id)
    if(concept != nil) do
      Neo4J.Repo.delete!(Concept, id)
      render(conn, :new, concept: %{})
    else
      conn
      |> put_status(:not_found)
      |> render LooksLikeANailBackend.ErrorView, "404.json"
    end
  end

end
