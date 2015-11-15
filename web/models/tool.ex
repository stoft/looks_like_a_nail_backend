defmodule LooksLikeANailBackend.Tool do

  alias LooksLikeANailBackend.Feature
  alias LooksLikeANailBackend.Capability
  alias LooksLikeANailBackend.Concept

  defstruct(id: nil,
    title: nil,
    subTitle: "",
    keywords: [],
    description: "",
    features: [], # outgoing/has_many
    supportedBy: [], # incoming/belongs_to_many
    created: "",
    updated: "")
    # features: [])

  @required_fields ~w(id title)
  @optional_fields ~w(subTitle keywords description features)

  # def validate(tool) do
  #   errors = []
  #   for field <- @required_fields, do:
  #     if(Map.get(tool, field) == nil), do: errors = errors ++ {ValidationError, "Field #{field} must not be nil."}
  #   errors
  # end  

  def get_all_statement() do
    tools         = "MATCH (tool:Tool)"
    features      = "OPTIONAL MATCH (tool)-[:IMPLEMENTS]->(feature:Feature)"
    capabilities  = "OPTIONAL MATCH (feature)-[:PROVIDES]->(capability:Capability)"
    concepts      = "OPTIONAL MATCH (feature)-[supports:SUPPORTS]->(concept:Concept)"
    return        = "RETURN distinct tool, feature, capability, concept"
    statement = "#{tools} #{features} #{capabilities} #{concepts} #{return}"
    parameters = %{}
    {statement, parameters}
  end

  def get_get_statement(id) do
    statement = "MATCH (tool:Tool) WHERE tool.id = {id} OPTIONAL MATCH (tool)-[implements:IMPLEMENTS]->(feature:Feature) OPTIONAL MATCH (feature)-[provides:PROVIDES]->(capability) OPTIONAL MATCH (feature)-[supports:SUPPORTS]->(concept) RETURN distinct tool, feature, provides, capability, concept"
    parameters = %{id: id}
    {statement, parameters}
  end

  def get_delete_statement(id) do
    statement = "MATCH (t:Tool) WHERE t.id = {id} OPTIONAL MATCH (t)-[i:IMPLEMENTS]->(f:Feature)-[p:PROVIDES]->(), (f)-[s:SUPPORTS]->() DELETE t, i, f, p, s"
    parameters = %{id: id}
    {statement, parameters}
  end

  def get_update_statement(tool) do
    id = Map.get(tool, "id")
    title = Map.get(tool, "title")
    subTitle = Map.get(tool, "subTitle")
    description = Map.get(tool, "description")
    keywords = Map.get(tool, "keywords")
    statement = "MATCH (tool:Tool) WHERE tool.id = {id} OPTIONAL MATCH (tool)-[:IMPLEMENTS]->(f:Feature) SET tool.title = {title}, tool.subTitle = {subTitle}, tool.description = {description}, tool.updated = timestamp(), tool.keywords = {keywords} RETURN {id: tool.id, title: tool.title, subTitle: tool.subTitle, description: tool.description, created: tool.created, updated: tool.updated, features: collect(distinct f.id)} as tool"
    parameters = %{id: id, title: title, subTitle: subTitle, description: description, keywords: keywords}
    {statement, parameters}
  end

  @doc """
  Generates a create statement from a given Tool.

      iex> LooksLikeANailBackend.Tool.get_create_statement(%{title: "Foo"})
      "CREATE (tool:Tool {title: "Foo"}) SET tool.id = id(tool) RETURN tool"
  """
  def get_create_statement(map) do
    parameters = %{props: map}
    statement = "CREATE (tool:Tool:Concept {props}) " <>
    "SET tool.id = id(tool), " <>
    "tool.updated = timestamp(), tool.created = timestamp() " <>
    "RETURN tool"
    {statement, parameters}
  end

end
