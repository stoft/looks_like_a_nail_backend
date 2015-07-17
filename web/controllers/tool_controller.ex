defmodule LooksLikeANailBackend.ToolController do
  use LooksLikeANailBackend.Web, :controller

  alias LooksLikeANailBackend.Tool
  alias LooksLikeANailBackend.Utils

  def index(conn, _params) do
    tools = Neo4J.Repo.all!(Tool)
    render conn, :index, tools: tools
  end

  def show(conn, %{"id" => id}) do
    tool = Neo4J.Repo.get!(Tool, id)
    render conn, :show, tool: tool
  end
  
  def create(conn, %{"tool" => tool}) do
    ts = Utils.get_timestamp_now()
    tool = tool
      |> Map.put("updated", ts)
      |> Map.put("created", ts)
    # tool = %{tool | "updated" => ts, "created" => ts}
    tool = Neo4J.Repo.create_node!(Tool, tool)
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

end
