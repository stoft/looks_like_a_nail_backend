defmodule LooksLikeANailBackend.TaskController do
  use LooksLikeANailBackend.Web, :controller

  alias LooksLikeANailBackend.Task

  def index(conn, _params) do
    tasks = Neo4J.Repo.all!(Task)
    if(tasks != nil) do
      render conn, :index, tasks: tasks
    else
      render conn, :index, tools: []
    end
  end

  def show(conn, %{"id" => id}) do
    id = String.to_integer(id)
    task = Neo4J.Repo.get!(Task, id)
    if(task != nil) do
      render conn, :show, task: task
    else
      conn
      |> put_status(:not_found)
      |> render(LooksLikeANailBackend.ErrorView, "404.json")
    end
  end
  
  def create(conn, %{"task" => task}) do
    task = Neo4J.Repo.create_node!(Task, task)
    render(conn, :new, task: task)

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

  def update(conn, %{"id" => id, "task" => task_params}) do
    id = String.to_integer(id)
    task = Neo4J.Repo.get!(Task, id)
    if(task != nil) do
      task_params = Map.put(task_params, "id", id)
      task = Neo4J.Repo.update!(Task, task_params)
      render conn, :show, task: task
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
    id = String.to_integer(id)
    task = Neo4J.Repo.get!(Task, id)
    if(task != nil) do
      Neo4J.Repo.delete!(Task, id)
      render(conn, :new, task: %{})
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
