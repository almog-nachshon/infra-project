terraform {
  required_version = ">= 1.6.0"
  backend "s3" {
    bucket         = "my-company-tfstate"
    key            = "eks/test/terraform.tfstate"
    region         = "il-central-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
