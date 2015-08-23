defmodule LooksLikeANailBackend.FeatureControllerTest do
  use LooksLikeANailBackend.ConnCase, async: true

  import AssertMore
  alias LooksLikeANailBackend.Feature

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
    entry = %{"feature" => %{
        "created" => "string", "id" => 0, "capability" => 205, "updated" => "string",
        "title" => "title", "subTitle" => "sub_title"}}

    expected = %{"feature" => %{"capability" => 205, "tool" => 102, "updated" => nil, "created" => nil, "id" => 0,
      "title" => "title", "subTitle" => "sub_title"}}

    conn = post conn, tool_feature_path(conn, :create, 102, entry)
    response = json_response(conn, 200)
    assert_match_except expected, response, ["updated", "created", "id"]
    id = get_in(response, ["feature", "id"])
    assert is_integer(id) and id > 0
  end

  test "create entry for non-existant capability", %{conn: conn} do
    entry = %{"feature" => %{
        "created" => "string", "id" => 0, "capability" => 999, "updated" => "string",
        "title" => "title", "subTitle" => "sub_title"}}

    expected = "Page not found"

    conn = post conn, tool_feature_path(conn, :create, 102, entry)
    response = json_response(conn, 404)
    assert expected === response
  end

end
