provider "rancher" {
  skip_config_validation = var.instance_count > 0 ? false : true
}
