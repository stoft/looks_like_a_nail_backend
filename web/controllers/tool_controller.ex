defmodule LooksLikeANailBackend.ToolController do
  use LooksLikeANailBackend.Web, :controller

  alias LooksLikeANailBackend.Tool

  def index(conn, _params) do
    tools = Neo4J.Repo.all!(Tool)
    if(tools != nil) do
      render conn, :index, tools: tools
    else
      render conn, :index, tools: []
    end
  end

  def show(conn, %{"id" => id}) do
    id = (is_integer(id) && id || String.to_integer(id))
    tool = Neo4J.Repo.get!(Tool, id)
    if(tool != nil) do
      render conn, :show, tool: tool
    else
      conn
      |> put_status(:not_found)
      |> render(LooksLikeANailBackend.ErrorView, "404.json")
    end
  end
  
  def create(conn, %{"tool" => tool}) do
    tool = Neo4J.Repo.create!(Tool, tool)
    render(conn, :new, tool: tool)

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

  def update(conn, %{"id" => id, "tool" => tool_params}) do
    id = (is_integer(id) && id || String.to_integer(id))
    tool = Neo4J.Repo.get!(Tool, id)
    if(tool != nil) do
      tool_params = Map.put(tool_params, "id", id)
      IO.inspect(tool_params)
      tool = Neo4J.Repo.update!(Tool, tool_params)
      render conn, :show, tool: tool
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
    tool = Neo4J.Repo.get!(Tool, id)
    if(tool != nil) do
      Neo4J.Repo.delete!(Tool, id)
      render(conn, :new, tool: %{})
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
