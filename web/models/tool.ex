defmodule LooksLikeANailBackend.Tool do

  defstruct(id: nil,
    title: nil,
    subTitle: "",
    keywords: [], # has_many
    description: "",
    implements: [], # has_many
    supports: [], # has_many
    inserted: "",
    updated: "")
    # features: [])

  @required_fields ~w(id title)
  @optional_fields ~w(subTitle keywords description features)

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
    "MATCH (tool:Tool) WHERE tool.id = #{id} OPTIONAL MATCH (tool)-[implements:IMPLEMENTS]->(feature:Feature)-[isCapableOf:IS_CAPABLE_OF]->(task) RETURN tool, implements, feature, isCapableOf, task"
    # "MATCH (tool:Tool) WHERE tool.id = #{id} RETURN tool"
  end

  @spec map_get_from_neo(%{}) :: %{}
  def map_get_from_neo(%{"data" => response}) do
    import Map, only: [put: 3, get: 2]
    rows = for item <- response, Map.has_key?(item, "row"), do: item
    tool_rows = for row <- rows, do: map_row_from_neo(row)
    unify_tool(tool_rows)
  end

  defp unify_tool([tool|tools]) do
    import Map, only: [put: 3, get: 2]
    # IO.inspect tool
    tool = Enum.reduce(tools, tool, fn(next, tool)->
      tool = update_in(tool, [:tool, :implements],
        &((&1 ++ get_in(next, [:tool, :implements])) |> Enum.uniq))
      tool = update_in(tool, [:implements],
        &((&1 ++ get_in(next, [:implements]))|> Enum.uniq))
      tool = update_in(tool, [:features],
        &((&1 ++ get_in(next, [:features]))|> Enum.uniq))
      tool = update_in(tool, [:isCapableOf],
        &((&1 ++ get_in(next, [:isCapableOf]))|>Enum.uniq))
      tool = update_in(tool, [:tasks],
        &((&1 ++ get_in(next, [:tasks]))|> Enum.uniq))
    end)
  end

  @spec map_row_from_neo(%{}) :: %{}
  def map_row_from_neo(%{"row" => row}) do
    import Map, only: [put: 3]

    task = Enum.at(row, 4) |> convert_keys_to_atoms
    feature = Enum.at(row, 2) |> convert_keys_to_atoms
      |> put(:isCapableOf, [task[:id]])

    tool = Enum.at(row, 0) |> convert_keys_to_atoms
      |> put(:implements, [feature[:id]])
    
    capability = Enum.at(row, 3) |> convert_keys_to_atoms
      |> put(:feature, feature[:id]) |> put(:task, task[:id])
    
    implementation = Enum.at(row, 1) |> convert_keys_to_atoms
      |> put(:tool, tool[:id]) |> put(:feature, feature[:id])

    %{:tool => convert_keys_to_atoms(tool),
      :implements => [implementation],
      :features => [feature],
      :isCapableOf => [capability],
      :tasks => [task]}
  end

  defp convert_keys_to_atoms(simple_map) do
    Enum.reduce(simple_map, %{}, fn({k,v}, m) ->
      cond do
        is_atom(k) -> put_in(m, [k], v)
        true -> put_in(m, [String.to_atom(k)], v)
      end
    end)
  end
  
  def get_delete_statement(id) do
    "MATCH (t:Tool) WHERE t.id = #{id} \
      OPTIONAL MATCH (t)-[r:IMPLEMENTS]->(f:Feature)-[r2:IS_CAPABLE_OF]->() \
      DELETE t, r, f, r2"
  end

  def get_update_statement(tool) do
    id = Map.get(tool, "id")
    title = Map.get(tool, "title")
    subTitle = Map.get(tool, "subTitle")
    description = Map.get(tool, "description")
    keywords = Map.get(tool, "keywords")
    "MATCH (tool:Tool {id: #{id}}) \
    SET tool.title = \"#{title}\", \
      tool.subTitle = \"#{subTitle}\", \
      tool.description = \"#{description}\", \
      tool.updated = timestamp() \
    RETURN tool"
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

  defp convert_key(key) when is_atom(key), do: to_string key
  defp convert_key(key), do: String.to_atom key
  defp convert_value(value) when is_integer(value), do: value
  defp convert_value(value), do: "\"#{to_string value}\""
    
end
