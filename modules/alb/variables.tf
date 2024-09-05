variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}

variable "alb_name" {
  description = "ALB Name"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "sg_id" {
  description = "Security group ID"
  type        = string
}

variable "internal" {
  description = "Internal or Extrnal ALB ( true / false )"
  type        = string
}

variable "tg_port" {
  description = "TG port"
  type        = string
}