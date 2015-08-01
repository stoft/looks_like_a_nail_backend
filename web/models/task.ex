defmodule LooksLikeANailBackend.Task do

  defstruct(id: nil,
    title: nil,
    subTitle: "",
    keywords: [],
    description: "",
    created: "",
    updated: "")

  @required_fields ~w(id title)
  @optional_fields ~w(subTitle keywords description)

  # def validate(task) do
  #   errors = []
  #   for field <- @required_fields, do:
  #     if(Map.get(task, field) == nil), do: errors = errors ++ {ValidationError, "Field #{field} must not be nil."}
  #   errors
  # end

  def get_all_statement() do
    statement = "MATCH (task:Task) RETURN task"
    parameters = %{}
    {statement, parameters}
  end

  def get_get_statement(id) do
    statement = "MATCH (task:Task) WHERE task.id = {id} RETURN task"
    parameters = %{id: id}
    {statement, parameters}
  end

  def get_delete_statement(id) do
    statement = "MATCH (task:Task) WHERE task.id = {id} DELETE task"
    parameters = %{id: id}
    {statement, parameters}
  end

  def get_update_statement(task) do
    id = Map.get(task, "id")
    title = Map.get(task, "title")
    subTitle = Map.get(task, "subTitle")
    description = Map.get(task, "description")
    keywords = Map.get(task, "keywords")
    statement = "MATCH (task:Task) WHERE task.id = {id} " <>
    "SET task.title = {title}, " <>
    "task.subTitle = {subTitle}, " <>
    "task.description = {description}, " <>
    "task.updated = timestamp(), " <>
    "task.keywords = {keywords} " <>
    "RETURN task"
    parameters = %{id: id, title: title, subTitle: subTitle, description: description, keywords: keywords}
    {statement, parameters}
  end

  @doc """
  Generates a create statement from a given Task.

      iex> LooksLikeANailBackend.Task.get_create_statement(%{title: "Foo"})
      "CREATE (task:Task {title: "Foo"}) SET task.id = id(task) RETURN task"
  """
  def get_create_statement(map) do
    parameters = %{props: map}
    statement = "CREATE (task:Task {props}) " <>
    "SET task.id = id(task), " <>
    "task.updated = timestamp(), task.created = timestamp() " <>
    "RETURN task"
    {statement, parameters}
  end    
end
