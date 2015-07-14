defmodule LooksLikeANailBackend.ToolView do
  use LooksLikeANailBackend.Web, :view

  def render("index.json", %{tools: tools}) do
    # %{data: render_many(tools, "tool.json")}
    %{tools: tools}
  end

  def render("show.json", %{tool: tool}) do
    # %{data: render_one(tool, "tool.json")}
    %{tool: tool}
  end

  def render("tool.json", %{tool: tool}) do
    %{id: tool.id}
  end

end
