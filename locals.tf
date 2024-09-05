data "aws_elasticache_replication_group" "redis_cluster" {
  replication_group_id = aws_elasticache_replication_group.redis.id
}

locals {
  bff_service_docker_image   = format("%sasics-bff:latest", var.bff_ecr_url)
  bff_service_name           = "bff-service"
  bff_service_desired_count  = 2
  bff_service_fargate_cpu    = 512
  bff_service_fargate_memory = 1024

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