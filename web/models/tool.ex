defmodule LooksLikeANailBackend.Tool do

  defstruct(id: nil,
    title: nil,
    subTitle: "",
    keywords: [],
    description: "",
    features: [],
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
    # MATCH (tool:Tool) WHERE tool.id = #{id} OPTIONAL MATCH (tool)-[implements:IMPLEMENTS]->(feature:Feature)-[isCapableOf:IS_CAPABLE_OF]->(task),(feature)-[supports:SUPPORTS]->(otherTool:Tool) RETURN tool, implements, feature, isCapableOf, task, supports, otherTool
    "MATCH (tool:Tool) WHERE tool.id = #{id} RETURN tool"
  end

  @spec map_get_from_neo(%{}) :: %{}
  def map_get_from_neo(%{"data" => response}) do
    rows = for item <- response, Map.has_key?(item, "row"), do: item
    tool = for row <- rows, do: map_row_from_neo(row, %{})

  end

  @spec map_row_from_neo(%{}, %{}) :: %{}
  def map_row_from_neo(%{"row" => row}, acc) do
    import Map, only: [put: 3]

    task = Enum.at(row, 4)
    feature = Enum.at(row, 2) |> put("isCapableOf", [task["id"]])
    tool = Enum.at(row, 0) |> put("implements", [feature["id"]])
    capability = Enum.at(row, 3) |> put("feature", feature["id"]) |> put("task", task["id"])
    implementation = Enum.at(row, 1) |> put("tool", tool["id"]) |> put("feature", feature["id"])
    %{"tool" => tool,
      "implements" => [implementation],
      "features" => [feature],
      "isCapableOf" => [capability],
      "tasks" => [task]}
  end
  

  # def parse_rows(list, :get) do
  #   rows = for %{"row" => row} <- list, do: row
  #   tool = rows |> hd |> hd
  #   features = for row <- rows, do: Enum.at(row, 1)
  #   tasks = for row <- rows, do: Enum.at(row, 2)
  #   tool = Dict.put(tool, "features",
  #     for f <- features, do: f["id"])
  #   features = for f <- features, t <- tasks,
  #     do: Dict.put(f, "task", t["id"])
  # end
  

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
