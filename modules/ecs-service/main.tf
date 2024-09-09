resource "aws_ecs_task_definition" "task" {
  count     = length(var.task_definitions)
  family    = var.task_definitions[count.index].name
  container_definitions = var.task_definitions[count.index].container_definitions
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = "1024"
  cpu                      = "512"
  execution_role_arn       = var.execution_role_arn
}

resource "aws_ecs_service" "service" {
  count     = length(var.task_definitions)
  name                   = var.service_definitions[count.index].name
  cluster                = var.cluster_id
  task_definition        = aws_ecs_task_definition.task[count.index].arn
  desired_count          = var.service_definitions[count.index].desired_count
  launch_type            = "FARGATE"

  network_configuration {
    subnets         = var.subnet_ids
    security_groups = [var.sg_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.service_definitions[count.index].target_group_arn
    container_name   = var.service_definitions[count.index].container_name
    container_port   = var.service_definitions[count.index].container_port
  }

#   deployment_controller {
#     type = "CODE_DEPLOY"
#   }
  # lifecycle {
  #   ignore_changes = [task_definition, desired_count, load_balancer]
  # }
 
}