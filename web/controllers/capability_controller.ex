defmodule LooksLikeANailBackend.CapabilityController do
  use LooksLikeANailBackend.Web, :controller

  alias LooksLikeANailBackend.Capability

  def index(conn, _params) do
    capabilities = Neo4J.Repo.all!(Capability)
    if(capabilities != nil) do
      render conn, :index, capabilities: capabilities
    else
      render conn, :index, capabilities: []
    end
  end

  def show(conn, %{"id" => id}) do
    id = (is_integer(id) && id || String.to_integer(id))
    capability = Neo4J.Repo.get!(Capability, id)
    if(capability != nil) do
      render conn, :show, capability: capability
    else
      conn
      |> put_status(:not_found)
      |> render(LooksLikeANailBackend.ErrorView, "404.json")
    end
  end
  
  def create(conn, %{"capability" => capability}) do
    capability = Neo4J.Repo.create!(Capability, capability)
    render(conn, :new, capability: capability)

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

  def update(conn, %{"id" => id, "capability" => capability_params}) do
    id = (is_integer(id) && id || String.to_integer(id))
    capability = Neo4J.Repo.get!(Capability, id)
    if(capability != nil) do
      capability_params = Map.put(capability_params, "id", id)
      capability = Neo4J.Repo.update!(Capability, capability_params)
      render conn, :show, capability: capability
    else
      conn
      |> put_status(:not_found)
      |> render(LooksLikeANailBackend.ErrorView, "404.json")
    end
    # comment = Repo.get!(Comment, id)
    # changeset = Comment.changeset(comment, comment_params)
    #
    # if changeset.valid? do
    #   comment = Repo.update!(changeset)
    #   render(conn, :show, comment: comment)
    # else
    #   conn
    #   |> put_status(:unprocessable_entity)
    #   |> render(NeepBlogBackend.ChangesetView, :error, changeset: changeset)
    # end
  end

  def delete(conn, %{"id" => id}) do
    id = (is_integer(id) && id || String.to_integer(id))
    capability = Neo4J.Repo.get!(Capability, id)
    if(capability != nil) do
      Neo4J.Repo.delete!(Capability, id)
      render(conn, :new, capability: %{})
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
