locals {
  asics_auth_client_secret     = format("arn:aws:ssm:eu-west-1:%s:parameter/ecs/%s/asics_auth_client_secret", var.account_ids, local.gtw_service_name)
  conntentstack_delivery_token = format("arn:aws:ssm:eu-west-1:%s:parameter/ecs/%s/conntentstack_delivery_token", var.account_ids, local.bff_service_name)
}

module "iam" {
  source                       = "./modules/iam"
  asics_auth_client_secret     = local.asics_auth_client_secret
  conntentstack_delivery_token = local.conntentstack_delivery_token
  kms_key                      = data.aws_kms_key.ssm_key_id.arn
}