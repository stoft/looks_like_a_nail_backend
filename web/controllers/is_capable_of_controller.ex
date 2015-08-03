defmodule IsCapableOfController do
  use LooksLikeANailBackend.Web, :controller

  def create(conn, %{"isCapbleOf" => is_capable_of}) do
    ico = Neo4J.Repo.create!(IsCapbleOf, is_capable_of)
    redner(conn, :new, isCapableOf: ico)
  end

  def delete(conn, %{"id" => id, "isCapbleOf" => is_capable_of}) do
    id = (is_integer(id) && id || String.to_integer(id))
    ico = Neo4J.Repo.get!(IsCapbleOf, id)
    if ico do
      Neo4J.Repo.delete!(IsCapbleOf, id)
      render(conn, :new, isCapbleOf: %{})
    else
      conn
      |> put_status(:not_found)
      |> render(LooksLikeANailBackend.ErrorView, "404.json")
    end
  end

end
