variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "cicd-demo"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}

variable "container_port" {
  description = "Port exposed by the container"
  type        = number
  default     = 5000
}

variable "app_count" {
  description = "Number of app instances"
  type        = number
  default     = 2
}
variable "private_subnets" {
  type        = list(string)
  description = "List of private subnet IDs to associate with the ECS service"
}
