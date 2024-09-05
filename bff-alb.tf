module "bff_alb" {
  source     = "./modules/alb"
  alb_name   = "bff-alb"
  tg_name    = format("%s-tg", local.bff_service_name)
  internal   = true
  tg_port    = var.ports.bff_service
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.subnet_ids_private
  sg_id      = aws_security_group.lb.id
}