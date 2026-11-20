variable "cluster_name" {
  type    = string
  default = "starttech-cluster"
}

variable "kubernetes_version" {
  type    = string
  default = "1.34"
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "public_subnet_ids" {
  type = list(string)
}
