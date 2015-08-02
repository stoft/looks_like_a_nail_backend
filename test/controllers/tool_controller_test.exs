defmodule LooksLikeANailBackend.ToolControllerTest do
  use LooksLikeANailBackend.ConnCase, async: true

  import AssertMore

  @moduletag :external

  @valid_attrs %{description: "some content",
    title: "title", sub_title: "sub_title",
    keywords: ["key", "word"], insert_at: "", updated_at: ""}
  @invalid_attrs %{}

  setup_all do
    LooksLikeANailBackend.TestDBHelper.setup_db
    :ok
  end

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, tool_path(conn, :index)
    response = json_response(conn, 200)
    assert response |> Map.has_key?("tools")
  end

  test "show one entry", %{conn: conn} do
    id = 105
    expected = %{
      "features" => [%{"created" => "2015-08-01T10:27:56.764Z", "id" => 303,
        "isCapableOf" => [3032], "supports" => [],
        "title" => "postgresDatastorage",
        "updated" => "2015-08-01T10:27:56.764Z"}],
      "implements" => [%{"feature" => 303, "id" => 3031, "tool" => 105}],
      "isCapableOf" => [%{"feature" => 303, "id" => 3032, "task" => 205}],
      "supports" => [],
      "tasks" => [%{"created" => "2015-08-01T10:27:56.764Z",
        "description" => "DatastorageDescription", "id" => 205,
        "subTitle" => "Task", "title" => "Datastorage",
        "updated" => "2015-08-01T10:27:56.764Z"}],
      "tool" => %{"created" => "2015-08-01T10:27:56.764Z",
        "description" => "PostgresDescription", "id" => 105, "implements" => [3031],
        "subTitle" => "Database", "title" => "Postgres",
        "updated" => "2015-08-01T10:27:56.764Z"}, "tools" => []}
    conn = get conn, tool_path(conn, :show, id)
    actual = json_response(conn, 200)
    assert_match_except expected, actual, ["updated", "created"]
  end

  test "try to show one non-existent entry", %{conn: conn} do
    conn = get conn, tool_path(conn, :show, -1)
    response = json_response(conn, 404)
    assert response == "Page not found"
  end

  test "create one entry", %{conn: conn} do
    entry = %{tool: %{title: "Erlang",
      subTitle: "Programming Language",
      description: "A functional programming language " <>
        "built by Joe, Robert and some other guy...",
      updated: "2015-07-16T15:46:53.023+0000",
      created: "2015-07-16T15:46:53.023+0000",
      keywords: ["functional", "programming", "erlang"]}}
      # features: [1,2,3]}}
    conn = post conn, tool_path(conn, :create, entry)
    response = json_response(conn, 200)
    assert response |> Map.has_key?("tool")
    response |> Map.get("tool") |> Map.get("id")
  end

  test "update one entry", %{conn: conn} do
    id = 104
    entry = %{tool: %{id: id,
      title: "Elixir",
      subTitle: "Programming Language",
      description: "Elixir is a functional, concurrent, general-purpose programming language that runs on the Erlang virtual machine (BEAM). Elixir builds on top of Erlang to provide distributed, fault-tolerant, soft real-time, non-stop applications but also extends it to support metaprogramming with macros and polymorphism via protocols.",
      updated: "2015-07-16T15:46:53.023+0000",
      created: "2015-07-16T15:46:53.023+0000"}}
    expected = %{"created" => "2015-08-01T11:37:08.910Z",
      "description" => "Elixir is a functional, concurrent, general-purpose programming language that runs on the Erlang virtual machine (BEAM). Elixir builds on top of Erlang to provide distributed, fault-tolerant, soft real-time, non-stop applications but also extends it to support metaprogramming with macros and polymorphism via protocols.",
      "id" => 104, "subTitle" => "Programming Language", "title" => "Elixir",
      "updated" => "2015-08-01T15:45:10.429Z"}
    conn = put conn, tool_path(conn, :update, id, entry)
    response = json_response(conn, 200)
    assert_match_except expected, response, ["updated", "created"]
  end

  test "update one partial entry", %{conn: conn} do
    id = 106
    entry = %{tool: %{id: id,
      title: "MySQL",
      subTitle: "Database",
      description: "MySQL a free/open source database owned by an \"evil empire\"."}
    }
    expected = %{"created" => "2015-08-01T11:37:08.910Z",
      "description" => "MySQL a free/open source database owned by an \"evil empire\".",
      "id" => 106, "subTitle" => "Database", "title" => "MySQL",
      "updated" => "2015-08-01T16:03:10.902Z"}
    conn = put conn, tool_path(conn, :update, id, entry)
    response = json_response(conn, 200)
    assert_match_except expected, response, ["updated", "created"]
  end

  test "delete one entry", %{conn: conn} do
    id = 101 # Java
    conn = delete conn, tool_path(conn, :delete, id)
    response = json_response(conn, 200)
    assert response == %{"tool" => %{}}
  end
end
