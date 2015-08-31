defmodule LooksLikeANailBackend.Feature do
  
  defstruct(id: nil,
    title: nil,
    subTitle: "",
    keywords: [],
    capability: nil,
    concepts: [],
    description: "",
    created: "",
    updated: "")

  @required_fields ~w(id title)
  @optional_fields ~w(subTitle keywords description)

  def get_all_statement() do
    statement = "MATCH (feature:Feature) RETURN feature"
    parameters = %{}
    {statement, parameters}
  end

  def get_get_statement(id) do
    match = "MATCH (f:Feature) WHERE f.id = {id} OPTIONAL MATCH (f)-[s:SUPPORTS]->(ct) OPTIONAL MATCH (f)-[p:PROVIDES]->(cy)"
    return = "RETURN {id: f.id, title: f.title, description: f.description, subTitle: f.subTitle, capability: cy.id, concepts: collect(distinct ct.id)}"
    statement = "#{match} #{return}"
    parameters = %{id: id}
    {statement, parameters}
  end

  def get_delete_statement(id) do
    statement = "MATCH (feature:Feature) OPTIONAL MATCH (feature)-[r]-() WHERE feature.id = {id} DELETE feature, r"
    parameters = %{id: id}
    {statement, parameters}
  end

  def get_update_statement(feature) do
    id = Map.get(feature, "id")
    title = Map.get(feature, "title")
    subTitle = Map.get(feature, "subTitle")
    description = Map.get(feature, "description")
    keywords = Map.get(feature, "keywords")
    statement = "MATCH (feature:Feature) WHERE feature.id = {id} " <>
    "SET feature.title = {title}, " <>
    "feature.subTitle = {subTitle}, " <>
    "feature.description = {description}, " <>
    "feature.updated = timestamp(), " <>
    "feature.keywords = {keywords} " <>
    "RETURN feature"
    parameters = %{id: id, title: title, subTitle: subTitle, description: description, keywords: keywords}
    {statement, parameters}
  end

  def get_create_statement(map) do
    tool = Dict.get(map, "tool")
    capability = Dict.get(map, "capability")
    statement = "MATCH (t:Tool), (c:Capability) WHERE t.id = {tool} and c.id = {capability} " <>
    "CREATE (t)-[i:IMPLEMENTS]->(feature:Feature {props})-[p:PROVIDES]->(c) " <>
    "SET feature.id = id(feature), " <>
    "feature.updated = timestamp(), feature.created = timestamp() " <>
    "RETURN feature"
    parameters = %{props: map, tool: tool, capability: capability}
    {statement, parameters}
  end

end