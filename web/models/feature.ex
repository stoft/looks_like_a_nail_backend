defmodule LooksLikeANailBackend.Feature do
  
  defstruct(id: nil,
    title: nil,
    subTitle: "",
    keywords: [],
    provides: nil,
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
    statement = "MATCH (feature:Feature) WHERE feature.id = {id} RETURN feature"
    parameters = %{id: id}
    {statement, parameters}
  end

  def get_delete_statement(id) do
    statement = "MATCH (feature:Feature) WHERE feature.id = {id} DELETE feature"
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
    statement = "CREATE (feature:Feature {props}) " <>
    "SET feature.id = id(feature), " <>
    "feature.updated = timestamp(), feature.created = timestamp() " <>
    "RETURN feature"
    parameters = %{props: map}
    {statement, parameters}
  end

end