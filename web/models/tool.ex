defmodule LooksLikeANailBackend.Tool do

  defstruct(id: nil,
    title: nil,
    sub_title: "",
    keywords: [],
    description: "",
    inserted_at: "",
    updated_at: "")

  @required_fields ~w(id title)
  @optional_fields ~w(sub_title keywords description)

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

  @doc """
  Generates a create statement from a given Tool.

      iex> LooksLikeANailBackend.Tool.get_create_statement(%{title: "Foo"})
      "CREATE (tool:Tool {title: "Foo"}) SET tool.id = id(tool) RETURN tool"
  """
  def get_create_statement(map) do
    tool = map
      |> Enum.map(fn({k,v})-> 
          "#{convert_type(k)}: \"#{convert_type(v)}\"" end)
      |> Enum.join(", ")
    "CREATE (tool:Tool {#{tool}}) " <>
    "SET tool.id = id(tool) RETURN tool"
  end

  @doc """
  Expects data in the following format:
      %{"errors" => [],
        "results" => [%{"columns" => ["tool"],
        "data" => [%{"row" => [%{"id" => 0, "title" => "Foo"}]},
        %{"row" => [%{"id" => 1, "title" => "Bar"}]}]}]}

  Outputs data in the following format:
      %{"tools" => [
        %{"row" => [%{"id" => 0, "title" => "Foo"}]},
        %{"row" => [%{"id" => 1, "title" => "Bar"}]}]}
  """
  def extract_type(data) do
    data = data |> Map.get("results") |> hd |> Map.get("data")
    Map.put(%{}, :tools, data)
  end

  defp convert_type(data) when is_integer(data), do: data
  defp convert_type(data), do: to_string data
    
end
