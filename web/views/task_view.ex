defmodule LooksLikeANailBackend.TaskView do
  use LooksLikeANailBackend.Web, :view

  def render("index.json", %{tasks: tasks}) do
    # %{data: render_many(tasks, "task.json")}
    %{tasks: tasks}
  end

  def render("show.json", %{task: task}) do
    # %{data: render_one(task, "task.json")}
    %{task: task}
  end

  def render("task.json", %{task: task}) do
    # %{id: task.id}
    %{task: task}
  end
end
