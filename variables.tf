variable "instance_count" {
  type    = number
  default = 0
}

variable "environment_id" {
  type = string
}

variable "instances" {
  type = list(object({
    hostname    = string
    agent_ip    = string
    host_labels = map(string)
    connection  = any
  }))
}

# Workaround to create explicit dependencies
variable "deps_on" {
  type    = list(string)
  default = []
}
