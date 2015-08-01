defmodule LooksLikeANailBackend.ToolView do
  use LooksLikeANailBackend.Web, :view

  def render("index.json", %{tools: tools}) do
    # %{data: render_many(tools, "tool.json")}
    %{tools: tools}
  end

  def render("show.json", %{tool: tool}) do
    tool
  end

  def render("new.json", %{tool: tool}) do
    %{tool: tool}
  end

  def render("tool.json", %{tool: tool}) do
    %{tool: tool}
  end
end
