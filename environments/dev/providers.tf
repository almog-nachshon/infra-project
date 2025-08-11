terraform {
  required_providers {
    aws = { source = "hashicorp/aws", version = ">= 5.60.0" }
    kubernetes = { source = "hashicorp/kubernetes", version = ">= 2.22.0" }
    helm = { source = "hashicorp/helm", version = ">= 2.12.1" }
  }
}

provider "aws" {
  region = var.region
}

# These data sources read the freshly-created EKS cluster for K8s/Helm providers
data "aws_eks_cluster" "this" {
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = module.eks.cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}
