variable "region" { type = string, default = "il-central-1" }

variable "name" {
  description = "Base name/prefix for resources"
  type        = string
  default     = "eks-dev"
}

variable "vpc_cidr" { type = string, default = "10.0.0.0/16" }

variable "kubernetes_version" {
  type    = string
  default = "1.30"  # set to "1.31" if supported in your account/region
}

variable "node_min"     { type = number, default = 1 }
variable "node_desired" { type = number, default = 2 }
variable "node_max"     { type = number, default = 5 }

variable "instance_types" {
  type    = list(string)
  default = ["t3.large"]
}
