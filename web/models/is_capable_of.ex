defmodule LooksLikeANailBackend.IsCapableOf do

  defstruct(id: nil,
    feature: nil,
    task: nil,
    created: "",
    updated: "")

  @required_fields ~w(id task)
  @optional_fields ~w(feature)

end