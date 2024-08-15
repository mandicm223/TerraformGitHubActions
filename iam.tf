# resource "aws_iam_role" "codepipeline_role" {
#   name = "codepipeline-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Effect = "Allow"
#       Principal = {
#         Service = "codepipeline.amazonaws.com"
#       }
#       Action = "sts:AssumeRole"
#     }]
#   })
# }

# resource "aws_iam_role_policy_attachment" "codepipeline_policy_attachment" {
#   role       = aws_iam_role.codepipeline_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AWSCodePipeline_FullAccess"
# }

# resource "aws_iam_role" "codebuild_role" {
#   name = "codebuild-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Effect = "Allow"
#       Principal = {
#         Service = "codebuild.amazonaws.com"
#       }
#       Action = "sts:AssumeRole"
#     }]
#   })
# }

# resource "aws_iam_role_policy_attachment" "codebuild_policy_attachment" {
#   role       = aws_iam_role.codebuild_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AWSCodeBuildDeveloperAccess"
# }

# resource "aws_iam_role" "codedeploy_role" {
#   name = "codedeploy-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Effect = "Allow"
#       Principal = {
#         Service = "codedeploy.amazonaws.com"
#       }
#       Action = "sts:AssumeRole"
#     }]
#   })
# }

# resource "aws_iam_role_policy_attachment" "codedeploy_policy_attachment" {
#   role       = aws_iam_role.codedeploy_role.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
# }
