locals {
  asics_auth_client_secret     = "arn:aws:ssm:eu-west-1:802288441694:parameter/ecs/gtw_service/asics_auth_client_secret"
  conntentstack_delivery_token = "arn:aws:ssm:eu-west-1:802288441694:parameter/ecs/bff_service/conntentstack_delivery_token"
}

module "iam" {
  source                       = "./modules/iam"
  asics_auth_client_secret     = local.asics_auth_client_secret
  conntentstack_delivery_token = local.conntentstack_delivery_token
}