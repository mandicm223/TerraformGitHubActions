resource "aws_codedeploy_app" "application" {
  name             = "application"
  compute_platform = "ECS"
}

resource "aws_codedeploy_deployment_group" "deployment_group" {
  app_name              = aws_codedeploy_app.application.name
  deployment_group_name = "deployment-group"
  service_role_arn      = aws_iam_role.codedeploy_service_role.arn

  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce" # Normal deployment without Blue/Green

  ecs_service {
    cluster_name = aws_ecs_cluster.main.name
    service_name = aws_ecs_service.main.name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [aws_alb_listener.app_listener.arn] # Replace with your actual ALB listener ARN
      }
      target_group {
        name = aws_alb_target_group.app.name
      }
    }
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  deployment_style {
    deployment_type   = "IN_PLACE"             # Normal deployment
    deployment_option = "WITH_TRAFFIC_CONTROL" # Optional, can be WITHOUT_TRAFFIC_CONTROL
  }
}