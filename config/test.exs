use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :top5_2, Top52Web.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :top5_2, Top52.Repo,
  username: "postgres",
  password: "zsawq21q",
  database: "top5_2_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
