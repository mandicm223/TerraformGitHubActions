module "vpc" {
  source       = "./modules/vpc"
  cidr_block   = var.cidr_block
  subnet_count = var.subnet_count
}