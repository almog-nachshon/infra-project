data "aws_availability_zones" "available" { state = "available" }

locals {
  azs = length(data.aws_availability_zones.available.names) >= 3 ?
    slice(data.aws_availability_zones.available.names, 0, 3) :
    data.aws_availability_zones.available.names

  public_subnets  = [for i, _ in local.azs : cidrsubnet(var.vpc_cidr, 8, i)]
  private_subnets = [for i, _ in local.azs : cidrsubnet(var.vpc_cidr, 8, i + 10)]
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = ">= 5.8.0"
  name = "${var.name}-vpc"
  cidr = var.vpc_cidr
  azs             = local.azs
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets
  enable_nat_gateway = true
  single_nat_gateway = true
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = { Environment = "test", Project = var.name }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = ">= 21.0.0"
  cluster_name                   = var.name
  cluster_version                = var.kubernetes_version
  cluster_endpoint_public_access = true
  enable_irsa                    = true
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  eks_managed_node_groups = {
    default = {
      min_size     = var.node_min
      max_size     = var.node_max
      desired_size = var.node_desired
      instance_types = var.instance_types
      capacity_type  = "ON_DEMAND"
    }
  }
  tags = { Environment = "test", Project = var.name }
}

module "eks_blueprints_addons" {
  source  = "aws-ia/eks-blueprints-addons/aws"
  version = ">= 1.22.0"
  cluster_name      = module.eks.cluster_name
  cluster_endpoint  = module.eks.cluster_endpoint
  cluster_version   = module.eks.cluster_version
  oidc_provider_arn = module.eks.oidc_provider_arn

  eks_addons = {
    vpc-cni    = { most_recent = true }
    kube-proxy = { most_recent = true }
    coredns    = { most_recent = true }
  }

  enable_metrics_server        = true
  enable_kube_prometheus_stack = true
  enable_aws_load_balancer_controller = true

  helm_releases = {
    argocd = {
      namespace        = "argocd"
      create_namespace = true
      chart            = "argo-cd"
      repository       = "https://argoproj.github.io/argo-helm"
      version          = ">= 6.7.0"
      values           = []
    }
  }

  tags = { Environment = "test", Project = var.name }
}
