defmodule LooksLikeANailBackend.Mapper do

  alias LooksLikeANailBackend.Utils

  alias LooksLikeANailBackend.Tool

  @types %{ "Feature" => :feature,
            "Tool" => :tool,
            "Task" => :task,
            "IMPLEMENTS" => :implements,
            "PROVIDES" => :provides,
            "SUPPORTS" => :supports,
            "otherTool" => :otherTool}

  @datetimes [:updated, :created]

  @nodes [:feature, :tool, :task, :otherTool]
  @relationships [:implements, :provides, :supports]

  def map_all_response(type, data) do
    import Map, only: [get: 2]
    case type do
      # Tool -> map_entities(type, get(data, ["results", "data"]), get_in(data, ["results", "columns"]))
      Tool -> map_entities(type, data |> get("results") |> hd |> get("data"), data |> get("results") |> hd |> get("columns"))
      _ -> convert_to_type(data, type)
    end
  end

  def map_get_response(type, data) do
    import Map, only: [get: 2]
    case type do
      Tool -> map_single_entity(type, data |> get("results") |> hd |> get("data"), data |> get("results") |> hd |> get("columns"))
      _ -> convert_to_type data, type
    end
  end
  
  def map_entities(Tool, rows, columns) do
    tools = %{tools: [], implements: [], features: [], provides: [], tasks: [], supports: []}
    # rows = for row <- rows, do: map_one_row(Tool, row, columns)

    grouped_rows = group_by_id_of_first_column rows
    entities = Enum.map(grouped_rows, fn({k, v}) -> map_single_entity(Tool, v, columns) end)
    tools = Enum.reduce(entities, tools, fn(entity, acc)->
      acc
      |> update_in([:tools], &([entity[:tool]] ++ &1))
      |> update_in([:implements], &(entity[:implements] ++ &1))
      |> update_in([:features], &(entity[:features] ++ &1))
      |> update_in([:provides], &(entity[:provides] ++ &1))
      |> update_in([:tasks], &(entity[:tasks] ++ &1))
      |> update_in([:supports], &(entity[:supports] ++ &1))
    end)
    Enum.reduce(tools, %{}, fn({k, v}, acc)-> put_in acc, [k], Enum.uniq(v) end)
    tools
  end

  def group_by_id_of_first_column(rows) do
    rows
    |> Enum.reduce(%{}, fn(%{"row" => row}, acc)->
      tool_id = get_in(hd(row), ["id"])
      Dict.update(acc, tool_id, [%{"row" => row}], &([%{"row" => row}] ++ &1))
    end)
  end
  
  def map_single_entity(Tool, [], columns), do: nil
  
  def map_single_entity(Tool, rows, columns) do
    rows = for row <- rows, do: map_one_row(Tool, row, columns)
    tool = %{tool: [], implements: [], features: [], provides: [], tasks: [], supports: [], tools: []}

    tool = Enum.reduce(rows, tool, fn(row, acc)->
      get_and_put = fn(acc, row, put_key, get_key) ->
        if(row_val = get_in(row, [get_key]), do: row_val = [row_val], else: row_val = []) 
        Dict.update(acc, put_key, row_val, &((row_val ++ &1) |> Enum.uniq))
        # IO.inspect bar = put_in(acc, [put_key], ([get_in(row, [get_key])] ++ get_in(acc, [put_key]) |> Enum.uniq))
      end
      acc |> get_and_put.(row, :tool, :tool)
      |> get_and_put.(row, :implements, :implements)
      |> get_and_put.(row, :features, :feature)
      |> get_and_put.(row, :provides, :provides)
      |> get_and_put.(row, :tasks, :task)
      |> get_and_put.(row, :supports, :supports)
      |> get_and_put.(row, :tools, :otherTool)
    end)

    tool |> put_in([:tool], unify_entity(tool[:tool], [:implements]))
    |> put_in([:features], unify_entity(tool[:features], [:provides, :supports]))
    |> put_in([:tool], hd(get_in(tool,[:tool])))
  end
  
  def unify_entity(entities, fields) do
    # IO.inspect {entities, fields}
    entity_map = Enum.reduce(fields, %{}, fn(field, acc) ->
      Enum.reduce(entities, acc, fn(entity, acc) ->
        update_entity(acc, entity, field)
      end)
    end)
    for {_id, entity} <- entity_map, do: entity
  end

  defp update_entity(entities, entity, field) do
    # IO.inspect [entities, entity, field]
    if Dict.has_key?(entities, entity[:id]) do
      update_in(entities, [entity[:id], field], &(&1 ++ get_in(entity,[field])|> Enum.uniq))
    else
      put_in(entities, [entity[:id]], entity)
    end
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
      if provides_id = get_in(map, [:provides, :id]) do
        map = put_in map, [:feature, :provides], [provides_id]
        map = put_in map, [:provides, :feature], get_in(map, [:feature, :id])
        map = put_in map, [:provides, :task], get_in(map, [:task, :id])
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

  def convert_to_type(data, type) do
    type_name = get_type_name(type)
    name = fn(%{"columns" => list}) -> hd(list) == type_name end
    data_list = data
      |> Map.get("results")
      |> Enum.filter(&name.(&1))
      |> hd
      |> Map.get("data")
      |> Enum.map(fn(%{"row" => row}) -> convert_fields(hd(row)) end)
    # return_single_or_list(data_list)
  end

  defp get_type_name(type) do
    type |> to_string |> String.split(".")
      |> Enum.reverse |> hd |> String.downcase
  end

  defp convert_fields(map) do
    Enum.reduce(map, %{}, fn(pair,acc) ->
      {k,v} = convert_field(pair)
      Map.put(acc, k, v)
    end)
  end

  defp convert_field({"created", value}) when is_integer(value) do
    {:created, Utils.convert_msecs_to_iso(value)}
  end
  defp convert_field({"updated", value}) when is_integer(value) do
    {:updated, Utils.convert_msecs_to_iso(value)}
  end
  defp convert_field({k,v}) do
    {String.to_atom(k), v}
  end

  defp convert_keys_to_atoms(map) when is_map(map) do
    Enum.reduce(map, %{}, fn({k,v}, m) ->
      v = convert_keys_to_atoms(v)
      unless is_atom(k) do
        k = String.to_atom(k)
      end
      {k, v} = format_datetimes(k,v)
      put_in(m, [k], v)
    end)
  end

  defp convert_keys_to_atoms(list) when is_list(list) do
    for item <- list, do: convert_keys_to_atoms item
  end

  defp convert_keys_to_atoms(simple_value), do: simple_value

  defp format_datetimes(:created, value), do: {:created, Utils.convert_msecs_to_iso(value)}
  defp format_datetimes(:updated, value), do: {:updated, Utils.convert_msecs_to_iso(value)}
  defp format_datetimes(key, value), do: {key, value}


end