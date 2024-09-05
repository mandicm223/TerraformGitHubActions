# resource "aws_lb" "bff_alb" {
#   name               = "bff-alb"
#   load_balancer_type = "application"
#   internal           = true
#   subnets            = aws_subnet.private.*.id
#   idle_timeout       = 60
#   security_groups    = [aws_security_group.lb.id]
# }

# # Target Group for Blue Environment (Current Version)
# resource "aws_lb_target_group" "bff_service_blue_tg" {
#   name        = "bff-service-tg"
#   port        = 8081
#   protocol    = "HTTP"
#   vpc_id      = aws_vpc.main.id
#   target_type = "ip"

#   health_check {
#     healthy_threshold   = "2"
#     interval            = "60"
#     protocol            = "HTTP"
#     matcher             = "200"
#     timeout             = "30"
#     path                = "/health"
#     unhealthy_threshold = "2"
#   }
# }

# # Target Group for Green Environment (New Version)
# # resource "aws_lb_target_group" "green_tg" {
# #   name        = "green-target-group"
# #   port        = 8080
# #   protocol    = "HTTP"
# #   vpc_id      = aws_vpc.main.id
# #   target_type = "ip"

# #   health_check {
# #     healthy_threshold   = "3"
# #     interval            = "30"
# #     protocol            = "HTTP"
# #     matcher             = "200"
# #     timeout             = "3"
# #     path                = var.health_check_path
# #     unhealthy_threshold = "2"
# #   }
# # }

# # Listener for Development Traffic
# resource "aws_lb_listener" "dev_listener" {
#   load_balancer_arn = aws_lb.bff_alb.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.bff_service_blue_tg.arn
#   }
# }

# # resource "aws_lb_listener" "test_listener" {
# #   load_balancer_arn = aws_lb.main.arn
# #   port              = "8080"
# #   protocol          = "HTTP"

# #   default_action {
# #     type             = "forward"
# #     target_group_arn = aws_lb_target_group.green_tg.arn
# #   }
# # }