defmodule LooksLikeANailBackend.SupportsView do
  use LooksLikeANailBackend.Web, :view

  def render("new.json", %{supports: supports}) do
    %{supports: supports}
  end

  def render("supports.json", %{supports: supports}) do
    %{supports: supports}
  end
end
