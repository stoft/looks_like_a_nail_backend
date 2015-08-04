defmodule LooksLikeANailBackend.ProvidesView do
  use LooksLikeANailBackend.Web, :view

  def render("new.json", %{provides: provides}) do
    %{provides: provides}
  end

  def render("provides.json", %{provides: provides}) do
    %{provides: provides}
  end
end
