defmodule LooksLikeANailBackend.TaskController do
  use LooksLikeANailBackend.Web, :controller

  alias LooksLikeANailBackend.Task

  def index(conn, _params) do
    tasks = Neo4J.Repo.all!(Task)
    render conn, :index, tasks: tasks
  end

  def show(conn, %{"id" => id}) do
    task = Neo4J.Repo.get!(Task, id)
    render conn, :show, task: task
  end
  
  def create(conn, %{"task" => task}) do
    # task = %Task{}

    tasks = Neo4J.Repo.create_node!(Task, task)
    id = tasks |> hd |> Map.get("row") |> hd |> Map.get("id")
    render(conn, :new, id: id)


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
