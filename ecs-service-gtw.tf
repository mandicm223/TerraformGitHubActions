module "ecs_gtw" {
  source = "./modules/ecs-service"

  task_definitions = [
    {
      name = "gtw-task"
      container_definitions = jsonencode([{
        name : local.gtw_service_name
        image : local.gtw_service_docker_image
        cluster_id : module.asics_cluster.cluster_id
        cpu : local.gtw_service_fargate_cpu
        memory : local.gtw_service_fargate_memory
        portMappings : [
          {
            "containerPort" : var.ports.gtw_service
            "hostPort" : var.ports.gtw_service
          }
        ]
        environment : [
          { name : "SPRING_PROFILES_ACTIVE", value : var.env_bff_service },
          { name : "REDIS_NODES", value : local.redis_endpoints_combined },
          { name : "ASICS_AUTH_CLIENT_ID", value : var.asics_auth_client_id },
          { name : "ASICS_AUTH_CLIENT_SECRET", value : var.asics_auth_client_secret },
          { name : "ASICS_AUTH_INTROSPECT_ENDPOINT", value : var.asics_auth_introspect_endpoint },
          { name : "BFF_URL", value : format("http://%s", module.bff_alb.dns_name) },
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
  cluster_id         = module.asics_cluster.cluster_id

}