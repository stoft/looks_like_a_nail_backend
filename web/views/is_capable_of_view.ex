defmodule LooksLikeANailBackend.IsCapableOfView do
  use LooksLikeANailBackend.Web, :view

  def render("new.json", %{isCapableOf: isCapableOf}) do
    %{isCapableOf: isCapableOf}
  end

  def render("isCapableOf.json", %{isCapableOf: isCapableOf}) do
    %{isCapableOf: isCapableOf}
  end
end
