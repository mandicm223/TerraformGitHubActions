variable "task_definitions" {
  description = "A list of task definitions to be created."
  type = list(object({
    name          = string
    container_definitions = string
  }))
}

variable "service_definitions" {
  description = "A list of services to be created."
  type = list(object({
    name                 = string
    desired_count        = number
    container_name       = string
    container_port       = number
    target_group_arn     = string
  }))
}

variable "cluster_id" {
  description = "Cluster ID"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "execution_role_arn" {
  description = "List of subnet IDs"
  type        = string
}

variable "sg_id" {
  description = "Security group ID"
  type        = string
}