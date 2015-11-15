defmodule LooksLikeANailBackend.Concept do
  

  defstruct(id: nil,
    title: nil,
    subTitle: "",
    keywords: [],
    description: "",
    created: "",
    updated: "")

  @required_fields ~w(id title)
  @optional_fields ~w(subTitle keywords description features)

  def get_all_statement() do
    statement = "MATCH (concept:Concept) RETURN distinct {id: concept.id, title: concept.title, subTitle: concept.subTitle, keywords: concept.keywords, description: concept.description, created: concept.created, updated: concept.updated}"
    parameters = %{}
    {statement, parameters}
  end

  def get_get_statement(id) do
    statement = "MATCH (concept:Concept) WHERE concept.id = {id} RETURN {id: concept.id, title: concept.title, subTitle: concept.subTitle, keywords: concept.keywords, description: concept.description, created: concept.created, updated: concept.updated} as concept"
    parameters = %{id: id}
    {statement, parameters}
  end

  def get_delete_statement(id) do
    statement = "MATCH (c:Concept) WHERE c.id = {id} OPTIONAL MATCH (c)<-[s:SUPPORTS]-(f:Feature) DELETE c, s"
    parameters = %{id: id}
    {statement, parameters}
  end

  def get_update_statement(concept) do
    id = Map.get(concept, "id")
    title = Map.get(concept, "title")
    subTitle = Map.get(concept, "subTitle")
    description = Map.get(concept, "description")
    keywords = Map.get(concept, "keywords")
    statement = "MATCH (concept:Concept) WHERE concept.id = {id} SET concept.title = {title}, concept.subTitle = {subTitle}, concept.description = {description}, concept.updated = timestamp(), concept.keywords = {keywords} RETURN {id: concept.id, title: concept.title, subTitle: concept.subTitle, description: concept.description, created: concept.created, updated: concept.updated, keywords: concept.keywords} as concept"
    parameters = %{id: id, title: title, subTitle: subTitle, description: description, keywords: keywords}
    {statement, parameters}
  end

  def get_create_statement(map) do
    map = Dict.take(map, @required_fields ++ @optional_fields)
    parameters = %{props: map}
    statement = "CREATE (concept:Concept {props}) " <>
    "SET concept.id = id(concept), " <>
    "concept.updated = timestamp(), concept.created = timestamp() " <>
    "RETURN distinct {id: concept.id, title: concept.title, subTitle: concept.subTitle, keywords: concept.keywords, description: concept.description, created: concept.created, updated: concept.updated} as concept"
    {statement, parameters}
  end


end