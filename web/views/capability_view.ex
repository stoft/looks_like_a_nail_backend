defmodule LooksLikeANailBackend.CapabilityView do
  use LooksLikeANailBackend.Web, :view

  def render("index.json", %{capabilities: capabilities}) do
    # %{data: render_many(capabilities, "capability.json")}
    %{capabilities: capabilities}
  end

  def render("show.json", %{capability: capability}) do
    # %{data: render_one(capability, "capability.json")}
    %{capability: capability}
  end

  def render("new.json", %{capability: capability}) do
    %{capability: capability}
  end

  def render("capability.json", %{capability: capability}) do
    # %{id: capability.id}
    %{capability: capability}
  end
end
