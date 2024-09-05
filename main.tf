terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.16"
    }
  }
  required_version = ">= 1.2.0"

  backend "s3" {
    bucket         = "remote-state-acics"
    key            = "terraformstate/state-bucket"
    dynamodb_table = "remote-state-lock-acics"
    region         = "eu-west-1"
    encrypt        = true
  }

}

provider "aws" {
  region = var.default_region

}

module "vpc" {
  source       = "./modules/vpc"
  cidr_block   = var.cidr_block
  subnet_count = var.subnet_count
}

module "iam" {
  source = "./modules/iam"
}

module "bff_alb" {
  source     = "./modules/alb"
  alb_name   = "bff-alb"
  tg_name    = format("%s-tg", local.bff_service_name)
  internal   = true
  tg_port    = var.ports.bff_service
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.subnet_ids_private
  sg_id      = aws_security_group.lb.id
}

module "gtw_alb" {
  source     = "./modules/alb"
  alb_name   = "gtw-alb"
  tg_name    = format("%s-tg", local.gtw_service_name)
  internal   = false
  tg_port    = var.ports.gtw_service
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.subnet_ids_public
  sg_id      = aws_security_group.gtw_lb.id
}

module "ecs_bff" {
  source = "./modules/ecs"

  task_definitions = [
    {
      name = "bff-task"
      container_definitions = jsonencode([{
        name : local.bff_service_name
        image : local.bff_service_docker_image
        cpu : local.bff_service_fargate_cpu
        memory : local.bff_service_fargate_memory
        environment : [
          { name : "SPRING_PROFILES_ACTIVE", value : var.env_bff_service },
          { name : "REDIS_NODES", value : local.redis_endpoints_combined },
          { name : "CLUTCH_BASE_URL", value : var.clutch_base_url_bff_service },
          { name : "CLUTCH_RETRY_MAX_ATTEMPTS", value : var.clutch_retry_max_attempts_bff_service },
          { name : "CLUTCH_RETRY_WAIT_DURATION", value : var.clutch_retry_wait_duration_bff_service },
          { name : "CLUTCH_CIRCUIT_BREAKER_FAILURE_RATE_THRESHOLD", value : var.clutch_circuit_breaker_failure_rate_threshold_bff_service },
          { name : "CLUTCH_CIRCUIT_BREAKER_RING_BUFFER_SIZE_IN_HALF_OPEN_STATE", value : var.clutch_circuit_breaker_ring_buffer_size_in_half_open_state_bff_service },
          { name : "CLUTCH_CIRCUIT_BREAKER_RING_BUFFER_SIZE_IN_CLOSED_STATE", value : var.clutch_circuit_breaker_ring_buffer_size_in_closed_state_bff_service },
          { name : "CLUTCH_CIRCUIT_BREAKER_WAIT_DURATION_IN_OPEN_STATE", value : var.clutch_circuit_breaker_wait_duration_in_open_state_bff_service },
          { name : "CLUTCH_CIRCUIT_BREAKER_PERMITTED_NUMBER_OF_CALLS_IN_HALF_OPEN_STATE", value : var.clutch_circuit_breaker_permitted_number_of_calls_in_half_open_state_bff_service },
          { name : "CLUTCH_BULKHEAD_MAX_CONCURRENT_CALLS", value : var.clutch_bulkhead_max_concurrent_calls_bff_service },
          { name : "CLUTCH_TIME_LIMITER_TIMEOUT_DURATION", value : var.clutch_time_limiter_timeout_duration_bff_service },
          { name : "CLUTCH_RATE_LIMITER_CAPACITY", value : var.clutch_rate_limiter_capacity_bff_service },
          { name : "CLUTCH_RATE_LIMITER_TOKENS", value : var.clutch_rate_limiter_tokens_bff_service },
          { name : "CLUTCH_RATE_LIMITER_PERIOD", value : var.clutch_rate_limiter_period_bff_service },
          { name : "CACHE_CONFIG_TTL", value : var.cache_config_ttl_bff_service },
          { name : "GRAPHIQL_ENABLED", value : "false" },

        ]
      }])
  }]
  service_definitions = [
    {
      name             = local.bff_service_name
      desired_count    = local.bff_service_desired_count
      container_name   = local.bff_service_name
      container_port   = var.ports.bff_service
      target_group_arn = module.bff_alb.target_group_arn
  }]
  subnet_ids         = module.vpc.subnet_ids_private
  sg_id              = aws_security_group.ecs_tasks.id
  execution_role_arn = module.iam.ecs_task_execution_role_arn

}

module "ecs_gtw" {
  source = "./modules/ecs"

  task_definitions = [
    {
      name = "gtw-task"
      container_definitions = jsonencode([{
        name : local.gtw_service_name
        image : local.gtw_service_docker_image
        cpu : local.gtw_service_fargate_cpu
        memory : local.gtw_service_fargate_memory
        environment : [
          { name : "SPRING_PROFILES_ACTIVE", value : var.env_bff_service },
          { name : "REDIS_NODES", value : local.redis_endpoints_combined },
          { name : "ASICS_AUTH_CLIENT_ID", value : var.asics_auth_client_id },
          { name : "ASICS_AUTH_CLIENT_SECRET", value : var.asics_auth_client_secret },
          { name : "ASICS_AUTH_INTROSPECT_ENDPOINT", value : var.asics_auth_introspect_endpoint },
          { name : "BFF_URL", value : format("http://%s", aws_lb.bff_alb.dns_name) },
          { name : "RATE_LIMITER_REPLENISH_RATE", value : var.rate_limiter_replenish_rate },
          { name : "RATE_LIMITER_BURST_CAPACITY", value : var.rate_limiter_burst_capacity },
          { name : "RETRY_COUNT", value : var.retry_count },
          { name : "REQUEST_SIZE", value : var.request_size },
          { name : "CIRCUIT_BREAKER_SLIDING_WINDOW_SIZE", value : var.circuit_breaker_sliding_window_size },
          { name : "CIRCUIT_BREAKER_PERMITTED_CALLS", value : var.circuit_breaker_permitted_calls },
          { name : "CIRCUIT_BREAKER_WAIT_DURATION", value : var.circuit_breaker_wait_duration },
          { name : "CIRCUIT_BREAKER_FAILURE_RATE_THRESHOLD", value : var.circuit_breaker_failure_rate_threshold },

        ]
      }])
  }]
  service_definitions = [
    {
      name             = local.bff_service_name
      desired_count    = local.gtw_service_desired_count
      container_name   = local.gtw_service_name
      container_port   = var.ports.gtw_service
      target_group_arn = module.gtw_alb.target_group_arn
  }]
  subnet_ids         = module.vpc.subnet_ids_private
  sg_id              = aws_security_group.gtw_ecs_tasks.id
  execution_role_arn = module.iam.ecs_task_execution_role_arn

}