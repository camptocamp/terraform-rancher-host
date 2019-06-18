variable "environment_id" {
  type = "string"
}

variable "instances" {
  type = list(object({
    hostname    = string
    host_labels = map(string)
    connection  = any
  }))
}
