defmodule LooksLikeANailBackend.Provides do

  defstruct(id: nil,
    feature: nil,
    task: nil,
    created: "",
    updated: "")

  @required_fields ~w(id task)
  @optional_fields ~w(feature)

  def get_create_statement(map) do
    %{"feature" => feature, "task" => task} = map
    feature = (is_integer(feature) && feature || String.to_integer(feature))
    task = (is_integer(task) && task || String.to_integer(task))
    parameters = %{"feature": feature, "task": task}
    statement = "MATCH (t:Task), (f:Feature) " <>
    "WHERE t.id = {task} and f.id = {feature} "<>
    "CREATE (f)-[p:PROVIDES]->(t) " <>
    "SET p.id = id(p), " <>
    "p.updated = timestamp(), p.created = timestamp() " <>
    "RETURN distinct {provides: {id: p.id, task: t.id, feature: f.id, updated: p.updated, created: p.created}} as provides"
    {statement, parameters}
  end

  def get_get_statement(id) do
    id = (is_integer(id) && id || String.to_integer(id))
    parameters = %{"id" => id}
    statement = "MATCH (f:Feature)-[p:PROVIDES]->(t:Task) " <>
    "WHERE p.id = {id} " <>
    "RETURN distinct {provides: {id: p.id, task: t.id, feature: f.id, updated: p.updated, created: p.created}} as provides"
    {statement, parameters}
  end

  def get_delete_statement(id) do
    id = (is_integer(id) && id || String.to_integer(id))
    statement = "MATCH (:Feature)-[p:PROVIDES]->(:Task) WHERE p.id = {id} DELETE p"
    parameters = %{id: id}
    {statement, parameters}
  end  
end