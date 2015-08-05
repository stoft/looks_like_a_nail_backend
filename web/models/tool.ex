defmodule LooksLikeANailBackend.Tool do

  defstruct(id: nil,
    title: nil,
    subTitle: "",
    keywords: [],
    description: "",
    implements: [], # outgoing/has_many
    supportedBy: [], # incoming/belongs_to_many
    inserted: "",
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
    statement = "MATCH (tool:Tool) OPTIONAL MATCH (tool)-[implements:IMPLEMENTS]->(feature:Feature) OPTIONAL MATCH (feature)-[provides:PROVIDES]->(capability) OPTIONAL MATCH (feature)-[supports:SUPPORTS]->(otherTool) RETURN distinct tool, implements, feature, provides, capability, supports, otherTool"
    parameters = %{}
    {statement, parameters}
  end

  def get_get_statement(id) do
    statement = "MATCH (tool:Tool) WHERE tool.id = {id} OPTIONAL MATCH (tool)-[implements:IMPLEMENTS]->(feature:Feature) OPTIONAL MATCH (feature)-[provides:PROVIDES]->(capability) OPTIONAL MATCH (feature)-[supports:SUPPORTS]->(otherTool) RETURN distinct tool, implements, feature, provides, capability, supports, otherTool"
    # "MATCH (tool:Tool) WHERE tool.id = #{id} RETURN tool"
    # "MATCH (tool:Tool) WHERE tool.id = #{id} OPTIONAL MATCH (tool)-[:IMPLEMENTS]->(f:Feature) OPTIONAL MATCH (tool)<-[:SUPPORTS]-(ff:Feature) RETURN {tool: tool, implements: collect(distinct f.id), supports: collect(distinct ff.id)}"
    parameters = %{id: id}
    {statement, parameters}
  end

  def get_delete_statement(id) do
    statement = "MATCH (t:Tool) WHERE t.id = {id} OPTIONAL MATCH (t)-[r:IMPLEMENTS]->(f:Feature)-[r2:PROVIDES]->(), (f)-[s:SUPPORTS]->() DELETE t, r, f, r2, s"
    parameters = %{id: id}
    {statement, parameters}
  end

  def get_update_statement(tool) do
    id = Map.get(tool, "id")
    title = Map.get(tool, "title")
    subTitle = Map.get(tool, "subTitle")
    description = Map.get(tool, "description")
    keywords = Map.get(tool, "keywords")
    statement = "MATCH (tool:Tool) WHERE tool.id = {id} SET tool.title = {title}, tool.subTitle = {subTitle}, tool.description = {description}, tool.updated = timestamp(), tool.keywords = {keywords} RETURN tool"
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
    statement = "CREATE (tool:Tool {props}) " <>
    "SET tool.id = id(tool), " <>
    "tool.updated = timestamp(), tool.created = timestamp() " <>
    "RETURN tool"
    {statement, parameters}
  end

end
