defmodule Neo4J.Repo do

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
    #TODO
  end

  def update!(type, node) do
    statement = apply(type, :get_update_statement, [node])
    data = do_cypher_statements!([statement])
    convert_to_type data, type
  end

  # def all!(type, query) do

  # end

  defp do_cypher_statements!(statements) do
    url = compose_url(["transaction/commit"])
    json = Poison.encode!(embed_statements(statements))
    headers = %{"Content-Type" => "application/json"}
    response = HTTPoison.post!(url, json, headers, [hackney: get_basic_auth_info])
    response |> Map.get(:body) |> Poison.decode!
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
    Enum.reduce(map, %{}, fn({k, v},acc) ->
      Map.put(acc, String.to_atom(k), v)
    end)
  end

  defp return_single_or_list([h|[]]), do: h
  defp return_single_or_list([h|tail]), do: [h] ++ tail
  defp return_single_or_list([]), do: nil
end
