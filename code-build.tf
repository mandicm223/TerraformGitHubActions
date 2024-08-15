resource "aws_codebuild_project" "my_codebuild_project" {
  name          = "my-codebuild-project"
  description   = "CodeBuild project for my GitHub repo"
  build_timeout = "5" # in minutes

  source {
    type            = "GITHUB"
    location        = "https://github.com/mandicm223/example-gh-code-pipeline"
    git_clone_depth = 1
    buildspec       = "buildspec.yml"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:5.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true
  }

  service_role = aws_iam_role.codebuild_role.arn

  artifacts {
    type                   = "S3"
    location               = aws_s3_bucket.codepipeline_artifacts.bucket
    path                   = "build-output"
    packaging              = "ZIP"
    name                   = "my-app.zip"
    override_artifact_name = true
  }

  cache {
    type = "NO_CACHE"
  }
}
