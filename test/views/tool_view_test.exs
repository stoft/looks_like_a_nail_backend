defmodule LooksLikeANailBackend.ToolViewTest do
  use LooksLikeANailBackend.ConnCase, async: true

  import Phoenix.View

  test "render any other" do
    assert render_to_string(LooksLikeANailBackend.ToolView, "tool.json", []) ==
           "Server internal error"
  end
end
