variable "vpc_id" {
  type = string
}

resource "aws_security_group" "alb" {
  name        = "starttech-alb-sg"
  description = "ALB: HTTP and HTTPS from anywhere"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "starttech-alb-sg" }
}

resource "aws_security_group_rule" "nodes_from_alb" {
  type                     = "ingress"
  from_port                = 30080
  to_port                  = 30080
  protocol                 = "tcp"
  security_group_id        = aws_eks_cluster.starttech_cluster.vpc_config[0].cluster_security_group_id
  source_security_group_id = aws_security_group.alb.id
}

resource "aws_lb" "backend" {
  name               = "starttech-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.public_subnet_ids
}

resource "aws_lb_target_group" "backend" {
  name     = "starttech-backend-tg"
  port     = 30080
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path    = "/health"
    port    = "traffic-port"
    matcher = "200"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.backend.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend.arn
  }
}

resource "aws_autoscaling_attachment" "nodes" {
  autoscaling_group_name = aws_eks_node_group.starttech_node_group.resources[0].autoscaling_groups[0].name
  lb_target_group_arn    = aws_lb_target_group.backend.arn
}

output "alb_dns_name" {
  value = aws_lb.backend.dns_name
}
