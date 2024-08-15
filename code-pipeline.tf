# data "aws_ssm_parameter" "gh_access" {
#   name = "/test/gh/token"
# }


# resource "aws_codepipeline" "my_codepipeline" {
#   name     = "my-codepipeline"
#   role_arn = aws_iam_role.codepipeline_role.arn

#   artifact_store {
#     type     = "S3"
#     location = aws_s3_bucket.codepipeline_artifacts.bucket
#   }

#   stage {
#     name = "Source"

#     action {
#       name             = "GitHub_Source"
#       category         = "Source"
#       owner            = "ThirdParty"
#       provider         = "GitHub"
#       version          = "1"
#       output_artifacts = ["source_output"]

#       configuration = {
#         Owner      = "mandicm223"
#         Repo       = "example-gh-code-pipeline"
#         Branch     = "main"
#         OAuthToken = data.aws_ssm_parameter.gh_access.value
#       }
#     }
#   }

#   stage {
#     name = "Build"

#     action {
#       name             = "CodeBuild"
#       category         = "Build"
#       owner            = "AWS"
#       provider         = "CodeBuild"
#       version          = "1"
#       input_artifacts  = ["source_output"]
#       output_artifacts = ["build_output"]

#       configuration = {
#         ProjectName = aws_codebuild_project.my_codebuild_project.name
#       }
#     }
#   }

#   stage {
#     name = "Deploy"

#     action {
#       name            = "CodeDeploy"
#       category        = "Deploy"
#       owner           = "AWS"
#       provider        = "CodeDeploy"
#       version         = "1"
#       input_artifacts = ["build_output"]

#       configuration = {
#         ApplicationName     = aws_codedeploy_app.my_codedeploy_app.name
#         DeploymentGroupName = aws_codedeploy_deployment_group.my_codedeploy_group.deployment_group_name
#       }
#     }
#   }
# }
