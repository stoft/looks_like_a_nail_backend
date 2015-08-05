defmodule LooksLikeANailBackend.Capability do

  defstruct(id: nil,
    title: nil,
    subTitle: "",
    keywords: [],
    description: "",
    created: "",
    updated: "")

  @required_fields ~w(id title)
  @optional_fields ~w(subTitle keywords description)

  # def validate(capability) do
  #   errors = []
  #   for field <- @required_fields, do:
  #     if(Map.get(capability, field) == nil), do: errors = errors ++ {ValidationError, "Field #{field} must not be nil."}
  #   errors
  # end

  def get_all_statement() do
    statement = "MATCH (capability:Capability) RETURN capability"
    parameters = %{}
    {statement, parameters}
  end

  def get_get_statement(id) do
    statement = "MATCH (capability:Capability) WHERE capability.id = {id} RETURN capability"
    parameters = %{id: id}
    {statement, parameters}
  end

  def get_delete_statement(id) do
    statement = "MATCH (capability:Capability) WHERE capability.id = {id} DELETE capability"
    parameters = %{id: id}
    {statement, parameters}
  end

  def get_update_statement(capability) do
    id = Map.get(capability, "id")
    title = Map.get(capability, "title")
    subTitle = Map.get(capability, "subTitle")
    description = Map.get(capability, "description")
    keywords = Map.get(capability, "keywords")
    statement = "MATCH (capability:Capability) WHERE capability.id = {id} " <>
    "SET capability.title = {title}, " <>
    "capability.subTitle = {subTitle}, " <>
    "capability.description = {description}, " <>
    "capability.updated = timestamp(), " <>
    "capability.keywords = {keywords} " <>
    "RETURN capability"
    parameters = %{id: id, title: title, subTitle: subTitle, description: description, keywords: keywords}
    {statement, parameters}
  end

  @doc """
  Generates a create statement from a given Capability.

      iex> LooksLikeANailBackend.Capability.get_create_statement(%{title: "Foo"})
      "CREATE (capability:Capability {title: "Foo"}) SET capability.id = id(capability) RETURN capability"
  """
  def get_create_statement(map) do
    parameters = %{props: map}
    statement = "CREATE (capability:Capability {props}) " <>
    "SET capability.id = id(capability), " <>
    "capability.updated = timestamp(), capability.created = timestamp() " <>
    "RETURN capability"
    {statement, parameters}
  end    
end
