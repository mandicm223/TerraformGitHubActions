resource "aws_codestarconnections_connection" "github_connection" {
  name          = "github-connection"
  provider_type = "GitHub"
}

resource "aws_codepipeline" "codepipeline" {
  name     = "bff-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.build_artifacts.bucket
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
        FullRepositoryId = "mandicm223/example-gh-code-pipeline"
        BranchName       = "main"
      }
    }
  }

  stage {
    name = "Build"
    action {
      name             = "BuildBff"
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