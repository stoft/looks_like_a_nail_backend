defmodule LooksLikeANailBackend.Implements do

  defstruct(id: nil,
    feature: nil,
    tool: nil,
    feature: nil,
    created: "",
    updated: "")

  @required_fields ~w(id tool feature)
  @optional_fields ~w()

  def get_get_statement(id) do
    statement = "MATCH (t:Tool)-[i:IMPLEMENTS]->(f:Feature) WHERE i.id = {id} RETURN distinct {implements: {id: i.id, tool: t.id, feature: f.id, updated: i.updated, created: i.created}} as implements"
    parameters = %{id: id}
    {statement, parameters}
  end

  def get_create_statement(map) do
    %{"feature": feature, "tool": tool} = map
    parameters = %{"feature": feature, "tool": tool}
    statement = "MATCH (t:Tool), (f:Feature) " <>
    "WHERE t.id = {tool} and f.id = {feature} "<>
    "CREATE (t)-[i:IMPLEMENTS]->(f) " <>
    "SET i.id = id(i), " <>
    "i.updated = timestamp(), i.created = timestamp() " <>
    "RETURN distinct {implements: {id: i.id, tool: t.id, feature: f.id, updated: i.updated, created: i.created}} as implements"
    {statement, parameters}
  end
end