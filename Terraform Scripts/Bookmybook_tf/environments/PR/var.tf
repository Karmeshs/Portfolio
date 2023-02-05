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
