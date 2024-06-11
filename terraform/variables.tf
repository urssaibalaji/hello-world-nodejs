variable "task_execution_role_arn" {
  description = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  type        = string
}

variable "image_url" {
  description = "urssaibalaji/hello-world-nodejs:latest"
  type        = string
}

variable "cluster_name" {
  description = "hello-world-cluster"
  type        = string
  default     = "my-cluster"
}

variable "service_name" {
  description = "hello-world-service"
  type        = string
  default     = "my-service"
}
