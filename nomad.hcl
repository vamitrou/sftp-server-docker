job "sftp-server" {
  datacenters = ["dc1"]
    task "sftp-server" {
      driver = "raw_exec"

      artifact {
        source = "https://raw.githubusercontent.com/FRosner/nomad-docker-wrapper/1.0.0/nomad-docker-wrapper"
      }

      env {
        NOMAD_DOCKER_CONTAINER_NAME = "${NOMAD_JOB_NAME}"
      }

      config {
        command = "nomad-docker-wrapper"
        args = ["-p", "8022:22", 
                "-v", "/oe/azfr/_ssh:/root/.ssh", 
                "-v", "/oe/azfr/_landing:/sftp/sftp-user/data",
                "vamitrou/sftp-server"]
      }

      resources {
        cpu = 500
        memory = 128
        network {
            mbits = 1000
            port "sftp" {
                static = 8022    
            }
        }
      }
    }
  }
