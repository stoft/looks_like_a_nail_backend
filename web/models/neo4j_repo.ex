defmodule Neo4J.Repo do

  def all!(type) do
    statement = apply(type, :get_all_statement, [])
    IO.inspect data = do_cypher_statements!([statement])
    IO.inspect apply(type, :extract_type, [data])
  end

  def get!(type, id) do
    statement = apply(type, :get_get_statement, [id])
    data = do_cypher_statements!([statement])
    apply(type, :extract_type, [data])
  end
  
  def create_node!(type, node) do
    statement = apply(type, :get_create_statement, [node])
    data = do_cypher_statements!([statement])
    apply(type, :extract_type, [data])
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
end
