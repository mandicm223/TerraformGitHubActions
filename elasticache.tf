resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "redis-subnet-group"
  subnet_ids = aws_subnet.private.*.id

  tags = {
    Name = "redis-subnet-group"
  }
}

resource "aws_elasticache_replication_group" "redis" {
  replication_group_id       = "my-redis-cluster"
  description                = "Redis replication group with cluster mode enabled"
  node_type                  = "cache.t2.micro"
  num_cache_clusters         = 2 # Number of primary nodes
  automatic_failover_enabled = true
  engine                     = "redis"
  engine_version             = "7.1"
  parameter_group_name       = "default.redis7.cluster.on"
  port                       = 6379
  subnet_group_name          = aws_elasticache_subnet_group.redis_subnet_group.name
  security_group_ids         = [aws_security_group.redis_sg.id]
  cluster_mode               = enabled
  num_node_groups            = 2 # Number of shards
  replicas_per_node_group    = 1 # Number of replicas per shard

  tags = {
    Name = "my-redis-cluster"
  }
}
