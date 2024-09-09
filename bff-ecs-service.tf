locals {
  bff_service_docker_image   = format("%sasics-bff:latest", var.bff_ecr_url)
  bff_service_name           = "bff-service"
  bff_service_desired_count  = 2
  bff_service_fargate_cpu    = 512
  bff_service_fargate_memory = 1024
}

module "ecs_bff" {
  source     = "./modules/ecs-service"
  cluster_id = module.asics_cluster.cluster_id
  task_definitions = [
    {
      name = "bff-task"
      container_definitions = jsonencode([{
        name : local.bff_service_name
        image : local.bff_service_docker_image
        cpu : local.bff_service_fargate_cpu
        memory : local.bff_service_fargate_memory
        portMappings : [
          {
            "containerPort" : var.ports.bff_service
            "hostPort" : var.ports.bff_service
          }
        ]
        environment : [
          { name : "SPRING_PROFILES_ACTIVE", value : var.env_bff_service },
          { name : "REDIS_NODES", value : local.redis_endpoints_combined },
          { name : "CONTENTSTACK_DELIVERY_TOKEN", valueFrom : local.conntentstack_delivery_token },
          { name : "CONTENTSTACK_URL", value : var.contentstack_url },
          { name : "CONTENTSTACK_RETRY_MAX_ATTEMPTS", value : var.contentstack_retry_max_attempts },
          { name : "CONTENTSTACK_RETRY_WAIT_DURATION", value : var.contentstack_retry_wait_duration },
          { name : "CONTENTSTACK_CIRCUIT_BREAKER_FAILURE_RATE_THRESHOLD", value : var.contentstack_circuit_breaker_failure_rate_threshold },
          { name : "CONTENTSTACK_CIRCUIT_BREAKER_RING_BUFFER_SIZE_IN_HALF_OPEN_STATE", value : var.contentstack_circuit_breaker_ring_buffer_size_in_half_open_state },
          { name : "CONTENTSTACK_CIRCUIT_BREAKER_RING_BUFFER_SIZE_IN_CLOSED_STATE", value : var.contentstack_circuit_breaker_ring_buffer_size_in_closed_state },
          { name : "CONTENTSTACK_CIRCUIT_BREAKER_WAIT_DURATION_IN_OPEN_STATE", value : var.contentstack_circuit_breaker_wait_duration_in_open_state },
          { name : "CONTENTSTACK_CIRCUIT_BREAKER_PERMITTED_NUMBER_OF_CALLS_IN_HALF_OPEN_STATE", value : var.contentstack_circuit_breaker_permitted_number_of_calls_in_half_open_state },
          { name : "CONTENTSTACK_BULKHEAD_MAX_CONCURRENT_CALLS", value : var.contentstack_bulkhead_max_concurrent_calls },
          { name : "CONTENTSTACK_TIME_LIMITER_TIMEOUT_DURATION", value : var.contentstack_time_limiter_timeout_duration },
          { name : "CONTENTSTACK_RATE_LIMITER_CAPACITY", value : var.contentstack_rate_limiter_capacity },
          { name : "CONTENTSTACK_RATE_LIMITER_TOKENS", value : var.contentstack_rate_limiter_tokens },
          { name : "CONTENTSTACK_RATE_LIMITER_PERIOD", value : var.contentstack_rate_limiter_period },
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