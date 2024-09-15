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
        logConfiguration : {
          "logDriver" : "awslogs",
          "options" : {
            "awslogs-group" : format("/ecs/%s", local.bff_service_name),
            "awslogs-region" : var.default_region,
            "awslogs-stream-prefix" : "ecs"
          }
        },
        portMappings : [
          {
            "containerPort" : var.ports.bff_service
            "hostPort" : var.ports.bff_service
          }
        ]
        secrets : [
          { name : "CONTENTSTACK_DELIVERY_TOKEN", valueFrom : local.conntentstack_delivery_token },
        ]
        environment : [
          { name : "SPRING_PROFILES_ACTIVE", value : var.bff_service_env[terraform.workspace] },
          { name : "REDIS_NODES", value : local.redis_endpoints_combined },
          { name : "CONTENTSTACK_URL", value : var.bff_service_contentstack_url[terraform.workspace] },
          { name : "CONTENTSTACK_RETRY_MAX_ATTEMPTS", value : var.bff_service_contentstack_retry_max_attempts[terraform.workspace] },
          { name : "CONTENTSTACK_RETRY_WAIT_DURATION", value : var.bff_service_contentstack_retry_wait_duration[terraform.workspace] },
          { name : "CONTENTSTACK_CIRCUIT_BREAKER_FAILURE_RATE_THRESHOLD", value : var.bff_service_contentstack_circuit_breaker_failure_rate_threshold[terraform.workspace] },
          { name : "CONTENTSTACK_CIRCUIT_BREAKER_RING_BUFFER_SIZE_IN_HALF_OPEN_STATE", value : var.bff_service_contentstack_circuit_breaker_ring_buffer_size_in_half_open_state[terraform.workspace] },
          { name : "CONTENTSTACK_CIRCUIT_BREAKER_RING_BUFFER_SIZE_IN_CLOSED_STATE", value : var.bff_service_contentstack_circuit_breaker_ring_buffer_size_in_closed_state[terraform.workspace] },
          { name : "CONTENTSTACK_CIRCUIT_BREAKER_WAIT_DURATION_IN_OPEN_STATE", value : var.bff_service_contentstack_circuit_breaker_wait_duration_in_open_state[terraform.workspace] },
          { name : "CONTENTSTACK_CIRCUIT_BREAKER_PERMITTED_NUMBER_OF_CALLS_IN_HALF_OPEN_STATE", value : var.bff_service_contentstack_circuit_breaker_permitted_number_of_calls_in_half_open_state[terraform.workspace] },
          { name : "CONTENTSTACK_BULKHEAD_MAX_CONCURRENT_CALLS", value : var.bff_service_contentstack_bulkhead_max_concurrent_calls[terraform.workspace] },
          { name : "CONTENTSTACK_TIME_LIMITER_TIMEOUT_DURATION", value : var.bff_service_contentstack_time_limiter_timeout_duration[terraform.workspace] },
          { name : "CONTENTSTACK_RATE_LIMITER_CAPACITY", value : var.bff_service_contentstack_rate_limiter_capacity[terraform.workspace] },
          { name : "CONTENTSTACK_RATE_LIMITER_TOKENS", value : var.bff_service_contentstack_rate_limiter_tokens[terraform.workspace] },
          { name : "CONTENTSTACK_RATE_LIMITER_PERIOD", value : var.bff_service_contentstack_rate_limiter_period[terraform.workspace] },
          { name : "CLUTCH_BASE_URL", value : var.bff_service_clutch_base_url[terraform.workspace] },
          { name : "CLUTCH_RETRY_MAX_ATTEMPTS", value : var.bff_service_clutch_retry_max_attempts[terraform.workspace] },
          { name : "CLUTCH_RETRY_WAIT_DURATION", value : var.bff_service_clutch_retry_wait_duration[terraform.workspace] },
          { name : "CLUTCH_CIRCUIT_BREAKER_FAILURE_RATE_THRESHOLD", value : var.bff_service_clutch_circuit_breaker_failure_rate_threshold[terraform.workspace] },
          { name : "CLUTCH_CIRCUIT_BREAKER_RING_BUFFER_SIZE_IN_HALF_OPEN_STATE", value : var.bff_service_clutch_circuit_breaker_ring_buffer_size_in_half_open_state[terraform.workspace] },
          { name : "CLUTCH_CIRCUIT_BREAKER_RING_BUFFER_SIZE_IN_CLOSED_STATE", value : var.bff_service_clutch_circuit_breaker_ring_buffer_size_in_closed_state[terraform.workspace] },
          { name : "CLUTCH_CIRCUIT_BREAKER_WAIT_DURATION_IN_OPEN_STATE", value : var.bff_service_clutch_circuit_breaker_wait_duration_in_open_state[terraform.workspace] },
          { name : "CLUTCH_CIRCUIT_BREAKER_PERMITTED_NUMBER_OF_CALLS_IN_HALF_OPEN_STATE", value : var.bff_service_clutch_circuit_breaker_permitted_number_of_calls_in_half_open_state[terraform.workspace] },
          { name : "CLUTCH_BULKHEAD_MAX_CONCURRENT_CALLS", value : var.bff_service_clutch_bulkhead_max_concurrent_calls[terraform.workspace] },
          { name : "CLUTCH_TIME_LIMITER_TIMEOUT_DURATION", value : var.bff_service_clutch_time_limiter_timeout_duration[terraform.workspace] },
          { name : "CLUTCH_RATE_LIMITER_CAPACITY", value : var.bff_service_clutch_rate_limiter_capacity[terraform.workspace] },
          { name : "CLUTCH_RATE_LIMITER_TOKENS", value : var.bff_service_clutch_rate_limiter_tokens[terraform.workspace] },
          { name : "CLUTCH_RATE_LIMITER_PERIOD", value : var.bff_service_clutch_rate_limiter_period[terraform.workspace] },
          { name : "CACHE_CONFIG_TTL", value : var.bff_service_cache_config_ttl[terraform.workspace] },
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