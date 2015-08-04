defmodule LooksLikeANailBackend.ProvidesControllerTest do
  use LooksLikeANailBackend.ConnCase, async: true

  import AssertMore
  alias LooksLikeANailBackend.Provides

  @moduletag :external

  @valid_attrs %{description: "some content",
    title: "title", sub_title: "sub_title",
    keywords: ["key", "word"], inserted: "", updated: ""}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "create one entry", %{conn: conn} do
    entry = %{"provides" => %{
        "created" => "string", "id" => 0, "feature" => 308, "task" => 205, "updated" => "string"}}

    expected = %{"provides" => %{"feature" => 308, "task" => 205, "updated" => nil, "created" => nil, "id" => 0}}

    conn = post conn, provides_path(conn, :create, entry)
    response = json_response(conn, 200)
    assert_match_except expected, response, ["updated", "created", "id"]
    id = get_in(response, ["provides", "id"])
    assert is_integer(id) and id > 0
  end

  test "delete one entry", %{conn: conn} do
    id = 3062
    conn = delete conn, provides_path(conn, :delete, id)
    IO.inspect response = json_response(conn, 200)
    assert response == %{"provides" => %{}}
  end

end
