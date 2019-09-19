import Config

config :logger, level: :warn

config :pghr,
  ecto_repos: [Pghr.Repo],
  namespce: Pghr

config :pghr, Pghr.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "pghr",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"
