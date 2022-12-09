job "consul" {
    datacenters = ["dc1"]

    group "consul" {
        count = 1
        task "consul" {
            driver = "raw_exec"

            config {
                command = "consul"
                args = ["agent", "-dev"]
            }
        }
    }
}