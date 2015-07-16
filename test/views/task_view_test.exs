defmodule LooksLikeANailBackend.TaskViewTest do
  use LooksLikeANailBackend.ConnCase, async: true

  import Phoenix.View

  test "render any other" do
    assert render_to_string(LooksLikeANailBackend.TaskView, "task.json", %{task: "task"}) ==
           Poison.encode! "task"
  end
end
