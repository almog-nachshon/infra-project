variable "region" {
  type    = string
  default = "il-central-1"
}
variable "name" {
  type    = string
  default = "eks-prod"
}
variable "vpc_cidr" {
  type    = string
  default = "10.2.0.0/16"
}
variable "kubernetes_version" {
  type    = string
  default = "1.30"
}

variable "node_min" {
  type    = number
  default = 3
}
variable "node_desired" {
  type    = number
  default = 4
}
variable "node_max" {
  type    = number
  default = 8
}

variable "instance_types" {
  type    = list(string)
  default = ["m6a.large"]
}
