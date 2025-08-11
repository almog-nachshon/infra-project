variable "region" { type = string, default = "il-central-1" }
variable "name"   { type = string, default = "eks-test" }
variable "vpc_cidr" { type = string, default = "10.1.0.0/16" }
variable "kubernetes_version" { type = string, default = "1.30" }
variable "node_min"     { type = number, default = 1 }
variable "node_desired" { type = number, default = 2 }
variable "node_max"     { type = number, default = 5 }
variable "instance_types" { type = list(string), default = ["t3.large"] }
