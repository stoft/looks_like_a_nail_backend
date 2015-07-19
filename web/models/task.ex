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
    "MATCH (task:Task) RETURN task"
  end

  def get_get_statement(id) do
    "MATCH (task:Task {id: #{id}}) RETURN task"
  end

  def get_delete_statement(id) do
    "MATCH (task:Task) WHERE task.id = #{id} DELETE task"
  end

  def get_update_statement(task) do
    id = Map.get(task, "id")
    title = Map.get(task, "title")
    subTitle = Map.get(task, "subTitle")
    description = Map.get(task, "description")
    keywords = Map.get(task, "keywords")
    "MATCH (task:Task {id: #{id}}) " <>
    "SET task.title = \"#{title}\", " <>
    "task.subTitle = \"#{subTitle}\", " <>
    "task.description = \"#{description}\", " <>
    "task.updated = timestamp() " <>
    "RETURN task"
  end

  @doc """
  Generates a create statement from a given Task.

      iex> LooksLikeANailBackend.Task.get_create_statement(%{title: "Foo"})
      "CREATE (task:Task {title: "Foo"}) SET task.id = id(task) RETURN task"
  """
  def get_create_statement(map) do
    task = map
      |> Enum.map(fn({k,v})-> 
          "#{convert_key(k)}: #{convert_value(v)}" end)
      |> Enum.join(", ")
    "CREATE (task:Task {#{task}}) " <>
    "SET task.id = id(task) " <>
    "task.updated = timestamp(), task.created = timestamp() " <>
    "RETURN task"
  end

  defp convert_key(key), do: to_string key
  defp convert_value(value) when is_integer(value), do: value
  defp convert_value(value), do: "\"#{to_string value}\""
    
end
