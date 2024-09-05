# ## CODE PIPELINE PERMISSIONS ##
# resource "aws_iam_role" "codepipeline_role" {
#   name = "codepipeline-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect = "Allow",
#         Principal = {
#           Service = "codepipeline.amazonaws.com"
#         },
#         Action = "sts:AssumeRole"
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy" "codepipeline_service_role_policy" {
#   role = aws_iam_role.codepipeline_role.id

#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect = "Allow",
#         Action = [
#           "codepipeline:*",
#           "codebuild:BatchGetBuilds",
#           "codebuild:StartBuild",
#           "codebuild:BatchGetProjects",
#           "codebuild:BatchGetBuildBatches",
#           "codebuild:ListBuildsForProject",
#           "codedeploy:RegisterApplicationRevision",
#           "codedeploy:GetApplicationRevision",
#           "codedeploy:GetDeploymentConfig",
#           "codedeploy:CreateDeployment",
#           "codedeploy:GetDeployment",
#           "codedeploy:GetDeploymentGroup",
#           "s3:PutObject",
#           "s3:GetObject",
#           "s3:GetObjectVersion",
#           "s3:GetBucketVersioning",
#           "s3:PutBucketVersioning",
#           "s3:PutBucketAcl",
#           "s3:GetBucketAcl",
#           "cloudwatch:*",
#           "codestar-connections:UseConnection",
#           "iam:PassRole",
#           "lambda:InvokeFunction",
#           "lambda:GetFunctionConfiguration"
#         ],
#         Resource = "*"
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "codepipeline_attach" {
#   role       = aws_iam_role.codepipeline_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AWSCodePipeline_FullAccess"
# }


# ## CODE BUILD PERMISSIONS ##

# resource "aws_iam_role" "codebuild_role" {
#   name = "codebuild-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect = "Allow",
#         Principal = {
#           Service = "codebuild.amazonaws.com"
#         },
#         Action = "sts:AssumeRole"
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy" "codebuild_service_role_policy" {
#   role = aws_iam_role.codebuild_role.id

#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect = "Allow",
#         Action = [
#           "logs:CreateLogGroup",
#           "logs:CreateLogStream",
#           "logs:PutLogEvents",
#           "s3:PutObject",
#           "s3:GetObject",
#           "s3:GetObjectVersion",
#           "s3:ListBucket",
#           "codebuild:BatchGetBuilds",
#           "codebuild:StartBuild",
#           "codebuild:BatchGetProjects",
#           "ec2:DescribeSubnets",
#           "ec2:DescribeSecurityGroups",
#           "ec2:DescribeVpcs",
#           "ec2:CreateNetworkInterface",
#           "ec2:DescribeNetworkInterfaces",
#           "ec2:DeleteNetworkInterface"
#         ],
#         Resource = "*"
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "codebuild_attach" {
#   role       = aws_iam_role.codebuild_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AWSCodeBuildDeveloperAccess"
# }

# ## CODE DEPLOY PERMISSIONS ##

# resource "aws_iam_role" "codedeploy_role" {
#   name = "codedeploy-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect = "Allow",
#         Principal = {
#           Service = "codedeploy.amazonaws.com"
#         },
#         Action = "sts:AssumeRole"
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy" "codedeploy_service_role_policy" {
#   role = aws_iam_role.codedeploy_role.id

#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect = "Allow",
#         Action = [
#           "ecs:DescribeServices",
#           "ecs:UpdateService",
#           "ecs:DescribeTaskDefinition",
#           "ecs:DescribeTasks",
#           "ecs:ListTasks",
#           "events:PutRule",
#           "events:PutTargets",
#           "events:DescribeRule",
#           "lambda:InvokeFunction",
#           "s3:GetObject",
#           "s3:GetObjectVersion",
#           "s3:GetBucketVersioning",
#           "application-autoscaling:RegisterScalableTarget",
#           "application-autoscaling:DeleteScalingPolicy",
#           "application-autoscaling:DeregisterScalableTarget",
#           "application-autoscaling:DescribeScalableTargets",
#           "application-autoscaling:PutScalingPolicy",
#           "application-autoscaling:DescribeScalingPolicies",
#           "cloudwatch:DescribeAlarms",
#           "cloudwatch:PutMetricAlarm",
#           "cloudwatch:DeleteAlarms"
#         ],
#         Resource = "*"
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "codedeploy_attach" {
#   role       = aws_iam_role.codedeploy_role.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
# }

# ## ECS TASKS PERMISSIONS ##

# resource "aws_iam_role" "ecs_task_execution_role" {
#   name = "ecs-execution-role"

#   assume_role_policy = <<EOF
# {
#  "Version": "2012-10-17",
#  "Statement": [
#    {
#      "Action": "sts:AssumeRole",
#      "Principal": {
#        "Service": "ecs-tasks.amazonaws.com"
#      },
#      "Effect": "Allow",
#      "Sid": ""
#    }
#  ]
# }
# EOF
# }
# resource "aws_iam_role" "ecs_task_role" {
#   name = "ecs-task-role"

#   assume_role_policy = <<EOF
# {
#  "Version": "2012-10-17",
#  "Statement": [
#    {
#      "Action": "sts:AssumeRole",
#      "Principal": {
#        "Service": "ecs-tasks.amazonaws.com"
#      },
#      "Effect": "Allow",
#      "Sid": ""
#    }
#  ]
# }
# EOF
# }

# resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment" {
#   role       = aws_iam_role.ecs_task_execution_role.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
# }
# resource "aws_iam_role_policy_attachment" "task_s3" {
#   role       = aws_iam_role.ecs_task_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
# }

# data "aws_iam_policy_document" "ecs_auto_scale_role" {
#   version = "2012-10-17"
#   statement {
#     effect  = "Allow"
#     actions = ["sts:AssumeRole"]

#     principals {
#       type        = "Service"
#       identifiers = ["application-autoscaling.amazonaws.com"]
#     }
#   }
# }

# # ECS auto scale role
# resource "aws_iam_role" "ecs_auto_scale_role" {
#   name               = "EcsAutoScaleRole"
#   assume_role_policy = data.aws_iam_policy_document.ecs_auto_scale_role.json
# }

# # ECS auto scale role policy attachment
# resource "aws_iam_role_policy_attachment" "ecs_auto_scale_role" {
#   role       = aws_iam_role.ecs_auto_scale_role.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceAutoscaleRole"
# }