defmodule LooksLikeANailBackend.Provides do

  defstruct(id: nil,
    feature: nil,
    capability: nil,
    created: "",
    updated: "")

  @required_fields ~w(id capability)
  @optional_fields ~w(feature)

  def get_create_statement(map) do
    %{"feature" => feature, "capability" => capability} = map
    feature = (is_integer(feature) && feature || String.to_integer(feature))
    capability = (is_integer(capability) && capability || String.to_integer(capability))
    parameters = %{"feature": feature, "capability": capability}
    statement = "MATCH (t:Capability), (f:Feature) " <>
    "WHERE t.id = {capability} and f.id = {feature} "<>
    "CREATE (f)-[p:PROVIDES]->(t) " <>
    "SET p.id = id(p), " <>
    "p.updated = timestamp(), p.created = timestamp() " <>
    "RETURN distinct {provides: {id: p.id, capability: t.id, feature: f.id, updated: p.updated, created: p.created}} as provides"
    {statement, parameters}
  end

  def get_get_statement(id) do
    id = (is_integer(id) && id || String.to_integer(id))
    parameters = %{"id" => id}
    statement = "MATCH (f:Feature)-[p:PROVIDES]->(t:Capability) " <>
    "WHERE p.id = {id} " <>
    "RETURN distinct {provides: {id: p.id, capability: t.id, feature: f.id, updated: p.updated, created: p.created}} as provides"
    {statement, parameters}
  end

  def get_delete_statement(id) do
    id = (is_integer(id) && id || String.to_integer(id))
    statement = "MATCH (:Feature)-[p:PROVIDES]->(:Capability) WHERE p.id = {id} DELETE p"
    parameters = %{id: id}
    {statement, parameters}
  end  
end