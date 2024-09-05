module "asics_cluster" {
  source       = "./modules/ecs-cluster"
  cluster_name = "asics_cluster"
}