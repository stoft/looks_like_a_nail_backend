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

  @all "MATCH (tools:Tool) RETURN tools"
  @get ""

  def get_all_statement() do
    @all
  end
  
end