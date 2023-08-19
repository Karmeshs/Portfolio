variable "max_capacity" {}
variable "min_capacity" {}
variable "ecs_iam_role" {}
variable "scalable_dimension" {}
variable "service_namespace" {}
variable "clustername" {}
variable "servicename" {}

variable "down_policy_name" {}
variable "policy_type" {}
variable "adjustment_type" {}
variable "down_cooldown" {}
variable "down_metric_aggregation_type" {}
variable "down_metric_interval_upper_bound" {}
variable "down_scaling_adjustment" {}

variable "up_policy_name" {}
variable "up_cooldown" {}
variable "up_metric_aggregation_type" {}
variable "up_metric_interval_lower_bound" {}
variable "up_scaling_adjustment" {}
