defmodule LooksLikeANailBackend.ImplementsController do
  use LooksLikeANailBackend.Web, :controller

  alias LooksLikeANailBackend.Implements

  def create(conn, %{"implements" => implements}) do
    implements = Neo4J.Repo.create_node!(Implements, implements)
    render(conn, :new, implements: implements)

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

  def delete(conn, %{"id" => id}) do
    id = String.to_integer(id)
    implements = Neo4J.Repo.get!(Implements, id)
    if(implements != nil) do
      Neo4J.Repo.delete!(Implements, id)
      render(conn, :new, implements: %{})
    else
      conn
      |> put_status(:not_found)
      |> render LooksLikeANailBackend.ErrorView, "404.json"
    end
    # conn
    # |> put_status(:not_found)
    # |> render(LooksLikeANailBackend.ErrorView, "404.html")
  # comment = Repo.get!(Comment, id)
  #
  # comment = Repo.delete!(comment)
  # render(conn, :show, comment: comment)
  end
  

end
