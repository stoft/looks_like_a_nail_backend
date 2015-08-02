defmodule LooksLikeANailBackend.TaskControllerTest do
  use LooksLikeANailBackend.ConnCase, async: true

  import AssertMore
  alias LooksLikeANailBackend.Task

  @moduletag :external

  @valid_attrs %{description: "some content",
    title: "title", sub_title: "sub_title",
    keywords: ["key", "word"], inserted: "", updated: ""}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, task_path(conn, :index)
    assert json_response(conn, 200) |> Map.has_key?("tasks")
  end

  test "show one entry", %{conn: conn} do
    expected = %{"task" => %{"title" => "Building",
      "subTitle" => "Task", "description" => "BuildingDescription"}}
    conn = get conn, task_path(conn, :show, 201)
    IO.inspect response = json_response(conn, 200)
    assert_match_except expected, response, ["updated", "created"]
  end

  # test "create one entry", %{conn: conn} do
  #   entry = %{title: "Baz", sub_title: "barzilla"}
  #   conn = post conn, task_path(conn, :create, task: entry)
  #   IO.inspect json_response(conn, 200)
  #   # assert json_response(conn, 200)["data"] |> Map.has_key?("tasks")
  # end

end
