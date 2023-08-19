#Task Definition
resource "aws_ecs_task_definition" "taskdefinition" {
  depends_on               = [aws_cloudwatch_log_group.logs]
  family                   = var.family
  requires_compatibilities = var.req_comp
  cpu                      = var.cpu
  memory                   = var.memory
  task_role_arn            = var.exe_role_arn
  execution_role_arn       = var.exe_role_arn
  network_mode             = var.nmode
  container_definitions    = var.policy
  tags                     = merge(var.default_tags, tomap({ "Name" = var.family }))
}

#ecs service
resource "aws_ecs_service" "service" {
  depends_on      = [aws_ecs_task_definition.taskdefinition]
  name            = var.servicename
  cluster         = var.clusterid
  task_definition = aws_ecs_task_definition.taskdefinition.arn
  desired_count   = var.desired_count
  launch_type     = var.launch-type

  network_configuration {
    subnets          = var.subnet_ids
    assign_public_ip = var.assign_public_ip
    security_groups  = var.sg_ids
  }
  deployment_controller {
    type = var.dc-type
  }
  tags           = merge(var.default_tags, tomap({ "Name" = var.servicename }))
  propagate_tags = "SERVICE"
  lifecycle { ignore_changes = [task_definition] }
}

#cloudwatch log group and log stream
resource "aws_cloudwatch_log_group" "logs" {
  name              = var.logs
  retention_in_days = var.retention
  tags              = merge(var.default_tags, tomap({ "Name" = var.logs }))
}