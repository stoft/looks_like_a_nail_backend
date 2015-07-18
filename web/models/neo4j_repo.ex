defmodule Neo4J.Repo do
  require Logger

  alias LooksLikeANailBackend.Utils

  defmodule Neo4JError do
    defexception [:message]
    
    def exception(value) do
      msg = "Neo4J returned error: #{inspect value}"
      %Neo4JError{message: msg}
    end
  end

  def all!(type) do
    statement = apply(type, :get_all_statement, [])
    data = do_cypher_statements!([statement])
    convert_to_type(data, type)
    # apply(type, :extract_type, [data])
  end

  def get!(type, id) do
    statement = apply(type, :get_get_statement, [id])
    data = do_cypher_statements!([statement])
    convert_to_type(data, type)
    # apply(type, :extract_type, [data])
  end
  
  def create_node!(type, node) do
    statement = apply(type, :get_create_statement, [node])
    data = do_cypher_statements!([statement])
    convert_to_type(data, type)
    # apply(type, :extract_type, [data])
  end

  def delete!(type, node) do
    statement = apply(type, :get_delete_statement, [node])
    IO.inspect data = do_cypher_statements!([statement])
    %{}
  end

  def update!(type, node) do
    statement = apply(type, :get_update_statement, [node])
    data = do_cypher_statements!([statement])
    convert_to_type data, type
  end

  defp do_cypher_statements!(statements) do
    url = compose_url(["transaction/commit"])
    json = Poison.encode!(embed_statements(statements))
    headers = %{"Content-Type" => "application/json"}
    Logger.info "Request to Neo4J: " <> String.slice(json,0,1000)
    response = HTTPoison.post!(url, json, headers, [hackney: get_basic_auth_info])
    json_body = Map.get(response, :body)
    Logger.info "Response from Neo4J" <> String.slice(json_body, 0, 1000)
    body = json_body |> Poison.decode!
    if(Map.get(body, "errors") != []) do
      raise Neo4JError, Map.get(body, "errors")
    end
    body
  end

  defp embed_statements(statements) do
    list = for statement <- statements, do: %{statement: statement}
    %{statements: list}
  end

  defp get_basic_auth_info() do
    config = Application.get_env(:looks_like_a_nail_backend, LooksLikeANailBackend.Neo4J)
    [basic_auth: {config[:username], config[:password]}]
  end

  defp compose_url(list) do
    Enum.join ["http://", get_host, ":", get_port, "/db/data/"] ++ list
  end

  defp get_host() do
    config = Application.get_env(:looks_like_a_nail_backend, LooksLikeANailBackend.Neo4J)
    config[:host]
  end

  defp get_port() do
    config = Application.get_env(:looks_like_a_nail_backend, LooksLikeANailBackend.Neo4J)
    config[:port]
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
    return_single_or_list(data_list)
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

  defp return_single_or_list([h|[]]), do: h
  defp return_single_or_list([h|tail]), do: [h] ++ tail
  defp return_single_or_list([]), do: nil
end
