variable "tags" {}
# ECS
variable "ecs_name" {}
variable "propagate_tags" {}
variable "deployment_maximum_percent" {}
variable "deployment_minimum_percent" {}
variable "type" {}
variable "field" {}
variable "desired_count" {}

#task def
variable "family" {}
#log_gropup
variable "logs_name" {}
variable "retention" {}

#POlicy taskdef data
variable "cname" {}
variable "entrypoint" {}










# variable "tags" {}
# variable "ecr_name" {}
# variable "cluster_name" {}
# variable "role_name" {}
# variable "sg_name" {}
# variable "ecs_name" {}
# variable "family" {}
# # variable "ecs_name2" {}
# # variable "family2" {}
# variable "cname" {}
# variable "logs" {}
# variable "entrypoint" {}