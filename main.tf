locals {
  filebrowser_service_name   = "${var.name_prefix}-file-browser"
  filebrowser_container_name = "efs-filebrowser"
  filebrowser_container_port = 80
}

module "ecs_service_efs_file_browser" {
  source  = "terraform-aws-modules/ecs/aws//modules/service"
  version = "5.11.4"

  create = true

  name        = local.filebrowser_service_name
  cluster_arn = var.ecs_cluster_arn

  cpu    = var.cpu
  memory = var.memory

  enable_execute_command = var.enable_execute_command

  container_definitions = {
    (local.filebrowser_container_name) = {
      cpu       = var.cpu
      memory    = var.memory
      essential = true
      image     = "filebrowser/filebrowser:${var.container_image_label}"

      port_mappings = [
        {
          name          = local.filebrowser_container_name
          containerPort = local.filebrowser_container_port
          hostPort      = local.filebrowser_container_port
          protocol      = "tcp"
        }
      ]

      readonly_root_filesystem = false

      enable_cloudwatch_logging   = true
      create_cloudwatch_log_group = false
      log_configuration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = var.cloudwatch_log_group_name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "efs-filebrowser"
        }
      }

      linux_parameters = {
        capabilities = {
          add  = []
          drop = ["NET_RAW"]
        }
      }

      mount_points = [
        {
          sourceVolume  = "efs"
          containerPath = "/srv"
          readOnly      = false
        },
        {
          sourceVolume  = "app"
          containerPath = "/app"
          readOnly      = false
        }
      ]

      environment = [
        {
          name  = "FB_DATABASE"
          value = "/app/database.db"
        },
        {
          name  = "FB_PASSWORD"
          value = var.filebrowser_password
        },
        {
          name  = "FB_USERNAME"
          value = bcrypt(var.filebrowser_username)
        }
      ]

      memory_reservation = 100
    }
  }

  volume = {
    "efs" = {
      efs_volume_configuration = {
        file_system_id     = var.efs_file_system_id
        transit_encryption = "ENABLED"

        authorization_config = {
          access_point_id = var.access_point_id
          iam             = "ENABLED"
        }
      }
    }
    "app" = {
      name = "app"
    }
  }

  load_balancer = {
    service = {
      target_group_arn = aws_lb_target_group.efs_file_browser.arn
      container_name   = local.filebrowser_container_name
      container_port   = local.filebrowser_container_port
    }
  }

  subnet_ids            = var.subnet_ids
  create_security_group = false
  security_group_ids    = [var.ecs_service_security_group_id]

  create_iam_role           = false
  create_tasks_iam_role     = false
  create_task_exec_iam_role = false

  task_exec_iam_role_arn = var.task_execution_role_arn
  tasks_iam_role_arn     = var.task_role_arn
  iam_role_arn           = var.task_role_arn

}

resource "aws_lb_target_group" "efs_file_browser" {
  name                 = local.filebrowser_service_name
  port                 = local.filebrowser_container_port
  protocol             = "HTTP"
  target_type          = "ip"
  vpc_id               = var.vpc_id
  deregistration_delay = "5"
}

resource "aws_lb_listener" "efs_file_browser_http" {
  count             = var.enable_https ? 0 : 1
  load_balancer_arn = var.alb_arn
  port              = var.alb_listener_port
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "IP not whitelisted"
      status_code  = "200"
    }
  }

  depends_on = [aws_lb_target_group.efs_file_browser]
}

resource "aws_lb_listener" "efs_file_browser_https" {
  count             = var.enable_https ? 1 : 0
  load_balancer_arn = var.alb_arn
  port              = var.alb_listener_port
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.alb_listener_certificate_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "IP not whitelisted"
      status_code  = "200"
    }
  }

  depends_on = [aws_lb_target_group.efs_file_browser]
}


//This rule does allow access to Jenkins for every Source IP in QA and Dev while limiting access to the Jenkins UI in Prod to SEE IPs
resource "aws_lb_listener_rule" "efs_file_browser" {
  listener_arn = var.enable_https ? aws_lb_listener.efs_file_browser_https[0].arn : aws_lb_listener.efs_file_browser_http[0].arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.efs_file_browser.arn
  }
  condition {
    source_ip {
      values = concat(var.alb_ip_whitelist, var.alb_whitelist_own_ip ? ["${chomp(data.http.myip[0].response_body)}/32"] : [])
    }
  }
}

data "http" "myip" {
  count = var.alb_whitelist_own_ip ? 1 : 0
  url   = "https://ipv4.icanhazip.com"
}
