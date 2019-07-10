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

variable ssh_fingerprint {
    default=  "c5:2a:79:ce:c5:3f:46:ce:97:13:0b:4d:54:87:3b:7e"
}

variable ci_ssh_fingerprint {
    default=  "72:c7:9e:49:f9:00:5f:31:37:2e:87:43:7c:56:22:c9"
}