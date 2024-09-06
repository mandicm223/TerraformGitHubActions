module "bff_code_pipeline" {
  source = "./modules/code-pipeline"
  code_build_project_name = format("%s-code_build_project" , local.bff_service_name)
  code_build_role_arn = module.iam.codebuild_role_arn
  pipeline_name = format("%s-pipeline" , local.bff_service_name)
  code_pipeline_role_arn = module.iam.codepipeline_role_arn
  full_repository_id = "mandicm223/example-gh-code-pipeline"
  repository_brach = "main"
  artifacts_bucket_name = aws_s3_bucket.build_artifacts.bucket
}