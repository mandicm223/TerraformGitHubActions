variable "cidr_block" {
  description = "The CIDR block for the VPC"
  default     = "172.17.0.0/16"
}

variable "subnet_count" {
  description = "Number of subnets to create"
  default     = 2
}