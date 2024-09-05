module "gtw_alb" {
  source     = "./modules/alb"
  alb_name   = "gtw-alb"
  tg_name    = format("%s-tg", local.gtw_service_name)
  internal   = false
  tg_port    = var.ports.gtw_service
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.subnet_ids_public
  sg_id      = aws_security_group.gtw_lb.id
}