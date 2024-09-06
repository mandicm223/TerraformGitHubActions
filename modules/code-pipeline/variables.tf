variable "code_build_project_name" {
  description = "Code build project name"
  type        = string
}

variable "code_build_role_arn" {
  description = "Code build role arn"
  type        = string
}

variable "pipeline_name" {
  description = "Code pipeline name"
  type        = string
}

variable "code_pipeline_role_arn" {
  description = "Code pipeline role arn"
  type        = string
}

variable "artifacts_bucket_name" {
  description = "Artifact bucekt name"
  type        = string
}

variable "full_repository_id" {
  description = "Full GitHub repository id"
  type        = string
}

variable "repository_brach" {
  description = "Repository branch"
  type        = string
}

