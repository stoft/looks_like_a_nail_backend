defmodule LooksLikeANailBackend.FeatureView do
  use LooksLikeANailBackend.Web, :view

  def render("index.json", %{features: features}) do
    # %{data: render_many(features, "tool.json")}
    %{features: features}
  end

  def render("show.json", %{feature: feature}) do
    # %{data: render_one(feature, "feature.json")}
    %{feature: feature}
  end

  def render("new.json", %{feature: feature}) do
    %{feature: feature}
  end

  def render("feature.json", %{feature: feature}) do
    %{feature: feature}
  end
end
