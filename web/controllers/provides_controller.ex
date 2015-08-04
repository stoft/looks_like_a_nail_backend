defmodule LooksLikeANailBackend.ProvidesController do
  use LooksLikeANailBackend.Web, :controller

  alias LooksLikeANailBackend.Provides

  def create(conn, %{"provides" => provides}) do
    IO.inspect provides
    %{provides: provides} = Neo4J.Repo.create!(Provides, provides)
    render(conn, :new, provides: provides)
  end

  def delete(conn, %{"id" => id}) do
    id = (is_integer(id) && id || String.to_integer(id))
    provides = Neo4J.Repo.get!(Provides, id)
    if provides do
      Neo4J.Repo.delete!(Provides, id)
      render(conn, :new, provides: %{})
    else
      conn
      |> put_status(:not_found)
      |> render(LooksLikeANailBackend.ErrorView, "404.json")
    end
  end

end
