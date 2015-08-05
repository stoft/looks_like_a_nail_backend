defmodule LooksLikeANailBackend.CapabilityViewTest do
  use LooksLikeANailBackend.ConnCase, async: true

  import Phoenix.View

  test "render any other" do
    capability = %{capability: %{id: 1,
      title: "Testing",
      subTitle: "",
      description: "The act of verifying whether something is or not.",
      updated: "2015-07-16T15:46:53.023+0000",
      created: "2015-07-16T15:46:53.023+0000",
      keywords: ["quality assurance"]}}
    assert render_to_string(LooksLikeANailBackend.CapabilityView, "capability.json", capability) ==
           Poison.encode! capability
  end
end
