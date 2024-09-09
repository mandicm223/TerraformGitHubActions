
# variable for default region
variable "default_region" {
  type        = string
  default     = "eu-west-1"
  description = "default region"
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

variable "account_ids" {
  type        = string
  default     = "802288441694"
  description = "AWS Account ids"
}

variable "cidr_block" {
  description = "The CIDR block for the VPC"
  default     = "172.17.0.0/16"
}
variable "subnet_count" {
  description = "Number of AZs to cover in a given region"
  default     = "2"
}

variable "ports" {
  default = {
    bff_service = 8081
    gtw_service = 8080
    http        = 80
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
  default     = "https://id-sandbox.asics.com"
}

variable "clutch_retry_max_attempts_bff_service" {
  default = "3"
}
variable "contentstack_url" {
  default = "https://graphql.contentstack.com/stacks/blta941c3d5e669d507?environment=development"
}

variable "contentstack_retry_max_attempts" {
  default = "3"
}

variable "contentstack_retry_wait_duration" {
  default = "500ms"
}

variable "contentstack_circuit_breaker_failure_rate_threshold" {
  default = "50"
}

variable "contentstack_circuit_breaker_ring_buffer_size_in_half_open_state" {
  default = "10"
}

variable "contentstack_circuit_breaker_ring_buffer_size_in_closed_state" {
  default = "100"
}

variable "contentstack_circuit_breaker_wait_duration_in_open_state" {
  default = "30"
}

variable "contentstack_circuit_breaker_permitted_number_of_calls_in_half_open_state" {
  default = "5"
}

variable "contentstack_bulkhead_max_concurrent_calls" {
  default = "100"
}

variable "contentstack_time_limiter_timeout_duration" {
  default = "2"
}

variable "contentstack_rate_limiter_capacity" {
  default = "2"
}

variable "contentstack_rate_limiter_period" {
  default = "60"
}

variable "contentstack_rate_limiter_tokens" {
  default = "10"
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

variable "redis_password_bff_service" {
  default = ""
}



### Gtw service variables

variable "asics_auth_client_id" {
  default = "one_asics_be_staging"
}

variable "asics_auth_client_secret" {
  default = "testttttt"
}

variable "asics_auth_introspect_endpoint" {
  default = "https://id-sandbox.asics.com/api/v2/introspect"
}

variable "rate_limiter_replenish_rate" {
  default = "10"
}

variable "rate_limiter_burst_capacity" {
  default = "20"
}

variable "retry_count" {
  default = "3"
}

variable "request_size" {
  default = "2MB"
}

variable "circuit_breaker_sliding_window_size" {
  default = "100"
}

variable "circuit_breaker_permitted_calls" {
  default = "10"
}

variable "circuit_breaker_wait_duration" {
  default = "10000"
}

variable "circuit_breaker_failure_rate_threshold" {
  default = "50"
}