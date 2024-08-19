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
        for key, value in var.bff_service_environment_variables : {
          name  = key
          value = value
        }
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