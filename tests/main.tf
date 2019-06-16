provider "rancher" {
  api_url = "http://192.168.50.4:8080/v2-beta"
}

module "rancher-host" {
  source = "../"

  environment_id = "1a5"
  instances = [
    {
      hostname = "testing"
      host_labels = {
        foo = "bar"
      }

      connection = {
        host = "192.168.50.4"
        user = "vagrant"
      }
    }
  ]
}
