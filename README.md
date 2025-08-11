# EKS on AWS (Terraform + EKS Blueprints)

# by Almog Levinshtein, Devops Engineer
This repository project an Amazon EKS environment in **il-central-1** using Terraform with production-friendly defaults:

- **Networking**: `terraform-aws-modules/vpc/aws` (multi-AZ VPC, public/private subnets, NAT)
- **EKS**: `terraform-aws-modules/eks/aws` (cluster + managed node groups, IRSA)
- **Add-ons & Observability**: `aws-ia/eks-blueprints-addons` (VPC CNI, CoreDNS, kube-proxy, ALB controller, Argo CD, kube-prom-stack, metrics-server)
- **Remote state**: S3 (with DynamoDB lock)
- **Environments**: `dev`, `test`, `prod` (identical structure; tailor with `terraform.tfvars`).

---

## Prerequisites
- Terraform >= 1.6
- AWS CLI configured with permissions to create VPC/EKS/IAM etc.
- S3 bucket + DynamoDB table for remote state (use `bootstrap/state` to create them if you don't have them yet).

---

## One-time: Bootstrap remote state
```bash
cd bootstrap/state
terraform init
terraform apply -auto-approve
# Outputs:
# - state_bucket_name
# - lock_table_name
```

---

## Deploy an environment (example: prod)
```bash
cd environments/prod
terraform init
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
```

---

## Deploy an environment (example: dev)
```bash
cd environments/dev
terraform init
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
```

---

## Deploy an environment (example: test)
```bash
cd environments/test
terraform init
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
```


After apply:
```bash
aws eks update-kubeconfig --name $(terraform output -raw cluster_name) --region il-central-1
kubectl get nodes -A
kubectl get pods -A
```

---

## Files & Structure
```text
eks-blueprints-tf/
├─ bootstrap/
│  └─ state/
│     ├─ main.tf
│     ├─ variables.tf
│     └─ terraform.tfvars
└─ environments/
   ├─ dev/
   │  ├─ backend.tf
   │  ├─ main.tf
   │  ├─ providers.tf
   │  ├─ variables.tf
   │  ├─ terraform.tfvars
   │  └─ outputs.tf
   ├─ test/  (same as dev, different tfvars + state key)
   └─ prod/  (same as dev, production-sized tfvars + state key)
```

---

## Customization Tips
- **Kubernetes version**: set `kubernetes_version` in each env’s `terraform.tfvars` (e.g., `"1.30"`).
- **Node capacity**: tune `node_min`, `node_desired`, `node_max`, and `instance_types` per environment.
- **Argo CD**: after install, add your Git repo as an ArgoCD Application for GitOps.
- **Ingress**: ALB controller is enabled; expose services via `Ingress` resources.
- **Security**: add more policies/IRSA, network policies, or extra add-ons (e.g., external-secrets, cert-manager).

---

## Destroy
```bash
terraform destroy -var-file=terraform.tfvars
```
