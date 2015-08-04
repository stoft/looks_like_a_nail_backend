defmodule LooksLikeANailBackend.FeatureController do
  use LooksLikeANailBackend.Web, :controller

  alias LooksLikeANailBackend.Feature

  # def index(conn, _params) do
  #   features = Neo4J.Repo.all!(Feature)
  #   if(features != nil) do
  #     render conn, :index, features: features
  #   else
  #     render conn, :index, features: []
  #   end
  # end

  # def show(conn, %{"id" => id}) do
  #   id = String.to_integer(id)
  #   feature = Neo4J.Repo.get!(Feature, id)
  #   if(feature != nil) do
  #     render conn, :show, feature: feature
  #   else
  #     conn
  #     |> put_status(:not_found)
  #     |> render(LooksLikeANailBackend.ErrorView, "404.json")
  #   end
  # end
  
  def create(conn, %{"feature" => feature}) do
    feature = Neo4J.Repo.create!(Feature, feature)
    render(conn, :new, feature: feature)

    # if changeset.valid? do
    #   # Repo.insert!(changeset)
    #   Neo4jConnector.insert!(changeset)
    #
    #   conn
    #   |> put_flash(:info, "Article created successfully.")
    #   |> redirect(to: article_path(conn, :index))
    # else
    #   render(conn, :new, changeset: changeset)
    # end
  end

  def update(conn, %{"id" => id, "feature" => feature_params}) do
    id = (is_integer(id) && id || String.to_integer(id))
    feature = Neo4J.Repo.get!(Feature, id)
    if(feature != nil) do
      feature_params = Map.put(feature_params, "id", id)
      feature = Neo4J.Repo.update!(Feature, feature_params)
      render conn, :show, feature: feature
    else
      conn
      |> put_status(:not_found)
      |> render(LooksLikeANailBackend.ErrorView, "404.json")
    end
    # comment = Repo.get!(Comment, id)
    # changeset = Comment.changeset(comment, comment_params)
    #
    # if changeset.valid? do
    #   comment = Repo.update!(changeset)
    #   render(conn, :show, comment: comment)
    # else
    #   conn
    #   |> put_status(:unprocessable_entity)
    #   |> render(NeepBlogBackend.ChangesetView, :error, changeset: changeset)
    # end
  end

  def delete(conn, %{"id" => id}) do
    id = (is_integer(id) && id || String.to_integer(id))
    feature = Neo4J.Repo.get!(Feature, id)
    if(feature != nil) do
      Neo4J.Repo.delete!(Feature, id)
      render(conn, :new, feature: %{})
    else
      conn
      |> put_status(:not_found)
      |> render LooksLikeANailBackend.ErrorView, "404.json"
    end
    # conn
    # |> put_status(:not_found)
    # |> render(LooksLikeANailBackend.ErrorView, "404.html")
  # comment = Repo.get!(Comment, id)
  #
  # comment = Repo.delete!(comment)
  # render(conn, :show, comment: comment)
  end
  

end
