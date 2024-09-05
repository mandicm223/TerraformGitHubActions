output "task_definition_arns" {
  value = aws_ecs_task_definition.task[*].arn
}

output "service_arns" {
  value = aws_ecs_service.service[*].arn
}