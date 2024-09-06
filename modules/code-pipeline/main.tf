resource "aws_codebuild_project" "build_project" {
  name         = var.code_build_project_name
  service_role = var.code_build_role_arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:4.0"
    type         = "LINUX_CONTAINER"
    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = "default region"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec.yml"
  }
}

# resource "aws_codedeploy_app" "application" {
#   name             = "application"
#   compute_platform = "ECS"
# }

# resource "aws_codedeploy_deployment_group" "deployment_group" {
#   app_name               = aws_codedeploy_app.application.name
#   deployment_group_name  = "deployment-group"
#   service_role_arn       = aws_iam_role.codedeploy_service_role.arn
#   deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"


#   deployment_style {
#     deployment_type   = "BLUE_GREEN"
#     deployment_option = "WITH_TRAFFIC_CONTROL"
#   }

#   ecs_service {
#     cluster_name = aws_ecs_cluster.main.name
#     service_name = aws_ecs_service.main.name
#   }

#   load_balancer_info {
#     target_group_pair_info {
#       prod_traffic_route {
#         listener_arns = [aws_lb_listener.dev_listener.arn]
#       }
#       target_group {
#         name = aws_lb_target_group.blue_tg.name
#       }
#       target_group {
#         name = aws_lb_target_group.green_tg.name
#       }
#     }
#   }

#   blue_green_deployment_config {
#     terminate_blue_instances_on_deployment_success {
#       action                           = "TERMINATE"
#       termination_wait_time_in_minutes = 5
#     }

#     deployment_ready_option {
#       action_on_timeout = "CONTINUE_DEPLOYMENT"
#     }
#   }

#   auto_rollback_configuration {
#     enabled = true
#     events  = ["DEPLOYMENT_FAILURE"]
#   }
# }


### -------------------------------


# resource "aws_codedeploy_app" "bff_app" {
#   name             = "bff-codedeploy-app"
#   compute_platform = "ECS"
# }

# resource "aws_codedeploy_deployment_group" "deployment_group" {
#   app_name              = aws_codedeploy_app.bff_app.name
#   deployment_group_name = "bff-deployment-group"
#   service_role_arn      = aws_iam_role.codedeploy_role.arn

#   deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"

#   auto_rollback_configuration {
#     enabled = true
#     events  = ["DEPLOYMENT_FAILURE"]
#   }

#   blue_green_deployment_config {
#     terminate_blue_instances_on_deployment_success {
#       action                           = "TERMINATE"
#       termination_wait_time_in_minutes = 5
#     }
#     deployment_ready_option {
#       action_on_timeout = "CONTINUE_DEPLOYMENT"
#     }
#   }

#   ecs_service {
#     cluster_name = aws_ecs_cluster.main.name
#     service_name = aws_ecs_service.bff_service.name
#   }
# }

resource "aws_codestarconnections_connection" "github_connection" {
  name          = "github-connection"
  provider_type = "GitHub"
}

resource "aws_codepipeline" "codepipeline" {
  name     = var.pipeline_name
  role_arn = var.code_pipeline_role_arn

  artifact_store {
    location = var.artifacts_bucket_name
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]
      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.github_connection.arn
        FullRepositoryId = var.full_repository_id
        BranchName       = var.repository_brach
      }
    }
  }

  stage {
    name = "Build"
    action {
      name             = aws_codebuild_project.build_project.name
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      configuration = {
        ProjectName = aws_codebuild_project.build_project.name
      }
    }
  }

  #   stage {
  #     name = "Deploy"
  #     action {
  #       name            = "Deploy"
  #       category        = "Deploy"
  #       owner           = "AWS"
  #       version          = "1"
  #       provider        = "CodeDeploy"
  #       input_artifacts = ["build_output"]
  #       configuration = {
  #         ApplicationName     = aws_codedeploy_app.app.name
  #         DeploymentGroupName = aws_codedeploy_deployment_group.deployment_group.name
  #       }
  #     }
  #   }
}