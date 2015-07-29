defmodule LooksLikeANailBackend.Supports do

  defstruct(id: nil,
    feature: nil,
    tool: nil,
    created: "",
    updated: "")

  @required_fields ~w(id tool)
  @optional_fields ~w(feature)

end