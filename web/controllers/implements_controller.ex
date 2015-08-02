defmodule LooksLikeANailBackend.ImplementsController do
  use LooksLikeANailBackend.Web, :controller

  alias LooksLikeANailBackend.Implements

  def create(conn, %{"implements" => implements}) do
    %{implements: implements} = Neo4J.Repo.create_node!(Implements, implements)
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

end
