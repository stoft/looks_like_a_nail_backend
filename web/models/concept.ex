defmodule LooksLikeANailBackend.Concept do
  

  defstruct(id: nil,
    title: nil,
    subTitle: "",
    keywords: [],
    description: "",
    inserted: "",
    updated: "")

  @required_fields ~w(id title)
  @optional_fields ~w(subTitle keywords description features)

  def get_all_statement() do
    statement = "MATCH (concept:Concept) RETURN distinct {id: concept.id, title: concept.title, subTitle: concept.subTitle, keywords: concept.keywords, description: concept.description, inserted: concept.inserted, updated: concept.updated}"
    parameters = %{}
    {statement, parameters}
  end

  def get_get_statement(id) do
    statement = "MATCH (concept:Concept) WHERE concept.id = {id} RETURN {id: concept.id, title: concept.title, subTitle: concept.subTitle, keywords: concept.keywords, description: concept.description, inserted: concept.inserted, updated: concept.updated}"
    parameters = %{id: id}
    {statement, parameters}
  end

  def get_delete_statement(id) do
    statement = "MATCH (t:Concept) WHERE t.id = {id} OPTIONAL MATCH (t)-[r:IMPLEMENTS]->(f:Feature)-[r2:PROVIDES]->(), (f)-[s:SUPPORTS]->() DELETE t, r, f, r2, s"
    parameters = %{id: id}
    {statement, parameters}
  end

  def get_update_statement(concept) do
    id = Map.get(concept, "id")
    title = Map.get(concept, "title")
    subTitle = Map.get(concept, "subTitle")
    description = Map.get(concept, "description")
    keywords = Map.get(concept, "keywords")
    statement = "MATCH (concept:Concept) WHERE concept.id = {id} SET concept.title = {title}, concept.subTitle = {subTitle}, concept.description = {description}, concept.updated = timestamp(), concept.keywords = {keywords} RETURN {id: concept.id, title: concept.title, subTitle: concept.subTitle, description: concept.description, created: concept.created, updated: concept.updated, features: collect(distinct f.id)} as concept"
    parameters = %{id: id, title: title, subTitle: subTitle, description: description, keywords: keywords}
    {statement, parameters}
  end

  @doc """
  Generates a create statement from a given Concept.

      iex> LooksLikeANailBackend.Concept.get_create_statement(%{title: "Foo"})
      "CREATE (concept:Concept {title: "Foo"}) SET concept.id = id(concept) RETURN concept"
  """
  def get_create_statement(map) do
    parameters = %{props: map}
    statement = "CREATE (concept:Concept {props}) " <>
    "SET concept.id = id(concept), " <>
    "concept.updated = timestamp(), concept.created = timestamp() " <>
    "RETURN distinct {id: concept.id, title: concept.title, subTitle: concept.subTitle, keywords: concept.keywords, description: concept.description, inserted: concept.inserted, updated: concept.updated}"
    {statement, parameters}
  end


end