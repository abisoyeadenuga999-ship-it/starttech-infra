resource "aws_security_group" "redis" {
  name        = "starttech-redis-sg"
  description = "Allow Redis from EKS workers only"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Redis from EKS workers"
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [var.eks_node_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "starttech-redis-sg" }
}

resource "aws_elasticache_subnet_group" "redis" {
  name       = "starttech-redis-subnets"
  subnet_ids = var.private_subnet_ids
}

resource "aws_elasticache_cluster" "starttech_redis" {
  cluster_id           = "starttech-redis"
  engine               = "redis"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  port                 = 6379
  parameter_group_name = "default.redis7"
  subnet_group_name    = aws_elasticache_subnet_group.redis.name
  security_group_ids   = [aws_security_group.redis.id]
}
