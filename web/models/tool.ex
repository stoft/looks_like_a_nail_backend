defmodule LooksLikeANailBackend.Tool do

  defstruct(id: nil,
    title: nil,
    subTitle: "",
    keywords: [],
    description: "",
    inserted: "",
    updated: "")
    # features: [])

  @required_fields ~w(id title)
  @optional_fields ~w(subTitle keywords description)

  # def validate(tool) do
  #   errors = []
  #   for field <- @required_fields, do:
  #     if(Map.get(tool, field) == nil), do: errors = errors ++ {ValidationError, "Field #{field} must not be nil."}
  #   errors
  # end

  def get_all_statement() do
    "MATCH (tool:Tool) RETURN tool"
  end

  def get_get_statement(id) do
    "MATCH (tool:Tool {id: #{id}}) RETURN tool"
  end

  def get_delete_statement(id) do
    "MATCH (tool:Tool) WHERE tool.id = #{id} DELETE tool"
  end

  def get_update_statement(tool) do
    id = Map.get(tool, "id")
    title = Map.get(tool, "title")
    subTitle = Map.get(tool, "subTitle")
    description = Map.get(tool, "description")
    keywords = Map.get(tool, "keywords")
    "MATCH (tool:Tool {id: #{id}}) " <>
    "SET tool.title = \"#{title}\", " <>
    "tool.subTitle = \"#{subTitle}\", " <>
    "tool.description = \"#{description}\", " <>
    "tool.updated = timestamp() " <>
    "RETURN tool"
  end

  @doc """
  Generates a create statement from a given Tool.

      iex> LooksLikeANailBackend.Tool.get_create_statement(%{title: "Foo"})
      "CREATE (tool:Tool {title: "Foo"}) SET tool.id = id(tool) RETURN tool"
  """
  def get_create_statement(map) do
    tool = map
      |> Enum.map(fn({k,v})-> 
          "#{convert_key(k)}: #{convert_value(v)}" end)
      |> Enum.join(", ")
    "CREATE (tool:Tool {#{tool}}) " <>
    "SET tool.id = id(tool), " <>
    "tool.updated = timestamp(), tool.created = timestamp() " <>
    "RETURN tool"
  end

  defp convert_key(key), do: to_string key
  defp convert_value(value) when is_integer(value), do: value
  defp convert_value(value), do: "\"#{to_string value}\""
    
end
