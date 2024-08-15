# resource "aws_codedeploy_app" "my_codedeploy_app" {
#   name = "my-codedeploy-app"
# }

# resource "aws_codedeploy_deployment_group" "my_codedeploy_group" {
#   app_name              = aws_codedeploy_app.my_codedeploy_app.name
#   deployment_group_name = "my-deployment-group"
#   service_role_arn      = aws_iam_role.codedeploy_role.arn

#   deployment_style {
#     deployment_option = "WITH_TRAFFIC_CONTROL"
#     deployment_type   = "BLUE_GREEN"
#   }

#   load_balancer_info {
#     elb_info {
#       name = "my-elb"
#     }
#   }

#   auto_rollback_configuration {
#     enabled = true
#     events  = ["DEPLOYMENT_FAILURE"]
#   }
# }
