data "aws_kms_key" "ssm_key_id" {
  key_id = "alias/aws/ssm"
}
