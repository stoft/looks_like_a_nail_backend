defmodule LooksLikeANailBackend.SupportsController do
  use LooksLikeANailBackend.Web, :controller

  alias LooksLikeANailBackend.Supports
  alias LooksLikeANailBackend.ConversionHelper

  def create(conn, %{"feature_id" => feature_id, "tool_id" => _, "supports" => supports}) do
    feature_id = ConversionHelper.convert_to_integer(feature_id)
    concept_id = ConversionHelper.convert_to_integer(Dict.get(supports, "concept"))

    properties = %{"feature_id" => feature_id, "concept_id" => concept_id}
    IO.inspect supports = Neo4J.Repo.create!(Supports, properties)
    render(conn, :new, supports: supports)
  end

  def delete(conn, %{"id" => id, "feature_id" => _, "tool_id" => _}) do
    id = ConversionHelper.convert_to_integer(id)
    supports = Neo4J.Repo.get!(Supports, id)
    if supports do
      Neo4J.Repo.delete!(Supports, id)
      render(conn, :new, supports: %{})
    else
      conn
      |> put_status(:not_found)
      |> render(LooksLikeANailBackend.ErrorView, "404.json")
    end
  end

end
