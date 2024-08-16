# Data Source for GitHub Token
data "aws_secretsmanager_secret" "github_token" {
  name = var.github_secret_name # The name of your GitHub token secret
}

data "aws_secretsmanager_secret_version" "github_token_value" {
  secret_id = data.aws_secretsmanager_secret.github_token.id
}