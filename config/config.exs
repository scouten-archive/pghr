import Config

config :logger, level: :warn

config :pghr,
  ecto_repos: [Pghr.Repo],
  notif_trigger?: true,
  namespce: Pghr

config :pghr, Pghr.Repo,
  database: "pghr",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  pool_size: 40
