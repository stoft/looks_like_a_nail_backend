defmodule LooksLikeANailBackend.SupportsControllerTest do
  use LooksLikeANailBackend.ConnCase, async: true

  import AssertMore
  alias LooksLikeANailBackend.Supports

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
    tool_id = 107
    concept_id = 104
    feature_id = 306

    entry = %{"supports" => %{
        "created" => "string", "id" => 0, "feature" => feature_id,
        "concept" => concept_id, "updated" => "string"}}

    expected = %{"supports" => %{
      "feature" => feature_id, "concept" => concept_id, "updated" => nil,
      "created" => nil, "id" => 0}}

    conn = post conn, tool_feature_supports_path(conn, :create, tool_id, feature_id, entry)
    response = json_response(conn, 200)
    assert_match_except expected, response, ["updated", "created", "id"]
    id = get_in(response, ["supports", "id"])
    assert is_integer(id) and id > 0
  end

  test "delete one entry", %{conn: conn} do
    tool_id = 107
    feature_id = 306
    id = 3057
    conn = delete conn, tool_feature_supports_path(conn, :delete, tool_id, feature_id, id, %{})
    IO.inspect response = json_response(conn, 200)
    assert response == %{"supports" => %{}}
  end

end
