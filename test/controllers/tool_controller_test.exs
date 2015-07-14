defmodule LooksLikeANailBackend.ToolControllerTest do
  use LooksLikeANailBackend.ConnCase, async: true

  alias LooksLikeANailBackend.Tool

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
    assert json_response(conn, 200)["data"] |> Map.has_key?("tools")
  end

  test "lists one entry", %{conn: conn} do
    conn = get conn, tool_path(conn, :show, 1)
    IO.inspect json_response(conn, 200)
    # assert json_response(conn, 200)["data"] |> Map.has_key?("tools")
  end
end
