defmodule LooksLikeANailBackend.ConceptView do
  use LooksLikeANailBackend.Web, :view

  def render("index.json", %{concepts: concepts}) do
    # %{data: render_many(concepts, "concept.json")}
    %{concepts: concepts}
  end

  def render("show.json", %{concept: concept}) do
    # %{data: render_one(concept, "concept.json")}
    %{concept: concept}
  end

  def render("new.json", %{concept: concept}) do
    %{concept: concept}
  end

  def render("concept.json", %{concept: concept}) do
    # %{id: concept.id}
    %{concept: concept}
  end
end
