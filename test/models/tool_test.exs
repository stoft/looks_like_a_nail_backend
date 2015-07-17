defmodule LooksLikeANailBackend.ToolTest do
  use ExUnit.Case, async: true

  # doctest LooksLikeANailBackend.Tool

  test "get create statement" do
    statement = "CREATE (tool:Tool {title: \"Foo\"}) SET tool.id = id(tool), tool.updated = timestamp(), tool.created = timestamp() RETURN tool"
    assert statement == LooksLikeANailBackend.Tool.get_create_statement(%{title: "Foo"})
  end
end