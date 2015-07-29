defmodule LooksLikeANailBackend.Mapper do
  alias LooksLikeANailBackend.Feature
  alias LooksLikeANailBackend.Tool
  alias LooksLikeANailBackend.Task
  alias LooksLikeANailBackend.Implements
  alias LooksLikeANailBackend.IsCapableOf

  @types %{ "Feature" => :feature,
            "Tool" => :tool,
            "Task" => :task,
            "IMPLEMENTS" => :implements,
            "IS_CAPABLE_OF" => :isCapableOf,
            "SUPPORTS" => :supports,
            "otherTool" => :otherTool}

  @nodes [:feature, :tool, :task, :otherTool]
  @relationships [:implements, :isCapableOf, :supports]

  # @properties [:endNode, :properties, :startNode, :type]
  
  # @spec map_from_neo(%{}, atom) :: %{}
  # def map_from_neo(%{"results" => data}, :get) do
  #   data = data |> hd |> Dict.get("data")
  #   mapped_graphs = for graph <- data, do: map_graph(graph)
  #   unify_graphs(mapped_graphs, :get)
  # end

  # def map_from_neo(data, :all) do
    
  # end

  # @spec map_graph(%{}) :: [...]
  # def map_graph(graph) do
  #   relationships = for rel <- graph["relationships"] do
  #     [type] = for String.capitalize(label) <- rel["type"],
  #       Enum.member?(@types, label), do: label
  #     map_entity(to_atom(type), rel)
  #   end

  #   nodes = for node <- graph["nodes"] do
  #     [type] = for label <- node["labels"], Enum.member?(@types, label), do: label
  #     map_entity(to_atom(type), node, relationships)
  #   end
  # end

  # @spec unify_graphs([...], atom) :: %{}
  # def unify_graphs(graphs, :get) do
  #   Enum.reduce(@types, %{}, fn(type, acc) ->
  #     list = for entity <- graphs[type], do: entity
  #     list = Enum.uniq(list)
  #     case Enum.count(list) do
  #       1 -> Dict.put(acc, map_name(type, false), hd(list))
  #       _ -> Dict.put(acc, map_name(type, true), list)
  #   end)
  # end

  # @spec map_name(String.t, boolean) :: String.t
  # defp map_name(name, false), do: String.downcase(name)
  # defp map_name(name, true) do
  #   name = String.downcase(name)
  #   case String.ends_with?(name, "s") do
  #     true -> name
  #     false -> name <> "s"
  #   end
  # end

  def map_single_entity(Tool, rows, columns) do
    rows = for row <- rows, do: map_one_row(Tool, row, columns)
    tool = %{tool: [], implements: [], features: [], isCapableOf: [], tasks: [], supports: [], tools: []}

    tool = Enum.reduce(rows, tool, fn(row, acc)->
      get_and_put = fn(acc, row, put_key, get_key) ->
        put_in(acc, [put_key], ([get_in(row, [get_key])] ++ get_in(acc, [put_key]) |> Enum.uniq))
      end
      acc = get_and_put.(acc, row, :tool, :tool)
      acc = get_and_put.(acc, row, :implements, :implements)
      acc = get_and_put.(acc, row, :features, :feature)
      acc = get_and_put.(acc, row, :isCapableOf, :isCapableOf)
      acc = get_and_put.(acc, row, :tasks, :task)
      acc = get_and_put.(acc, row, :supports, :supports)
      acc = get_and_put.(acc, row, :tools, :otherTool)
    end)

    tool = tool |> put_in([:tool], unify_entity(tool[:tool], [:implements]))
      |> put_in([:features], unify_entity(tool[:features], [:isCapableOf, :supports]))
      |> put_in([:tool], hd(get_in(tool,[:tool])))
  end
  
  def unify_entity(entities, fields) do
    entity_map = Enum.reduce(fields, %{}, fn(field, acc) ->
      Enum.reduce(entities, acc, fn(entity, acc) ->
        update_entity(acc, entity, field)
      end)
    end)
    for {_id, entity} <- entity_map, do: entity
  end

  defp update_entity(entities, entity, field) do
    if Dict.has_key?(entities, entity[:id]) do
      update_in(entities, [entity[:id], field], &(&1 ++ get_in(entity,[field])|> Enum.uniq))
    else
      put_in(entities, [entity[:id]], entity)
    end
    # IO.inspect entities
  end

  def map_one_row(Tool, %{"row" => row}, columns) do
    columns = for c <- columns, do: String.to_existing_atom(c)

    row = convert_keys_to_atoms row
    
    nodes = for index <- 0..(Enum.count(columns)-1),
      Enum.member?(@nodes, Enum.at(columns, index)) do
        map_entity(Enum.at(columns, index), Enum.at(row, index))
    end
    nodes = for node <- nodes, node != nil, do: node

    relationships = for index <- 0..(Enum.count(columns)-1),
      Enum.member?(@relationships, Enum.at(columns, index)) do
        map_entity(Enum.at(columns, index), Enum.at(row, index))
    end
    relationships = for rel <- relationships, rel != nil, do: rel

    map = (nodes ++ relationships)
      |> Enum.reduce(%{}, &Enum.into(&2, &1))

    if implements_id = get_in(map, [:implements, :id]) do
      map = put_in map, [:tool, :implements], [implements_id]
      map = put_in map, [:implements, :tool], get_in(map, [:tool, :id])
      map = put_in map, [:implements, :feature], get_in(map, [:feature, :id])
      if is_capable_of_id = get_in(map, [:isCapableOf, :id]) do
        map = put_in map, [:feature, :isCapableOf], [is_capable_of_id]
        map = put_in map, [:isCapableOf, :feature], get_in(map, [:feature, :id])
        map = put_in map, [:isCapableOf, :task], get_in(map, [:task, :id])
      end
      if supports_id = get_in(map, [:supports, :id]) do
        map = put_in map, [:feature, :supports], [supports_id]
        map = put_in map, [:supports, :feature], get_in(map, [:feature, :id])
        map = put_in map, [:supports, :tool], get_in(map, [:otherTool, :id])
      else
        map = put_in(map, [:feature, :supports], [])
      end

    else
      map = put_in map, [:tool, :implements], []
    end
    map
  end
  
  @spec map_entity(atom, %{}) :: %{}
  def map_entity(_type, nil), do: nil

  def map_entity(type, entity) do
    put_in %{}, [type], entity
  end

  defp convert_keys_to_atoms(map) when is_map(map) do
    Enum.reduce(map, %{}, fn({k,v}, m) ->
      v = convert_keys_to_atoms(v)
      cond do
        is_atom(k) -> put_in(m, [k], v)
        true -> put_in(m, [String.to_atom(k)], v)
      end
    end)
  end

  defp convert_keys_to_atoms(list) when is_list(list) do
    for item <- list, do: convert_keys_to_atoms item
  end

  defp convert_keys_to_atoms(simple_value), do: simple_value
  
end