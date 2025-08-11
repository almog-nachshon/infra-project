variable "region" {
  type    = string
  default = "il-central-1"
}

variable "state_bucket_name" {
  description = "Global unique bucket name for Terraform state"
  type        = string
}

variable "lock_table_name" {
  description = "DynamoDB table name for state locking"
  type        = string
  default     = "terraform-locks"
}
