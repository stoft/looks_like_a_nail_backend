defmodule LooksLikeANailBackend.ImplementsView do
  use LooksLikeANailBackend.Web, :view

  def render("new.json", %{implements: implements}) do
    %{implements: implements}
  end

  def render("implements.json", %{implements: implements}) do
    %{implements: implements}
  end
end
