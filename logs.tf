resource "aws_cloudwatch_log_group" "bff_service_log_group" {
  name              = "/ecs/bff-service"
  retention_in_days = 30

  tags = {
    Name = "cb-log-group"
  }
}

resource "aws_cloudwatch_log_stream" "bff_service_log_stream" {
  name           = "bff-service-log-stream"
  log_group_name = aws_cloudwatch_log_group.bff_service_log_group.name
}

resource "aws_cloudwatch_log_group" "gtw_service_log_group" {
  name              = "/ecs/gtw-service"
  retention_in_days = 30

  tags = {
    Name = "gtw-log-group"
  }
}

resource "aws_cloudwatch_log_stream" "bff_service_log_stream" {
  name           = "gtw-service-log-stream"
  log_group_name = aws_cloudwatch_log_group.gtw_service_log_group.name
}

resource "aws_cloudwatch_log_group" "redis_cache_log_group" {
  name              = "/cache/redis"
  retention_in_days = 30

  tags = {
    Name = "redis-log-group"
  }
}

resource "aws_cloudwatch_log_stream" "redis_cache_log_stream" {
  name           = "redis-log-stream"
  log_group_name = aws_cloudwatch_log_group.redis_cache_log_group.name
}