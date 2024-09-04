# resource "aws_codebuild_source_credential" "github_credential" {
#   server_type = "GITHUB"
#   auth_type   = "PERSONAL_ACCESS_TOKEN"
#   token       = data.aws_secretsmanager_secret_version.github_token_value.secret_string
# }

# resource "aws_codebuild_project" "application_build" {
#   name         = "application-build"
#   service_role = aws_iam_role.codebuild_service_role.arn

#   source {
#     type            = "GITHUB"
#     location        = "https://github.com/mandicm223/example-gh-code-pipeline"
#     buildspec       = "buildspec.yml" # This should be in your repository root
#     git_clone_depth = 1
#   }

#   artifacts {
#     type      = "S3"
#     location  = aws_s3_bucket.build_artifacts.bucket
#     packaging = "ZIP"
#   }

#   environment {
#     compute_type = "BUILD_GENERAL1_SMALL"
#     image        = "aws/codebuild/standard:4.0"
#     type         = "LINUX_CONTAINER"
#   }
# }

resource "aws_codebuild_project" "build_project" {
  name         = "bff-codebuild-project"
  service_role = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:4.0"
    type         = "LINUX_CONTAINER"
    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = var.default_region
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec.yml"
  }
}