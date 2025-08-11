region             = "il-central-1"
name               = "eks-prod"
vpc_cidr           = "10.2.0.0/16"
kubernetes_version = "1.33"

node_min     = 3
node_desired = 4
node_max     = 8

instance_types = ["m6a.large"]
