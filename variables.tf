
# variable for default region
variable "default_region" {
  type        = string
  default     = "eu-west-1"
  description = "your default region"
}

variable "bucket_rstate" {
  type        = string
  default     = "remote-state-acics"
  description = "unique name of the S3 bucket for state"
}

variable "dynamodb_lock" {
  type        = string
  default     = "remote-state-lock-acics"
  description = "Name of key-value-store"
}

variable "environments" {
  type = map(string)
  default = {
    dev = "dev"
    stg = "stg"
    prd = "prd"
  }
}

variable "github_token" {
  description = "GitHub Personal Access Token"
  type        = string
}