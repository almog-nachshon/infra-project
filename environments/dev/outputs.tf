output "cluster_name"      { value = module.eks.cluster_name }
output "cluster_endpoint"  { value = module.eks.cluster_endpoint }
output "oidc_provider_arn" { value = module.eks.oidc_provider_arn }
output "kubeconfig_hint"   { value = "aws eks update-kubeconfig --name ${module.eks.cluster_name} --region ${var.region}" }
