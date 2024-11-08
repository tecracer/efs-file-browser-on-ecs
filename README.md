# EFS File Browser on ECS

A web-based file browser service running on AWS ECS (Elastic Container Service) that provides a user-friendly interface to browse and manage files stored in Amazon EFS (Elastic File System.


It deploys [Filebrowser](https://filebrowser.org/) in a standard configuration.

## Example
```terraform
module "efs_file_browser" {
  source = "github.com/hashicorp/tecracer/efs-file-browser-on-ecs&ref=v1.0.0"

  name_prefix                   = "application-xyz"
  enable_execute_command        = true
  ecs_cluster_arn               = aws_ecs_cluster.this.arn
  cloudwatch_log_group_name     = aws_cloudwatch_log_group.this.name
  aws_region                    = data.aws_region.current.name
  container_image_label         = "latest"
  filebrowser_username          = "admin"
  filebrowser_password          = "password"
  alb_arn                       = aws_lb.this.arn
  enable_https                  = true
  alb_listener_port             = "443"
  alb_listener_certificate_arn  = aws_acm_certificate_validation.this.certificate_arn
  alb_whitelist_own_ip          = true
  alb_ip_whitelist              = [0.0.0.0/0]
  efs_file_system_id            = aws_efs_file_system.this.id
  access_point_id               = aws_efs_access_point.this.id
  vpc_id                        = aws_vpc.this.id
  subnet_ids                    = local.private_subnet_ids
  ecs_service_security_group_id = aws_security_group.ecs_service.id
  task_execution_role_arn       = aws_iam_role.execution.arn
  task_role_arn                 = aws_iam_role.task.arn
  cpu                           = 1024
  memory                        = 2048
}
```
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.74 |
| <a name="requirement_http"></a> [http](#requirement\_http) | ~> 3.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.74 |
| <a name="provider_http"></a> [http](#provider\_http) | ~> 3.4 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ecs_service_efs_file_browser"></a> [ecs\_service\_efs\_file\_browser](#module\_ecs\_service\_efs\_file\_browser) | terraform-aws-modules/ecs/aws//modules/service | 5.11.4 |

## Resources

| Name | Type |
|------|------|
| [aws_lb_listener.efs_file_browser](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener_rule.efs_file_browser](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_lb_target_group.efs_file_browser](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [http_http.myip](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_point_id"></a> [access\_point\_id](#input\_access\_point\_id) | ID of the EFS access point | `string` | n/a | yes |
| <a name="input_alb_arn"></a> [alb\_arn](#input\_alb\_arn) | ARN of the ALB | `string` | n/a | yes |
| <a name="input_alb_ip_whitelist"></a> [alb\_ip\_whitelist](#input\_alb\_ip\_whitelist) | List of IP addresses to whitelist | `list(string)` | `[]` | no |
| <a name="input_alb_listener_certificate_arn"></a> [alb\_listener\_certificate\_arn](#input\_alb\_listener\_certificate\_arn) | ARN of the ACM certificate for the LB listener | `string` | n/a | yes |
| <a name="input_alb_listener_port"></a> [alb\_listener\_port](#input\_alb\_listener\_port) | Port of the LB listener | `number` | n/a | yes |
| <a name="input_alb_whitelist_own_ip"></a> [alb\_whitelist\_own\_ip](#input\_alb\_whitelist\_own\_ip) | Whether to whitelist the current IP of the host executing the terraform code | `bool` | `false` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | n/a | yes |
| <a name="input_cloudwatch_log_group_name"></a> [cloudwatch\_log\_group\_name](#input\_cloudwatch\_log\_group\_name) | Name of the CloudWatch log group | `string` | n/a | yes |
| <a name="input_container_image_label"></a> [container\_image\_label](#input\_container\_image\_label) | Label of the container image | `string` | `"latest"` | no |
| <a name="input_cpu"></a> [cpu](#input\_cpu) | CPU for the file browser | `number` | n/a | yes |
| <a name="input_ecs_cluster_arn"></a> [ecs\_cluster\_arn](#input\_ecs\_cluster\_arn) | ARN of the ECS cluster | `string` | n/a | yes |
| <a name="input_ecs_service_security_group_id"></a> [ecs\_service\_security\_group\_id](#input\_ecs\_service\_security\_group\_id) | ID of the ECS service security group. Needs access to the EFS file system. | `string` | n/a | yes |
| <a name="input_efs_file_system_id"></a> [efs\_file\_system\_id](#input\_efs\_file\_system\_id) | ID of the EFS file system | `string` | n/a | yes |
| <a name="input_enable_execute_command"></a> [enable\_execute\_command](#input\_enable\_execute\_command) | Whether to enable ECS execute command | `bool` | `false` | no |
| <a name="input_enable_https"></a> [enable\_https](#input\_enable\_https) | Whether to enable HTTPS | `bool` | `true` | no |
| <a name="input_filebrowser_password"></a> [filebrowser\_password](#input\_filebrowser\_password) | Password for the file browser | `string` | n/a | yes |
| <a name="input_filebrowser_username"></a> [filebrowser\_username](#input\_filebrowser\_username) | Username for the file browser | `string` | n/a | yes |
| <a name="input_memory"></a> [memory](#input\_memory) | Memory for the file browser | `number` | n/a | yes |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Name prefix of the application | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs | `list(string)` | n/a | yes |
| <a name="input_task_execution_role_arn"></a> [task\_execution\_role\_arn](#input\_task\_execution\_role\_arn) | ARN of the task execution role | `string` | n/a | yes |
| <a name="input_task_role_arn"></a> [task\_role\_arn](#input\_task\_role\_arn) | ARN of the task role. Needs permissions to access the EFS file system. | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_container_port"></a> [container\_port](#output\_container\_port) | Port of the container |
| <a name="output_target_group_arn"></a> [target\_group\_arn](#output\_target\_group\_arn) | ARN of the target group |
<!-- END_TF_DOCS -->