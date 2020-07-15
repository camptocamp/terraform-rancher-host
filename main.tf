resource "rancher_registration_token" "this" {
  count = var.instance_count

  name           = ""
  environment_id = var.environment_id
  host_labels    = var.instances[count.index].host_labels

  lifecycle {
    ignore_changes = [name]
  }
}

resource "rancher_host" "this" {
  count = var.instance_count

  name           = ""
  environment_id = var.environment_id
  hostname       = var.instances[count.index].hostname

  labels = var.instances[count.index].host_labels

  depends_on = [
    null_resource.provisioner
  ]
}

resource "null_resource" "provisioner" {
  # Workaround to use explicit dependencies
  count = var.instance_count

  connection {
    type                = lookup(var.instances[count.index].connection, "type", null)
    user                = lookup(var.instances[count.index].connection, "user", "terraform")
    password            = lookup(var.instances[count.index].connection, "password", null)
    host                = lookup(var.instances[count.index].connection, "host", null)
    port                = lookup(var.instances[count.index].connection, "port", 22)
    timeout             = lookup(var.instances[count.index].connection, "timeout", "")
    script_path         = lookup(var.instances[count.index].connection, "script_path", null)
    private_key         = lookup(var.instances[count.index].connection, "private_key", null)
    agent               = lookup(var.instances[count.index].connection, "agent", null)
    agent_identity      = lookup(var.instances[count.index].connection, "agent_identity", null)
    host_key            = lookup(var.instances[count.index].connection, "host_key", null)
    https               = lookup(var.instances[count.index].connection, "https", false)
    insecure            = lookup(var.instances[count.index].connection, "insecure", false)
    use_ntlm            = lookup(var.instances[count.index].connection, "use_ntlm", false)
    cacert              = lookup(var.instances[count.index].connection, "cacert", null)
    bastion_host        = lookup(var.instances[count.index].connection, "bastion_host", null)
    bastion_host_key    = lookup(var.instances[count.index].connection, "bastion_host_key", null)
    bastion_port        = lookup(var.instances[count.index].connection, "bastion_port", 22)
    bastion_user        = lookup(var.instances[count.index].connection, "bastion_user", null)
    bastion_password    = lookup(var.instances[count.index].connection, "bastion_password", null)
    bastion_private_key = lookup(var.instances[count.index].connection, "bastion_private_key", null)
  }

  provisioner "ansible" {
    plays {
      playbook {
        file_path  = "${path.module}/ansible-data/playbooks/rancher-node.yml"
        roles_path = ["${path.module}/ansible-data/roles"]
      }

      groups = ["rancher-node"]
      become = true
      diff   = true

      extra_vars = {
        hostname                   = var.instances[count.index].hostname
        rancher_registration_token = rancher_registration_token.this[count.index].command
        rancher_node_labels = join("&",
          [
            for key, value in var.instances[count.index].host_labels :
            format("%s=%s", key, value)
        ])
        rancher_env_url  = rancher_registration_token.this[count.index].registration_url
        rancher_image    = rancher_registration_token.this[count.index].image
        rancher_agent_ip = var.instances[count.index].agent_ip

        foo = join(" ", var.deps_on)
      }
    }

    ansible_ssh_settings {
      connect_timeout_seconds              = 60
      connection_attempts                  = 60
      insecure_no_strict_host_key_checking = true
    }
  }
}
