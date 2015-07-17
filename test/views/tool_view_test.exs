defmodule LooksLikeANailBackend.ToolViewTest do
  use LooksLikeANailBackend.ConnCase, async: true

  import Phoenix.View

  test "render any other" do
    tool = %{tool: %{id: 1,
      title: "Elixir",
      subTitle: "Programming Language",
      description: "A functional programming language " <>
        "standing on the shoulders of giants.",
      updated: "2015-07-16T15:46:53.023+0000",
      created: "2015-07-16T15:46:53.023+0000",
      keywords: ["funcationl", "programming", "erlang"],
      features: [1,2,3]}}
    assert render_to_string(LooksLikeANailBackend.ToolView, "tool.json", tool) ==
           Poison.encode! tool
  end
end
