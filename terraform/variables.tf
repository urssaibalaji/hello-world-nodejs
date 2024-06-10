variable "aws_region" {
  default = "us-east-1"
}

variable "ecs_cluster_name" {
  default = "hello-world-cluster"
}

variable "service_name" {
  default = "hello-world-service"
}

variable "task_execution_role_arn" {
  description = "The ARN of the task execution role"
}
