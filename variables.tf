
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
  type = map(string)
  default = {
    dev = "122610499575"
    test = "423623839651"
    stg = "145023135597"
    prd = "476114148961"
  }
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

variable "bff_service_env" {
  type = map(string)
  default = {
    dev = "dev"
    test = "test"
    stg = "stg"
    prd = "prd"
  }
}

variable "bff_service_clutch_base_url" {
  type = map(string)
  default = {
    dev = "https://id-sandbox.asics.com"
    test = "https://id-sandbox.asics.com"
    stg = "https://id-sandbox.asics.com"
    prd = "https://id-sandbox.asics.com"
  }
}

variable "bff_service_clutch_retry_max_attempts" {
  type = map(string)
  default = {
    dev = "3"
    test = "3"
    stg = "3"
    prd = "3"
  }
}

variable "bff_service_contentstack_url" {
  type = map(string)
  default = {
    dev = "https://graphql.contentstack.com/stacks/blta941c3d5e669d507?environment=development"
    test = "https://graphql.contentstack.com/stacks/blta941c3d5e669d507?environment=development"
    stg = "https://graphql.contentstack.com/stacks/blta941c3d5e669d507?environment=development"
    prd = "https://graphql.contentstack.com/stacks/blta941c3d5e669d507?environment=development"
  }
}

variable "bff_service_contentstack_retry_max_attempts" {
  type = map(string)
  default = {
    dev = "3"
    test = "3"
    stg = "3"
    prd = "3"
  }
}

variable "bff_service_contentstack_retry_wait_duration" {
  type = map(string)
  default = {
    dev = "500ms"
    test = "500ms"
    stg = "500ms"
    prd = "500ms"
  }
}

variable "bff_service_contentstack_circuit_breaker_failure_rate_threshold" {
  type = map(string)
  default = {
    dev = "50"
    test = "50"
    stg = "50"
    prd = "50"
  }
}

variable "bff_service_contentstack_circuit_breaker_ring_buffer_size_in_half_open_state" {
  type = map(string)
  default = {
    dev = "10"
    test = "10"
    stg = "10"
    prd = "10"
  }
}

variable "bff_service_contentstack_circuit_breaker_ring_buffer_size_in_closed_state" {
  type = map(string)
  default = {
    dev = "100"
    test = "100"
    stg = "100"
    prd = "100"
  }
}

variable "bff_service_contentstack_circuit_breaker_wait_duration_in_open_state" {
  type = map(string)
  default = {
    dev = "30"
    test = "30"
    stg = "30"
    prd = "30"
  }
}

variable "bff_service_contentstack_circuit_breaker_permitted_number_of_calls_in_half_open_state" {
  type = map(string)
  default = {
    dev = "5"
    test = "5"
    stg = "5"
    prd = "5"
  }
}

variable "bff_service_contentstack_bulkhead_max_concurrent_calls" {
  type = map(string)
  default = {
    dev = "100"
    test = "100"
    stg = "100"
    prd = "100"
  }
}

variable "bff_service_contentstack_time_limiter_timeout_duration" {
  type = map(string)
  default = {
    dev = "2"
    test = "2"
    stg = "2"
    prd = "2"
  }
}

variable "bff_service_contentstack_rate_limiter_capacity" {
  type = map(string)
  default = {
    dev = "2"
    test = "2"
    stg = "2"
    prd = "2"
  }
}

variable "bff_service_contentstack_rate_limiter_period" {
  type = map(string)
  default = {
    dev = "60"
    test = "60"
    stg = "60"
    prd = "60"
  }
}

variable "bff_service_contentstack_rate_limiter_tokens" {
  type = map(string)
  default = {
    dev = "10"
    test = "10"
    stg = "10"
    prd = "10"
  }
}

variable "bff_service_clutch_retry_wait_duration" {
  type = map(string)
  default = {
    dev = "500ms"
    test = "500ms"
    stg = "500ms"
    prd = "500ms"
  }
}

variable "bff_service_clutch_circuit_breaker_failure_rate_threshold" {
  type = map(string)
  default = {
    dev = "50"
    test = "50"
    stg = "50"
    prd = "50"
  }
}

variable "bff_service_clutch_circuit_breaker_ring_buffer_size_in_half_open_state" {
  type = map(string)
  default = {
    dev = "10"
    test = "10"
    stg = "10"
    prd = "10"
  }
}

variable "bff_service_clutch_circuit_breaker_ring_buffer_size_in_closed_state" {
  type = map(string)
  default = {
    dev = "100"
    test = "100"
    stg = "100"
    prd = "100"
  }
}

variable "bff_service_clutch_circuit_breaker_wait_duration_in_open_state" {
  type = map(string)
  default = {
    dev = "30s"
    test = "30s"
    stg = "30s"
    prd = "30s"
  }
}

variable "bff_service_clutch_circuit_breaker_permitted_number_of_calls_in_half_open_state" {
  type = map(string)
  default = {
    dev = "5"
    test = "5"
    stg = "5"
    prd = "5"
  }
}

variable "bff_service_clutch_bulkhead_max_concurrent_calls" {
  type = map(string)
  default = {
    dev = "100"
    test = "100"
    stg = "100"
    prd = "100"
  }
}

variable "bff_service_clutch_time_limiter_timeout_duration" {
  type = map(string)
  default = {
    dev = "2"
    test = "2"
    stg = "2"
    prd = "2"
  }
}

variable "bff_service_clutch_rate_limiter_capacity" {
  type = map(string)
  default = {
    dev = "2"
    test = "2"
    stg = "2"
    prd = "2"
  }
}

variable "bff_service_clutch_rate_limiter_tokens" {
  type = map(string)
  default = {
    dev = "10"
    test = "10"
    stg = "10"
    prd = "10"
  }
}

variable "bff_service_clutch_rate_limiter_period" {
  type = map(string)
  default = {
    dev = "60"
    test = "60"
    stg = "60"
    prd = "60"
  }
}

variable "bff_service_cache_config_ttl" {
  type = map(string)
  default = {
    dev = "60"
    test = "60"
    stg = "60"
    prd = "60"
  }
}

variable "bff_service_redis_password" {
  type = map(string)
  default = {
    dev = ""
    test = ""
    stg = ""
    prd = ""
  }
}


### Gtw service variables

variable "gtw_service_env" {
  type = map(string)
  default = {
    dev = "dev"
    test = "test"
    stg = "stg"
    prd = "prd"
  }
}

variable "gtw_service_asics_auth_client_id" {
  type = map(string)
  default = {
    dev = "one_asics_be_staging"
    test = "one_asics_be_staging"
    stg = "one_asics_be_staging"
    prd = "one_asics_be_staging"
  }
}

variable "gtw_service_asics_auth_introspect_endpoint" {
  type = map(string)
  default = {
    dev = "https://id-sandbox.asics.com/api/v2/introspect"
    test = "https://id-sandbox.asics.com/api/v2/introspect"
    stg = "https://id-sandbox.asics.com/api/v2/introspect"
    prd = "https://id-sandbox.asics.com/api/v2/introspect"
  }
}

variable "gtw_service_rate_limiter_replenish_rate" {
  type = map(string)
  default = {
    dev = "10"
    test = "10"
    stg = "10"
    prd = "10"
  }
}

variable "gtw_service_rate_limiter_burst_capacity" {
  type = map(string)
  default = {
    dev = "20"
    test = "20"
    stg = "20"
    prd = "20"
  }
}

variable "gtw_service_retry_count" {
  type = map(string)
  default = {
    dev = "3"
    test = "3"
    stg = "3"
    prd = "3"
  }
}

variable "gtw_service_request_size" {
  type = map(string)
  default = {
    dev = "2MB"
    test = "2MB"
    stg = "2MB"
    prd = "2MB"
  }
}

variable "gtw_service_circuit_breaker_sliding_window_size" {
  type = map(string)
  default = {
    dev = "100"
    test = "100"
    stg = "100"
    prd = "100"
  }
}

variable "gtw_service_circuit_breaker_permitted_calls" {
  type = map(string)
  default = {
    dev = "10"
    test = "10"
    stg = "10"
    prd = "10"
  }
}

variable "gtw_service_circuit_breaker_wait_duration" {
  type = map(string)
  default = {
    dev = "10000"
    test = "10000"
    stg = "10000"
    prd = "10000"
  }
}

variable "gtw_service_circuit_breaker_failure_rate_threshold" {
  type = map(string)
  default = {
    dev = "50"
    test = "50"
    stg = "50"
    prd = "50"
  }
}

variable "gtw_service_http_client_connect_timeout" {
  type = map(string)
  default = {
    dev = "2000"
    test = "2000"
    stg = "2000"
    prd = "2000"
  }
}

variable "gtw_service_http_client_response_timeout" {
  type = map(string)
  default = {
    dev = "12s"
    test = "12s"
    stg = "12s"
    prd = "12s"
  }
}