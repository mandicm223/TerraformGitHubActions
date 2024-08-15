resource "aws_codedeploy_app" "application" {
  name             = "application"
  compute_platform = "Server"
}

resource "aws_codedeploy_deployment_group" "deployment_group" {
  app_name              = aws_codedeploy_app.application.name
  deployment_group_name = "deployment-group"
  service_role_arn      = aws_iam_role.codedeploy_service_role.arn

  deployment_config_name = "CodeDeployDefault.OneAtATime"

  ec2_tag_set {
    ec2_tag_filter {
      key   = "Name"
      type  = "KEY_AND_VALUE"
      value = "your-ec2-tag-value"
    }
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  load_balancer_info {
    target_group_info {
      name = "your-target-group-name"
    }
  }
}