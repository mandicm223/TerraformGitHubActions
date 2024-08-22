locals {
  bff_service_docker_image   = format("%sasics-bff:latest", var.bff_ecr_url)
  bff_service_name           = "bff-service"
  bff_service_desired_count  = 2
  bff_service_fargate_cpu    = 512
  bff_service_fargate_memory = 1024

}

resource "aws_ecs_cluster" "main" {
  name = "asics-cluster"
}

resource "aws_ecs_task_definition" "bff_service_app" {
  family                   = format("%s-app-task", local.bff_service_name)
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = local.bff_service_fargate_cpu
  memory                   = local.bff_service_fargate_memory
  container_definitions = jsonencode([
    {
      "name" : local.bff_service_name
      "image" : local.bff_service_docker_image,
      "cpu" : local.bff_service_fargate_cpu,
      "memory" : local.bff_service_fargate_memory
      "networkMode" : "awsvpc",
      environment = [
        {
          name  = "SPRING_PROFILES_ACTIVE",
          value = var.env_bff_service
        },
        {
          name  = "REDIS_NODES"
          value = local.redis_endpoints_combined
        },
        {
          name  = "CLUTCH_BASE_URL"
          value = var.clutch_base_url_bff_service
        },
        {
          name  = "CLUTCH_RETRY_MAX_ATTEMPTS"
          value = var.clutch_retry_max_attempts_bff_service
        },
        {
          name  = "CLUTCH_RETRY_WAIT_DURATION"
          value = var.clutch_retry_wait_duration_bff_service
        },
        {
          name  = "CLUTCH_CIRCUIT_BREAKER_FAILURE_RATE_THRESHOLD"
          value = var.clutch_circuit_breaker_failure_rate_threshold_bff_service
        },
        {
          name  = "CLUTCH_CIRCUIT_BREAKER_RING_BUFFER_SIZE_IN_HALF_OPEN_STATE"
          value = var.clutch_circuit_breaker_ring_buffer_size_in_half_open_state_bff_service
        },
        {
          name  = "CLUTCH_CIRCUIT_BREAKER_RING_BUFFER_SIZE_IN_CLOSED_STATE"
          value = var.clutch_circuit_breaker_ring_buffer_size_in_closed_state_bff_service
        },
        {
          name  = "CLUTCH_CIRCUIT_BREAKER_WAIT_DURATION_IN_OPEN_STATE"
          value = var.clutch_circuit_breaker_wait_duration_in_open_state_bff_service
        },
        {
          name  = "CLUTCH_CIRCUIT_BREAKER_PERMITTED_NUMBER_OF_CALLS_IN_HALF_OPEN_STATE"
          value = var.clutch_circuit_breaker_permitted_number_of_calls_in_half_open_state_bff_service
        },
        {
          name  = "CLUTCH_BULKHEAD_MAX_CONCURRENT_CALLS"
          value = var.clutch_bulkhead_max_concurrent_calls_bff_service
        },
        {
          name  = "CLUTCH_TIME_LIMITER_TIMEOUT_DURATION"
          value = var.clutch_time_limiter_timeout_duration_bff_service
        },
        {
          name  = "CLUTCH_RATE_LIMITER_CAPACITY"
          value = var.clutch_rate_limiter_capacity_bff_service
        },
        {
          name  = "CLUTCH_RATE_LIMITER_TOKENS"
          value = var.clutch_rate_limiter_tokens_bff_service
        },
        {
          name  = "CLUTCH_RATE_LIMITER_PERIOD"
          value = var.clutch_rate_limiter_period_bff_service
        },
        {
          name  = "CACHE_CONFIG_TTL"
          value = var.cache_config_ttl_bff_service
        },
        {
          name  = "GRAPHIQL_ENABLED"
          value = "false"
        },

      ]
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : "/ecs/bff-service",
          "awslogs-region" : var.default_region,
          "awslogs-stream-prefix" : "ecs"
        }
      },
      "portMappings" : [
        {
          "containerPort" : var.ports.bff_service
          "hostPort" : var.ports.bff_service
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "bff_service" {
  name            = local.bff_service_name
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.bff_service_app.arn
  desired_count   = local.bff_service_desired_count
  launch_type     = "FARGATE"

  #   deployment_controller {
  #     type = "CODE_DEPLOY"
  #   }

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = aws_subnet.private.*.id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.bff_service_blue_tg.arn
    container_name   = "bff-service"
    container_port   = var.ports.bff_service
  }

  #   load_balancer {
  #     target_group_arn = aws_lb_target_group.green_tg.arn
  #     container_name   = "cb-app"
  #     container_port   = 80
  #   }

  depends_on = [aws_lb_listener.dev_listener, aws_iam_role_policy_attachment.ecs-task-execution-role-policy-attachment]

  lifecycle {
    ignore_changes = [desired_count]
  }
}
