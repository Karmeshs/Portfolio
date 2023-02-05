module "ecs" {
  source = "../../modules/ecs"
  count  = length(var.ecs_name)
  tags   = var.tags
  # Task definition
  family        = var.family[count.index]
  policy        = data.template_file.taskdef[count.index].rendered
  exec_role_arn = data.aws_iam_role.taskrole.arn

  #ECS
  name                       = var.ecs_name[count.index]
  cluster                    = data.aws_ecs_cluster.cluster.id
  desired_count              = var.desired_count
  propagate_tags             = var.propagate_tags
  deployment_maximum_percent = var.deployment_maximum_percent
  deployment_minimum_percent = var.deployment_minimum_percent
  # ordered_placement_strategy  ECS
  type  = var.type
  field = var.field
  #log group
  logs_name = var.logs_name[count.index]
  retention = var.retention

}


#Service deployment - TASK PLACEMENT BINPACK CPU  Min 0% max 100%

