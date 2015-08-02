defmodule LooksLikeANailBackend.ImplementsControllerTest do
  use LooksLikeANailBackend.ConnCase, async: true

  import AssertMore
  alias LooksLikeANailBackend.Implements

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
    entry = %{"implements" => %{
        "created" => "string", "id" => 0, "feature" => 306, "tool" => 102, "updated" => "string"}}

    expected = %{"implements" => %{"feature" => 306, "tool" => 102, "updated" => nil, "created" => nil, "id" => 0}}

    conn = post conn, implements_path(conn, :create, entry)
    IO.inspect response = json_response(conn, 200)
    assert_match_except expected, response, ["updated", "created", "id"]
    id = get_in(response, ["implements", "id"])
    assert is_integer(id) and id > 0
  end

end
