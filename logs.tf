resource "aws_cloudwatch_log_group" "bff_service_log_group" {
  name              = "/ecs/bff-service"
  retention_in_days = 30

  tags = {
    Name = "cb-log-group"
  }
}

resource "aws_cloudwatch_log_stream" "bff_service_log_stream" {
  name           = "bff-service-log-stream"
  log_group_name = aws_cloudwatch_log_group.cb_log_group.name
}