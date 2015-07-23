defmodule LooksLikeANailBackend.Feature do
  
  defstruct(id: nil,
    title: nil,
    subTitle: "",
    keywords: [],
    description: "",
    created: "",
    updated: "")

  @required_fields ~w(id title)
  @optional_fields ~w(subTitle keywords description)

  def get_all_statement() do
    "MATCH (feature:Feature) RETURN feature"
  end

  def get_get_statement(id) do
    "MATCH (feature:Feature {id: #{id}}) RETURN feature"
  end

  def get_delete_statement(id) do
    "MATCH (feature:Feature) WHERE feature.id = #{id} DELETE feature"
  end

  def get_update_statement(feature) do
    id = Map.get(feature, "id")
    title = Map.get(feature, "title")
    subTitle = Map.get(feature, "subTitle")
    description = Map.get(feature, "description")
    keywords = Map.get(feature, "keywords")
    "MATCH (feature:Feature {id: #{id}}) " <>
    "SET feature.title = \"#{title}\", " <>
    "feature.subTitle = \"#{subTitle}\", " <>
    "feature.description = \"#{description}\", " <>
    "feature.updated = timestamp() " <>
    "RETURN feature"
  end

  @doc """
  Generates a create statement from a given Feature.

      iex> LooksLikeANailBackend.Feature.get_create_statement(%{title: "Foo"})
      "CREATE (feature:Feature {title: "Foo"}) SET feature.id = id(feature) RETURN feature"
  """
  def get_create_statement(map) do
    # tool_id = Map.get(map, "toolId")
    # task_id = Map.get(map, "taskId")
    # "MATCH (tool:Tool {id: #{tool_id}}), (task:Task {id: #{task_id}}) CREATE path =(tool)-[:IMPLEMENTS]->(feature:Feature {#{feature}})-[:IS_CAPABLE_OF]->(task) SET feature.id = id(feature) RETURN path"

    feature = map
      |> Enum.map(fn({k,v})-> 
          "#{convert_key(k)}: #{convert_value(v)}" end)
      |> Enum.join(", ")
    "CREATE (feature:Feature {#{feature}}) " <>
    "SET feature.id = id(feature), " <>
    "feature.updated = timestamp(), feature.created = timestamp() " <>
    "RETURN feature"
  end

  defp convert_key(key), do: to_string key
  defp convert_value(value) when is_integer(value), do: value
  defp convert_value(value), do: "\"#{to_string value}\""

end