output "target_group_arn" {
  description = "ARN of the target group"
  value       = aws_lb_target_group.efs_file_browser.arn
}

output "container_port" {
  description = "Port of the container"
  value       = local.filebrowser_container_port
}
