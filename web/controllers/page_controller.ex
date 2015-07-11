defmodule LooksLikeANailBackend.PageController do
  use LooksLikeANailBackend.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
