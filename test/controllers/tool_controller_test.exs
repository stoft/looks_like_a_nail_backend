defmodule LooksLikeANailBackend.ToolControllerTest do
  use LooksLikeANailBackend.ConnCase, async: true

  alias LooksLikeANailBackend.Tool

  @moduletag :external

  @valid_attrs %{description: "some content",
    title: "title", sub_title: "sub_title",
    keywords: ["key", "word"], insert_at: "", updated_at: ""}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, tool_path(conn, :index)
    # IO.inspect json_response(conn, 200)
    assert json_response(conn, 200) |> Map.has_key?("tools")
  end

  test "show one entry", %{conn: conn} do
    conn = get conn, tool_path(conn, :show, 1)
    response = json_response(conn, 200)
    assert response |> Map.has_key?("tool")
  end

  test "create one entry", %{conn: conn} do
    entry = %{tool: %{id: 1,
      title: "Elixir",
      subTitle: "Programming Language",
      description: "A functional programming language " <>
        "standing on the shoulders of giants.",
      updated: "2015-07-16T15:46:53.023+0000",
      created: "2015-07-16T15:46:53.023+0000",
      keywords: ["functional", "programming", "erlang"]}}
      # features: [1,2,3]}}
    conn = post conn, tool_path(conn, :create, entry)
    IO.inspect response = json_response(conn, 200)
    assert response |> Map.has_key?("tool")
    # assert json_response(conn, 200) |> Map.has_key?("tools")
  end

end
