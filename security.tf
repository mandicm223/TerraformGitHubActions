# ALB security Group: Edit to restrict access to the application
resource "aws_security_group" "lb" {
  name        = "cb-load-balancer-security-group"
  description = "controls access to the ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol        = "tcp"
    from_port       = var.ports.http # staviti 80
    to_port         = var.ports.http
    security_groups = [aws_security_group.gtw_ecs_tasks.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "gtw_lb" {
  name        = "gtw-load-balancer-security-group"
  description = "controls access to the ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol    = "tcp"
    from_port   = var.ports.http
    to_port     = var.ports.http
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Traffic to the ECS cluster should only come from the ALB
resource "aws_security_group" "ecs_tasks" {
  name        = "cb-ecs-tasks-security-group"
  description = "allow inbound access from the ALB only"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol        = "tcp"
    from_port       = var.ports.bff_service
    to_port         = var.ports.bff_service
    security_groups = [aws_security_group.lb.id]
  }

  egress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    description = "Allow traffic to Redis"
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "gtw_ecs_tasks" {
  name   = "gtw-ecs-tasks-security-group"
  vpc_id = aws_vpc.main.id

  ingress {
    protocol        = "tcp"
    from_port       = var.ports.gtw_service
    to_port         = var.ports.gtw_service
    security_groups = [aws_security_group.gtw_lb.id] # Allow traffic from the public LB
  }

  ingress {
    protocol        = "tcp"
    from_port       = 80
    to_port         = 80
    security_groups = [aws_security_group.gtw_lb.id] # Allow traffic from the public LB
  }

  egress {
    from_port = var.ports.gtw_service
    to_port   = var.ports.gtw_service
    protocol  = "tcp"
    #  security_groups = [aws_security_group.bff_lb.id] # Allow traffic to the private LB
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    description = "Allow traffic to Redis"
  }


  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "redis_sg" {
  name        = "redis-sg"
  description = "Allow access to Redis"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_tasks.id]
    description     = "Allow ECS service access to Redis"
  }

  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.gtw_ecs_tasks.id]
    description     = "Allow ECS service access to Redis"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "redis-sg"
  }
}