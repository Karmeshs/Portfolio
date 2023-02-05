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








#To create simple ECS with EC2
# module "ecs" {
#   source        = "../../modules/ecs"
#   count         = length(var.ecs_name)
#   name          = var.ecs_name[count.index]
#   family        = var.family[count.index]
#   policy        = data.template_file.taskdef[count.index].rendered
#   cluster       = data.aws_ecs_cluster.cluster.id
#   exec_role_arn = data.aws_iam_role.taskrole.arn
# }




# module "ecr" {
#   source="../../modules/ecr"
#    name = var.ecr_name
#    tags =  var.tags
# }

# module "cluster" {
#   source="../../modules/cluster"
#   name = var.cluster_name
#   tags =  var.tags
# }

# module "instance_role" {
#   source="../../modules/ecs-instance-profile "
#   name = var.role_name
#   #tags =  var.tags
# }

# module "ecs-sg" {
#   source="../../modules/ecs-sg"
#    name = var.sg_name
#    tags =  var.tags
# }

# module "asg" {
#   source="../../modules/asg"
#    sg_id =  [module.ecs-sg.id]
#    instance_profile = module.instance_role.id
# }
# module "ecs2" {
#   source="../../modules/ecs"
#   name = var.ecs_name2
#   family = var.family2
#    cluster = module.cluster.name
# }




