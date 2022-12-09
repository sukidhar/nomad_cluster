import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :nomad_cluster, NomadClusterWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "N1CDAo3jKpdvSxqKVAqFwAjzQWuKbaa4Dbah7Yajki19iN3PqM3dJf2Tt0f3yUV6",
  server: false

# In test we don't send emails.
config :nomad_cluster, NomadCluster.Mailer,
  adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
