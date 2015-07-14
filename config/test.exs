use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :looks_like_a_nail_backend, LooksLikeANailBackend.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :looks_like_a_nail_backend, LooksLikeANailBackend.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "looks_like_a_nail_backend_test",
  pool: Ecto.Adapters.SQL.Sandbox, # Use a sandbox for transactional testing
  size: 1

config :looks_like_a_nail_backend, LooksLikeANailBackend.Neo4J,
  host: "192.168.99.100", #"localhost", #"192.168.99.100",
  port: 32770,
  username: "neo4j",
  password: "admin"
