job "nomad-cluster" {
  datacenters = ["toronto"]

  update{
    healthy_deadline = "10m"
    progress_deadline = "15m"
  }

  group "ex-app" {
    count = 3

    network {
      mode = "host"
      port "http" {
        to     = 4000
      }

      port "epmd" {
        to     = 4369
      }

      port "erlang" {
        to     = 9001
      }
    }

    task "elixir-app" {
      driver = "docker"

      config {
        image = "sukidhar/ex-launch:1.0.0"
        ports = ["http", "epmd", "erlang"]
      }

      env {
        SECRET_KEY_BASE = "6KkMSj3/6Yg9wHnp0asxSI9RdlrRVZLIjJn3PyAd/zf9E+Fueu5OPOfwTF3X4xO2"
        PHX_HOST = "${attr.unique.hostname}"
      }


      service {
        name = "ex-app"
        port = "http"
        address_mode = "driver"

        tags = ["elixir", "erl", "wss"]
      }



      service {
        name = "ex-app-epmd"
        port = "epmd"
        address_mode = "driver"

        tags = ["elixir", "erl", "wss"]
      }
    }
  }
}