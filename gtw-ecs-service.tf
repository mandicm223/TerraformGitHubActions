data "aws_elasticache_replication_group" "redis_cluster" {
  replication_group_id = aws_elasticache_replication_group.redis.id
}

locals {
  gtw_service_docker_image   = format("%sasics-gtw:latest", var.bff_ecr_url)
  gtw_service_name           = "gtw-service"
  gtw_service_desired_count  = 2
  gtw_service_fargate_cpu    = 512
  gtw_service_fargate_memory = 1024


  primary_endpoint = data.aws_elasticache_replication_group.redis_cluster.primary_endpoint_address
  reader_endpoint  = data.aws_elasticache_replication_group.redis_cluster.reader_endpoint_address

  # If the cluster mode endpoint information is available
  redis_endpoints_combined = join(",", compact([local.primary_endpoint, local.reader_endpoint]))

}

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
        logConfiguration : {
          "logDriver" : "awslogs",
          "options" : {
            "awslogs-group" : format("/ecs/%s", local.gtw_service_name),
            "awslogs-region" : var.default_region,
            "awslogs-stream-prefix" : "ecs"
          }
        },
        portMappings : [
          {
            "containerPort" : var.ports.gtw_service
            "hostPort" : var.ports.gtw_service
          }
        ]
        secrets : [
          { name : "ASICS_AUTH_CLIENT_SECRET", valueFrom : local.asics_auth_client_secret },
        ]
        environment : [
          { name : "SPRING_PROFILES_ACTIVE", value : var.gtw_service_env[terraform.workspace] },
          { name : "REDIS_NODES", value : local.redis_endpoints_combined },
          { name : "ASICS_AUTH_CLIENT_ID", value : var.gtw_service_asics_auth_client_id[terraform.workspace] },
          { name : "ASICS_AUTH_INTROSPECT_ENDPOINT", value : var.gtw_service_asics_auth_introspect_endpoint[terraform.workspace] },
          { name : "BFF_URL", value : format("http://%s", module.bff_alb.dns_name) },
          { name : "RATE_LIMITER_REPLENISH_RATE", value : var.gtw_service_rate_limiter_replenish_rate[terraform.workspace] },
          { name : "RATE_LIMITER_BURST_CAPACITY", value : var.gtw_service_rate_limiter_burst_capacity[terraform.workspace] },
          { name : "RETRY_COUNT", value : var.gtw_service_retry_count[terraform.workspace] },
          { name : "REQUEST_SIZE", value : var.gtw_service_request_size[terraform.workspace] },
          { name : "CIRCUIT_BREAKER_SLIDING_WINDOW_SIZE", value : var.gtw_service_circuit_breaker_sliding_window_size[terraform.workspace] },
          { name : "CIRCUIT_BREAKER_PERMITTED_CALLS", value : var.gtw_service_circuit_breaker_permitted_calls[terraform.workspace] },
          { name : "CIRCUIT_BREAKER_WAIT_DURATION", value : var.gtw_service_circuit_breaker_wait_duration[terraform.workspace] },
          { name : "HTTP_CLIENT_CONNECT_TIMEOUT", value : var.gtw_service_http_client_connect_timeout[terraform.workspace] },
          { name : "HTTP_CLIENT_RESPONSE_TIMEOUT", value : var.gtw_service_http_client_response_timeout[terraform.workspace] },
          { name : "CIRCUIT_BREAKER_FAILURE_RATE_THRESHOLD", value : var.gtw_service_circuit_breaker_failure_rate_threshold[terraform.workspace] },

        ]
      }])
  }]
  service_definitions = [
    {
      name             = local.gtw_service_name
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