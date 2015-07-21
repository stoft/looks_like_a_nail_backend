defmodule LooksLikeANailBackend.TestDBHelper do

  def setup_db(:tool_feature_task) do
    tool1 = get_property_set("Tool1")
    tool2 = get_property_set("Tool2")
    feature1 = get_property_set("Feature1")
    feature2 = get_property_set("Feature2")
    task1 = get_property_set("Task1")
    task2 = get_property_set("Task2")
    s1 = get_create_statement tool1, feature1, task1
    s2 = get_create_statement tool2, feature2, task2
    result = Neo4J.Repo.do_cypher_statements! [s1, s2]
    data = for result <- result["results"], do: result["data"] |> hd
    [id1, id2] = for m <- data, do: m["row"] |> hd |> Dict.get("id")
    {id1, id2}
  end

  def teardown_db(:tool_feature_task, ids) do
    statements = for id <- ids, do: get_delete_statement id
    result = Neo4J.Repo.do_cypher_statements! statements
  end

  def create_single_node(type) do
    statement = "CREATE (n:#{type} {title: \"Example\"}) \
      SET n.id = id(n) RETURN n"
    result = Neo4J.Repo.do_cypher_statements! [statement]
    data = for result <- result["results"], do: result["data"] |> hd
    ids = for m <- data, do: m["row"] |> hd |> Dict.get("id")
  end

  def delete_single_node(id) do
    statement = "MATCH (n {id: #{id}}) DELETE n"
    result = Neo4J.Repo.do_cypher_statements! [statement]
  end

  def get_ids_from_neo_response(response) do
    data = for result <- response["results"], do: result["data"] |> hd
    ids = for m <- data, do: m["row"] |> hd |> Dict.get("id")
  end
  

  defp get_create_statement(tool, feature, task) do
    "CREATE (to:Tool #{tool})-[:IMPLEMENTS]->\
      (f:Feature #{feature})-[:IS_CAPABLE_OF]->\
      (ta:Task #{task}) \
      SET to.id = id(to), f.id = id(f), ta.id = id(ta), \
      to.updated = timestamp(), to.created = timestamp(), \
      f.updated = timestamp(), f.created = timestamp(), \
      ta.created = timestamp(), ta.updated = timestamp() \
      RETURN to, f, ta"
  end

  defp get_property_set(name) do
    "{title: \"#{name}\", subTitle: \"Example\", \
    description: \"Example desc\"}"
  end

  defp get_delete_statement(id) do
    "MATCH (tool:Tool {id: #{id}}) \
      OPTIONAL MATCH (tool)-[r]-(f)-[r2]-(t) \
      DELETE tool, r, f, r2, t"
  end
  
  
end