variable "name_prefix" {
  description = "Name prefix of the application"
  type        = string
}

variable "enable_execute_command" {
  description = "Whether to enable ECS execute command"
  type        = bool
  default     = false
}

variable "ecs_cluster_arn" {
  description = "ARN of the ECS cluster"
  type        = string
}

variable "cloudwatch_log_group_name" {
  description = "Name of the CloudWatch log group"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "filebrowser_password" {
  description = "Password for the file browser"
  type        = string
  sensitive   = true
}

variable "filebrowser_username" {
  description = "Username for the file browser"
  type        = string
}

variable "efs_file_system_id" {
  description = "ID of the EFS file system"
  type        = string
}

variable "access_point_id" {
  description = "ID of the EFS access point"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "ecs_service_security_group_id" {
  description = "ID of the ECS service security group. Needs access to the EFS file system."
  type        = string
}

variable "task_execution_role_arn" {
  description = "ARN of the task execution role"
  type        = string
}

variable "task_role_arn" {
  description = "ARN of the task role. Needs permissions to access the EFS file system."
  type        = string
}

variable "cpu" {
  description = "CPU for the file browser"
  type        = number
}

variable "memory" {
  description = "Memory for the file browser"
  type        = number
}

variable "alb_listener_port" {
  description = "Port of the LB listener"
  type        = number
}

variable "alb_listener_certificate_arn" {
  description = "ARN of the ACM certificate for the LB listener"
  type        = string
}

variable "alb_arn" {
  description = "ARN of the ALB"
  type        = string
}

variable "alb_whitelist_own_ip" {
  description = "Whether to whitelist the current IP of the host executing the terraform code"
  type        = bool
  default     = false
}

variable "alb_ip_whitelist" {
  description = "List of IP addresses to whitelist"
  type        = list(string)
  default     = []
}

variable "container_image_label" {
  description = "Label of the container image"
  type        = string
  default     = "latest"
}

variable "enable_https" {
  description = "Whether to enable HTTPS"
  type        = bool
  default     = true
}
