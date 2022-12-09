# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

# Configures the endpoint
config :nomad_cluster, NomadClusterWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: NomadClusterWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: NomadCluster.PubSub,
  live_view: [signing_salt: "lR3lA8Qe"]

config :libcluster,
  topologies: [
    consul_example: [
      strategy: Cluster.Strategy.Consul,
      config: [
        # The base agent URL.
        base_url: "http://172.16.1.101:8500",

        # Nodes list will be refreshed using Consul on each interval (in µs).
        # Defaults to 5 seconds.
        polling_interval: 10_000,

        # The Consul endpoints used to fetch service nodes.
        list_using: [
          # If you want to use the Agent HTTP API as specified in
          # https://www.consul.io/api/agent.html
          # Cluster.Strategy.Consul.Agent

          # If you want to use the Health HTTP Endpoint as specified in
          # https://www.consul.io/api/health.html
          # {Cluster.Strategy.Consul.Health, [passing: true]},

          # If you want to use the Catalog HTTP API as specified in
          # https://www.consul.io/api/catalog.html
          Cluster.Strategy.Consul.Catalog

          # # If you want to join nodes from multiple datacenters, do:
          # {Cluster.Strategy.Consul.Multisite, [
          #   datacenters: ["dc1", "dc2", "dc3", ...],
          #   endpoints: [
          #     ... further endpoints ...
          #   ]
          # ]},

          # # You can also list all datacenters:
          # {Cluster.Strategy.Consul.Multisite, [
          #   datacenters: :all,
          #   endpoints: [
          #     ... further endpoints ...
          #   ]
          # ]},
        ],

        # All configurations below are defined as default for all
        # children endpoints.

        # Datacenter parameter while querying.
        dc: "toronto",

        # The default service_name for children endpoints specifications.
        service_name: "ex-app",

        # This is the node basename, the Name (first) part of an Erlang
        # node name (before the @ part. If not specified, it will assume
        # the same name as the current running node.
        node_basename: "ex_app"
      ]
    ]
  ]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :nomad_cluster, NomadCluster.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.0",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
