defmodule LooksLikeANailBackend.ConceptControllerTest do
  use LooksLikeANailBackend.ConnCase, async: true

  import AssertMore
  alias LooksLikeANailBackend.Concept

  @moduletag :external

  @valid_attrs %{description: "some content",
    title: "title", sub_title: "sub_title",
    keywords: ["key", "word"], insert_at: "", updated_at: ""}
  @invalid_attrs %{}

  @entry %{"concept" => %{
      "title"       => "ConceptTest",
      "subTitle"    => "Cloud",
      "description" => "Paying per CPU cycle",
      "updated"     => 1440919817908,
      "created"     => 1440919817908,
      "keywords"    => ["cloud", "computing"]}}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")

    parameters = @entry
    statement = "CREATE (n:Concept {concept}) SET n.id = id(n) RETURN n.id as id"
    response = Neo4J.Repo.do_cypher_statements_with_params!([{statement, parameters}])
    id = response
      |> get_in(["results"]) |> hd
      |> get_in(["data"]) |> hd
      |> get_in(["row"]) |> hd

    on_exit fn ->
      statement = "MATCH (n) WHERE n.title = \"ConceptTest\" DELETE n"
      Neo4J.Repo.do_cypher_statements!([statement])
    end
    {:ok, [conn: conn, id: id]}
  end

  test "create a concept", %{conn: conn} do
    entry = @entry

    expected = Dict.put(entry, "id", nil)
    conn = post conn, concept_path(conn, :create, entry)
    response = json_response(conn, 200)
    assert_equal_except expected, response, ["id", "updated", "created"]
    id = get_in response, ["concept", "id"]
    assert is_integer(id)
  end

  test "read a concept", %{conn: conn, id: id} do
    conn = get conn, concept_path(conn, :show, id)
    response = json_response(conn, 200)
    assert_equal_except @entry, response, ["created", "updated"]
  end

  test "read many concepts", %{conn: conn} do
    conn = get conn, concept_path(conn, :index)
    response = json_response(conn, 200)
    assert get_in(response, ["concepts"]) != nil
    list = for concept <- get_in(response, ["concepts"]),
      get_in(concept, ["title"]) == get_in(@entry, ["concept", "title"]),
      do: concept
    assert_equal_except @entry["concept"], hd(list), ["created", "updated"]
  end

  test "update a concept", %{conn: conn, id: id} do
    entry = put_in(@entry, ["concept", "subTitle"], "Cumulus")
    conn = put conn, concept_path(conn, :update, id, entry)
    response = json_response(conn, 200)
    assert_equal_except entry, response, ["created", "updated"]
  end

  test "delete a concept", %{conn: conn, id: id} do
    conn = delete conn, concept_path(conn, :delete, id)
    response = json_response(conn, 200)
    assert response == %{"concept" => %{}}
  end

end
