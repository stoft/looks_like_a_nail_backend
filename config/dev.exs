use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :looks_like_a_nail_backend, LooksLikeANailBackend.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  cache_static_lookup: false,
  watchers: [node: ["node_modules/brunch/bin/brunch", "watch"]]

# Watch static and templates for browser reloading.
config :looks_like_a_nail_backend, LooksLikeANailBackend.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Configure your database
config :looks_like_a_nail_backend, LooksLikeANailBackend.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "looks_like_a_nail_backend_dev",
  size: 10 # The amount of database connections in the pool

config :looks_like_a_nail_backend, LooksLikeANailBackend.Neo4J,
  host: "192.168.99.100", #"localhost", #"192.168.99.100",
  port: 32770,
  username: "neo4j",
  password: "admin"
