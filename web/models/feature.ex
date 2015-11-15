defmodule LooksLikeANailBackend.Feature do
  
  defstruct(id: nil,
    title: nil,
    subTitle: "",
    keywords: [],
    capability: nil,
    supports: [],
    description: "",
    created: "",
    updated: "")

  @required_fields ~w(id title)
  @optional_fields ~w(subTitle keywords description)

  def get_return_structure() do
    "{id: feature.id, title: feature.title, subTitle: feature.subTitle, keywords: feature.keywords, description: feature.description, tool: tool.id, capability: capability.id, supports: collect(distinct(concept.id)), created: feature.created, updated: feature.updated} as feature"
  end

  def get_all_statement() do
    statement = "MATCH (feature:Feature) RETURN feature"
    parameters = %{}
    {statement, parameters}
  end

  def get_get_statement(id) do
    match = "MATCH (feature:Feature) WHERE feature.id = {id} OPTIONAL MATCH (feature)-[s:SUPPORTS]->(concept:Concept) OPTIONAL MATCH (feature)-[p:PROVIDES]->(capability)"
    return = "RETURN #{get_return_structure}"
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
    map = Dict.take(map, @required_fields ++ @optional_fields)
    statement = "MATCH (tool:Tool), (capability:Capability) " <>
    "WHERE tool.id = {tool} and capability.id = {capability} " <>
    "CREATE (tool)-[i:IMPLEMENTS]->(feature:Feature {props})-[p:PROVIDES]->(capability) " <>
    "SET feature.id = id(feature), " <>
    "feature.updated = timestamp(), feature.created = timestamp() " <>
    "RETURN {id: feature.id, title: feature.title, subTitle: feature.subTitle, keywords: feature.keywords, description: feature.description, tool: tool.id, capability: capability.id, supports: null, created: feature.created, updated: feature.updated} as feature"
    # "RETURN feature, t as tool, c as capability"
    parameters = %{props: map, tool: tool, capability: capability}
    {statement, parameters}
  end

end