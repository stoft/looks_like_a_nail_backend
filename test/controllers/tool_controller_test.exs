defmodule LooksLikeANailBackend.ToolControllerTest do
  use LooksLikeANailBackend.ConnCase, async: true

  alias LooksLikeANailBackend.Tool
  alias LooksLikeANailBackend.TestDBHelper

  @moduletag :external

  # @valid_attrs %{description: "some content",
  #   title: "title", sub_title: "sub_title",
  #   keywords: ["key", "word"], insert_at: "", updated_at: ""}
  # @invalid_attrs %{}

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
    id = 101
    expected = %{ "tool" => %{"id"=> 101,
      "title" => "Java", "subTitle" => "Programming Language",
      "description" => "JavaDescription"}}
    conn = get conn, tool_path(conn, :show, id)
    response = json_response(conn, 200)
    {actual, _} = Dict.split(response["tool"], Dict.keys(expected["tool"]))
    actual = %{"tool" => actual}
    assert expected === actual
  end

  test "try to show one non-existent entry", %{conn: conn} do
    conn = get conn, tool_path(conn, :show, 0)
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
    id = response |> Map.get("tool") |> Map.get("id")
  end

  test "update one entry", %{conn: conn} do
    id = 104
    entry = %{tool: %{id: id,
      title: "Elixir",
      subTitle: "Programming Language",
      description: "Elixir is a functional, concurrent, general-purpose programming language that runs on the Erlang virtual machine (BEAM). Elixir builds on top of Erlang to provide distributed, fault-tolerant, soft real-time, non-stop applications but also extends it to support metaprogramming with macros and polymorphism via protocols.",
      updated: "2015-07-16T15:46:53.023+0000",
      created: "2015-07-16T15:46:53.023+0000"}}
      # features: [1,2,3]}}
    conn = put conn, tool_path(conn, :update, id, entry)
    response = json_response(conn, 200)
    assert response |> Map.has_key?("tool")
  end

  test "update one partial entry", %{conn: conn} do
    id = 106
    entry = %{tool: %{id: id,
      title: "MySQL",
      subTitle: "Database",
      description: "MySQL a free/open source database owned by an evil empire."}
    }
    conn = put conn, tool_path(conn, :update, id, entry)
    response = json_response(conn, 200)
    assert response |> Map.has_key?("tool")
  end

  test "delete one entry", %{conn: conn} do
    id = 106 # MySQL
    conn = delete conn, tool_path(conn, :delete, id)
    response = json_response(conn, 200)
    assert response == %{"tool" => %{}}
  end

end
