variable "cloudflare_email" {
  default = "simon.vadee@gmail.com"
}

variable "docker_version" {
  default = "18.06.3~ce~3-0~debian"
}

variable "region" {
  default = "par1"
}

variable "manager_instance_type" {
  default = "DEV1-S"
}

variable "worker_instance_type" {
  default = "DEV1-S"
}

variable "worker_instance_count" {
  default = 1
}

variable "docker_api_ip" {
  default = "127.0.0.1"
}

variable "ssh_user" {
  default = "root"
}