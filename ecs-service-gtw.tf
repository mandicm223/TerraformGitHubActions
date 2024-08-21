locals {
  gtw_service_docker_image   = format("%sasics-gtw:latest", var.bff_ecr_url)
  gtw_service_name           = "gtw-service"
  gtw_service_desired_count  = 2
  gtw_service_fargate_cpu    = 512
  gtw_service_fargate_memory = 1024

}

resource "aws_ecs_task_definition" "gtw_service_app" {
  family                   = format("%s-app-task", local.gtw_service_name)
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = local.gtw_service_fargate_cpu
  memory                   = local.gtw_service_fargate_memory
  container_definitions = jsonencode([
    {
      "name" : local.gtw_service_name
      "image" : local.gtw_service_docker_image,
      "cpu" : local.gtw_service_fargate_cpu,
      "memory" : local.gtw_service_fargate_memory
      "networkMode" : "awsvpc",
      environment = [
        {
          name  = "ENV",
          value = var.env_bff_service
        },
        {
          name  = "REDIS_HOST"
          value = tostring(aws_elasticache_replication_group.redis.configuration_endpoint_address)
        },
        {
          name  = "REDIS_PORT"
          value = tostring(aws_elasticache_replication_group.redis.port)
        },
        {
          name  = "REDIS_PASSWORD"
          value = var.redis_password_bff_service
        },
        {
          name  = "ASICS_AUTH_CLIENT_ID"
          value = var.asics_auth_client_id
        },
        {
          name  = "ASICS_AUTH_CLIENT_SECRET"
          value = var.asics_auth_client_secret
        },
        {
          name  = "ASICS_AUTH_INTROSPECT_ENDPOINT"
          value = var.asics_auth_introspect_endpoint
        },
        {
          name  = "BFF_URL"
          value = format("http://%s", aws_lb.bff_alb.dns_name)
        },
        {
          name  = "RATE_LIMITER_REPLENISH_RATE"
          value = var.rate_limiter_replenish_rate
        },
        {
          name  = "RATE_LIMITER_BURST_CAPACITY"
          value = var.rate_limiter_burst_capacity
        },
        {
          name  = "RETRY_COUNT"
          value = var.retry_count
        },
        {
          name  = "REQUEST_SIZE"
          value = var.request_size
        },
        {
          name  = "CIRCUIT_BREAKER_SLIDING_WINDOW_SIZE"
          value = var.circuit_breaker_sliding_window_size
        },
        {
          name  = "CIRCUIT_BREAKER_PERMITTED_CALLS"
          value = var.circuit_breaker_permitted_calls
        },
        {
          name  = "CIRCUIT_BREAKER_WAIT_DURATION"
          value = var.circuit_breaker_wait_duration
        },
        {
          name  = "CIRCUIT_BREAKER_FAILURE_RATE_THRESHOLD"
          value = var.circuit_breaker_failure_rate_threshold
        }

      ]
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : "/ecs/gtw-service",
          "awslogs-region" : var.default_region,
          "awslogs-stream-prefix" : "ecs"
        }
      },
      "portMappings" : [
        {
          "containerPort" : var.ports.gtw_service
          "hostPort" : var.ports.gtw_service
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "gtw_service" {
  name            = local.gtw_service_name
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.gtw_service_app.arn
  desired_count   = local.gtw_service_desired_count
  launch_type     = "FARGATE"

  #   deployment_controller {
  #     type = "CODE_DEPLOY"
  #   }

  network_configuration {
    security_groups  = [aws_security_group.gtw_ecs_tasks.id]
    subnets          = aws_subnet.public[*].id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.gtw_service_blue_tg.arn
    container_name   = "gtw-service"
    container_port   = var.ports.gtw_service
  }

  #   load_balancer {
  #     target_group_arn = aws_lb_target_group.green_tg.arn
  #     container_name   = "cb-app"
  #     container_port   = 80
  #   }

  depends_on = [aws_ecs_service.bff_service]

  lifecycle {
    ignore_changes = [desired_count]
  }
}
