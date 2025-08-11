region             = "il-central-1"
name               = "eks-dev"
vpc_cidr           = "10.0.0.0/16"
kubernetes_version = "1.30"

node_min     = 1
node_desired = 2
node_max     = 5

instance_types = ["t3.large"]
