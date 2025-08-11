terraform {
  required_version = ">= 1.6.0"
  backend "s3" {
    bucket         = "my-company-tfstate"   # change to your bucket
    key            = "eks/dev/terraform.tfstate"
    region         = "il-central-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
