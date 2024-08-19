
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

variable "github_secret_name" {
  default     = "GitHubToken"
  description = "GitHub Personal Access Token"
  type        = string
}

variable "az_count" {
  description = "Number of AZs to cover in a given region"
  default     = "2"
}

variable "ports" {
  default = {
    bff_service       = 8081
    asics_api_gateway = 8080
  }
}

### Bff service variables
variable "bff_ecr_url" {
  description = "Bff service ECR url"
  default     = "802288441694.dkr.ecr.eu-west-1.amazonaws.com/"
}

variable "env_bff_service" {
  default = "dev"
}

variable "clutch_base_url_bff_service" {
  description = "Bff sevice couch base url"
  default = "https://id-sandbox.asics.com"
}

variable "clutch_retry_max_attempts_bff_service" {
  default = "3"
}

variable "clutch_retry_wait_duration_bff_service" {
  default = "500ms"
}

variable "clutch_circuit_breaker_failure_rate_threshold_bff_service" {
  default = "50"
}

variable "clutch_circuit_breaker_ring_buffer_size_in_half_open_state_bff_service" {
  default = "10"
}

variable "clutch_circuit_breaker_ring_buffer_size_in_closed_state_bff_service" {
  default = "100"
}

variable "clutch_circuit_breaker_wait_duration_in_open_state_bff_service" {
  default = "30s"
}

variable "clutch_circuit_breaker_permitted_number_of_calls_in_half_open_state_bff_service" {
  default = "5"
}

variable "clutch_bulkhead_max_concurrent_calls_bff_service" {
  default = "100"
}

variable "clutch_time_limiter_timeout_duration_bff_service" {
  default = "2s"
}

variable "clutch_rate_limiter_capacity_bff_service" {
  default = "2"
}

variable "clutch_rate_limiter_tokens_bff_service" {
  default = "10"
}

variable "clutch_rate_limiter_period_bff_service" {
  default = "60"
}

variable "cache_config_ttl_bff_service" {
  default = "60"
}

variable "redis_password" {
  default = ""
}