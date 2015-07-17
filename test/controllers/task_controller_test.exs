defmodule LooksLikeANailBackend.TaskControllerTest do
  use LooksLikeANailBackend.ConnCase, async: true

  alias LooksLikeANailBackend.Task

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
    conn = get conn, task_path(conn, :index)
    assert json_response(conn, 200) |> IO.inspect |> Map.has_key?("tasks")
  end

  test "show one entry", %{conn: conn} do
    conn = get conn, task_path(conn, :show, 1)
    response = json_response(conn, 200)
    assert response |> Map.has_key?("task")
  end

  # test "create one entry", %{conn: conn} do
  #   entry = %{title: "Baz", sub_title: "barzilla"}
  #   conn = post conn, task_path(conn, :create, task: entry)
  #   IO.inspect json_response(conn, 200)
  #   # assert json_response(conn, 200)["data"] |> Map.has_key?("tasks")
  # end

end
