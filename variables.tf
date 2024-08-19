
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

variable "bff_service_environment_variables" {
  type = map(string)
  default = {
    CLUTCH_BASE_URL                                                     = "https://id-sandbox.asics.com"
    CLUTCH_RETRY_MAX_ATTEMPTS                                           = "3"
    CLUTCH_RETRY_WAIT_DURATION                                          = "500ms"
    CLUTCH_CIRCUIT_BREAKER_FAILURE_RATE_THRESHOLD                       = "50"
    CLUTCH_CIRCUIT_BREAKER_RING_BUFFER_SIZE_IN_HALF_OPEN_STATE          = "10"
    CLUTCH_CIRCUIT_BREAKER_RING_BUFFER_SIZE_IN_CLOSED_STATE             = "100"
    CLUTCH_CIRCUIT_BREAKER_WAIT_DURATION_IN_OPEN_STATE                  = "30s"
    CLUTCH_CIRCUIT_BREAKER_PERMITTED_NUMBER_OF_CALLS_IN_HALF_OPEN_STATE = "5"
    CLUTCH_BULKHEAD_MAX_CONCURRENT_CALLS                                = "100"
    CLUTCH_TIME_LIMITER_TIMEOUT_DURATION                                = "2s"
    CLUTCH_RATE_LIMITER_CAPACITY                                        = "2"
    CLUTCH_RATE_LIMITER_TOKENS                                          = "10"
    CLUTCH_RATE_LIMITER_PERIOD                                          = "60"
    CACHE_CONFIG_TTL                                                    = "60"
  }
}