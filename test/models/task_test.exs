defmodule LooksLikeANailBackend.TaskTest do
  use ExUnit.Case, async: true

  # doctest LooksLikeANailBackend.Task

  test "get create statement" do
    statement = {"CREATE (task:Task {props}) SET task.id = id(task), task.updated = timestamp(), task.created = timestamp() RETURN task",
      %{props: %{title: "Foo"}}}
    assert statement == LooksLikeANailBackend.Task.get_create_statement(%{title: "Foo"})
  end
end