defmodule LooksLikeANailBackend.Endpoint do
  use Phoenix.Endpoint, otp_app: :looks_like_a_nail_backend

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phoenix.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/", from: :looks_like_a_nail_backend, gzip: false,
    only: ~w(css images js favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  plug Plug.Session,
    store: :cookie,
    key: "_looks_like_a_nail_backend_key",
    signing_salt: "n108GboV"

  plug CORSPlug

  # IO.inspect plug Plug.Conn, :read_body, length: 1000

  plug :router, LooksLikeANailBackend.Router
end
