defmodule LooksLikeANailBackend.ToolController do
  use LooksLikeANailBackend.Web, :controller

  alias LooksLikeANailBackend.Tool

  def index(conn, _params) do
    tools = Neo4J.Repo.all!(Tool)
    # IO.puts "in controller: "
    # IO.inspect tools
    render conn, :index, tools
  end

  def create(conn, tool) do
    # tool = %Tool{}


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
