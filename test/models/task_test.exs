defmodule LooksLikeANailBackend.TaskTest do
  use ExUnit.Case, async: true

  # doctest LooksLikeANailBackend.Task

  test "get create statement" do
    statement = "CREATE (task:Task {title: \"Foo\"}) SET task.id = id(task) RETURN task"
    assert statement == LooksLikeANailBackend.Task.get_create_statement(%{title: "Foo"})
  end
end