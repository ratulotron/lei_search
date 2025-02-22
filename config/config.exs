import Config

config :lei_search, LeiSearchEngine.Repo,
  database: "lei_db",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :lei_search, :gleif, snapshot_url: "https://leidata.gleif.org/api/v2/golden-copies"

config :logger, :console, metadata: [:request_id]
