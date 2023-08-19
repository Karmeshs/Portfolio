# Data variables
variable "subnet" {}
variable "subnet_names" {}

#------------------------------------------------------------------------------------------------------------------#
# Tag variables

variable "default_tags" {}

### IAM role policy
variable "role_name_ecs_execution" {}
variable "service_ecs_execution" {}

variable "policy_name_ecs_execution" {}
variable "policy_description_ecs_execution" {}

### kms for s3 
variable "enable_key_rotation" {}
variable "kmskey" {}

#Lambda role and policy
variable "service_lambda" {}
variable "policy_description_lambda" {}
variable "role_name_lambda" {}
variable "policy_name_lambda" {}

#s3
variable "bucket_name" {}
variable "folder_name" {}
variable "retention_s3" {}

#STF
variable "role_name_stf" {}
variable "service_stf" {}
variable "policy_name_stf" {}
variable "policy_description_stf" {}

#scheduler
variable "role_name_scheduler" {}
variable "service_scheduler" {}

variable "policy_name_scheduler" {}
variable "policy_description_scheduler" {}

####################################################################

#ecr
variable "ecr_name" {}

#sg ecs
variable "sg_name" {}
variable "ingress" {}
variable "egress" {}

#ECS CLUSTER
variable "cluster_name" {}
variable "cluster_monitoring" {}
variable "cluster_monitoring_switch" {}

#ecs
variable "cname" {}
variable "port" {}
variable "cpucontainer" {}
variable "memorycontainer" {}

variable "log_group_name" {}

variable "family" {}
variable "req_comp" {}
variable "cpu" {}
variable "memory" {}
variable "nmode" {}

variable "servicename" {}
variable "desired_count" {}
variable "assign_public_ip" {}
variable "launch-type" {}
variable "dc-type" {}
## cw log grp
variable "retention" {}


## SQS variables

variable "sqs_name" {}
variable "sqs_visibility_timeout_seconds" {}
variable "sqs_delay_seconds" {}
variable "sqs_max_message_size" {}
variable "sqs_message_retention_seconds" {}
variable "sqs_receive_wait_time_seconds" {}
variable "sqs_max_receive_count" {}


## DLQ variables

variable "dlq_name" {}
variable "dlq_visibility_timeout_seconds" {}
variable "dlq_delay_seconds" {}
variable "dlq_max_message_size" {}
variable "dlq_message_retention_seconds" {}
variable "dlq_receive_wait_time_seconds" {}

### ASG
variable "max_capacity" {}
variable "min_capacity" {}
variable "scalable_dimension" {}
variable "service_namespace" {}

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

### CW alarm for ecs asg
variable "alarm_name_down" {}
variable "alarm_name_up" {}
variable "comp_operator_up" {}
variable "comp_operator_down" {}
variable "metric_name" {}
variable "namespace" {}
variable "evaluation_periods" {}
variable "period" {}
variable "statistic" {}
variable "threshold_up" {}
variable "threshold_down" {}
variable "alarm_description_up" {}
variable "alarm_description_down" {}

#secrets manager
variable "name_secret" {}
variable "Secret_Recovery_Window_In_Days" {}
variable "description" {}
variable "secrets" {}
#s3
variable "prefix" {}

#Lambda
variable "function_name" {}
variable "function_description" {}
variable "handler" {}
variable "runtime" {}
variable "memory_size" {}
variable "timeout" {}

### Lambda log group
variable "retention_in_days" {}
variable "lg_name" {}
### Lambda permission
variable "statement_id_perm" {}
variable "principal_perm" {}
#Lambda EFS mount
variable "mount_path" {}
variable "access_point_efs" {}
#step function
variable "stf_name" {}

#scheduler
variable "cron" {}
variable "target_arn" {}
variable "scheduler_name" {}
variable "report_type" {}
