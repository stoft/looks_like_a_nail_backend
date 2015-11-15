defmodule LooksLikeANailBackend.SupportsControllerTest do
  use LooksLikeANailBackend.ConnCase, async: true

  import AssertMore
  alias LooksLikeANailBackend.Supports

  @moduletag :external

  @valid_attrs %{description: "some content",
    title: "title", sub_title: "sub_title",
    keywords: ["key", "word"], inserted: "", updated: ""}
  @invalid_attrs %{}

  @entry %{"supports" => %{
        "id" => 0,
        "feature" => 0,
        "concept" => 0,
        "created" => 1440919817908,
        "updated" => 1440919817908}}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")

    create = "CREATE (t:Tool {title: \"Test\"})-[i:IMPLEMENTS]->(f:Feature {title: \"Test\"})-[s:SUPPORTS]->(c:Concept {title: \"Test\"})"
    set = "SET s.id = id(s), s.created = timestamp(), s.updated = timestamp(), t.id = id(t), f.id = id(f), c.id = id(c)"
    return = "RETURN t.id as tool_id, f.id as feature_id, s.id as id, c.id as concept_id"
    statement = "#{create} #{set} #{return}"
    response = Neo4J.Repo.do_cypher_statements!([statement])
    ids = response
      |> get_in(["results"]) |> hd
      |> get_in(["data"]) |> hd
      |> get_in(["row"])
    id_dict = Enum.zip [:tool_id, :feature_id, :id, :concept_id], ids

    on_exit fn ->
      parameters = %{"list" => ids}
      statement = "MATCH (n) WHERE id(n) in {list} OPTIONAL MATCH (n)-[r]->() DELETE n,r"
      Neo4J.Repo.do_cypher_statements_with_params!([{statement, parameters}])
    end

    {:ok, [conn: conn, ids: id_dict]}
  end

  test "create one entry", %{conn: conn, ids: ids} do
    tool_id = get_in(ids, [:tool_id])
    concept_id = get_in(ids, [:concept_id])
    feature_id = get_in(ids, [:feature_id])

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

  test "delete one entry", %{conn: conn, ids: ids} do
    tool_id = get_in(ids, [:tool_id])
    feature_id = get_in(ids, [:feature_id])
    id = get_in(ids, [:id])

    conn = delete conn, tool_feature_supports_path(conn, :delete, tool_id, feature_id, id, %{})
    response = json_response(conn, 200)
    assert response == %{"supports" => %{}}
  end

end
