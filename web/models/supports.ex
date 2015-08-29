defmodule LooksLikeANailBackend.Supports do

  defstruct(id: nil,
    feature: nil,
    concept: nil,
    created: "",
    updated: "")

  @required_fields ~w(id concept)
  @optional_fields ~w(feature)

  def get_create_statement(%{"feature_id" => f_id, "concept_id" => c_id}) do
    parameters = %{"f_id" => f_id, "c_id" => c_id}
    statement = "MATCH (c:Concept), (f:Feature) " <>
    "WHERE c.id = {c_id} and f.id = {f_id} "<>
    "CREATE (f)-[s:SUPPORTS]->(c) " <>
    "SET s.id = id(s), " <>
    "s.updated = timestamp(), s.created = timestamp() " <>
    "RETURN {id: s.id, feature: f.id, concept: c.id, created: s.created, updated: s.updated} as supports"
    {statement, parameters}
  end

  def get_delete_statement(id) do
    parameters = %{"id" => id}
    statement = "MATCH (:Feature)-[s:SUPPORTS]->() WHERE s.id = {id} DELETE s"
    {statement, parameters}
  end

  def get_get_statement(id) do
    parameters = %{"id" => id}
    statement = "MATCH (f:Feature)-[s:SUPPORTS]->(c) WHERE s.id = {id} " <>
    "RETURN {feature: f.id, concept: c.id, id: s.id, created: s.created, updated: s.updated} as supports"
    {statement, parameters}
  end
  
  

end