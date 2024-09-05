resource "aws_ecs_cluster" "cluster" {
  name = "asics-cluster"
}

resource "aws_ecs_task_definition" "task" {
  count = 1
  family    = element(var.task_definitions[count.index], "name")
  container_definitions = element(var.task_definitions[count.index], "container_definitions")
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = "512"
  cpu                      = "1024"
  execution_role_arn       = var.execution_role_arn
}

resource "aws_ecs_service" "service" {
  count                  = 1
  name                   = element(var.service_definitions[count.index], "name")
  cluster                = aws_ecs_cluster.cluster.id
  task_definition        = element(aws_ecs_task_definition.task.*.arn, count.index)
  desired_count          = element(var.service_definitions[count.index], "desired_count")
  launch_type            = "FARGATE"

  network_configuration {
    subnets         = var.subnet_ids
    security_groups = [var.sg_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = element(var.service_definitions[count.index], "target_group_arn")
    container_name   = element(var.service_definitions[count.index], "container_name")
    container_port   = element(var.service_definitions[count.index], "container_port")
  }

#   deployment_controller {
#     type = "CODE_DEPLOY"
#   }
  lifecycle {
    ignore_changes = [task_definition, desired_count, load_balancer]
  }
 
}