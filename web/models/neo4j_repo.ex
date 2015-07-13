defmodule Neo4J.Repo do

  def all!(type) do
    statement = apply(type, :get_all_statement, [])
    response = do_cypher_statements!([statement])
  end

  # def all!(type, query) do
    
  # end

  defp do_cypher_statements!(statements) do
    url = compose_url(["transaction/commit"])
    json = Poison.encode!(embed_statements(statements))
    IO.inspect response = HTTPoison.post!(url, json, [], [hackney: get_basic_auth_info])
    list = response
      |> Map.get(:body)
      # |> Poison.decode!
      # |> Enum.map(&convert_neo4j_to_ecto(type, &1))
    list
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
end