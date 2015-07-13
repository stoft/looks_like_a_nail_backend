defmodule ToolController do
  use LooksLikeANailBackend.Web, :controller

  def index(conn, _params) do
    tools = Neo4j.Repo.all()
    render conn, :index, tools
  end
  
end