#----------------------------ROLES & POLICIES -----------------------------------------------------#
## Role-ECS execution
module "ecs_execution_role" {
  source       = "../../modules/iam_role"
  default_tags = var.default_tags
  role_name    = var.role_name_ecs_execution
  service      = var.service_ecs_execution
}
## Policy-ECS execution
module "ecs_execution_policy" {
  source             = "../../modules/iam_policy"
  default_tags       = var.default_tags
  policy_name        = var.policy_name_ecs_execution
  policy_description = var.policy_description_ecs_execution
  policy_template    = data.template_file.policy_ecstaskexecution_template.rendered
}
## PolicyAttachment-ECS execution
module "ecs_execution_policy_attach1" {
  source     = "../../modules/iam_policy_attach"
  policy_arn = module.ecs_execution_policy.policy_arn
  role_arn   = module.ecs_execution_role.role_id
}
### Role-lambda
module "lambda_role_2" {
  source       = "../../modules/iam_role"
  default_tags = var.default_tags
  role_name    = var.role_name_lambda[0]
  service      = var.service_lambda
}
## Policy-lambda
module "lambda_policy_2" {
  source             = "../../modules/iam_policy"
  default_tags       = var.default_tags
  policy_name        = var.policy_name_lambda[0]
  policy_description = var.policy_description_lambda
  policy_template    = data.template_file.policy_lambda_2.rendered
}
## PolicyAttachment-Lambda
module "lambda_policy_attach1" {
  source     = "../../modules/iam_policy_attach"
  policy_arn = module.lambda_policy_2.policy_arn
  role_arn   = module.lambda_role_2.role_id
}
module "lambda_policy_attach2" {
  source     = "../../modules/iam_policy_attach"
  policy_arn = data.aws_iam_policy.AWSLambdaVPCAccessExecutionRole.arn
  role_arn   = module.lambda_role_2.role_id
}

### Role-lambda Request -response
module "lambda_role" {
  source       = "../../modules/iam_role"
  default_tags = var.default_tags
  role_name    = var.role_name_lambda[1]
  service      = var.service_lambda
}
## Policy-lambda
module "lambda_policy" {
  source             = "../../modules/iam_policy"
  default_tags       = var.default_tags
  policy_name        = var.policy_name_lambda[1]
  policy_description = var.policy_description_lambda
  policy_template    = data.template_file.policy_lambda.rendered
}
## PolicyAttachment-Lambda
module "lambda_policy_attach" {
  source     = "../../modules/iam_policy_attach"
  policy_arn = module.lambda_policy.policy_arn
  role_arn   = module.lambda_role.role_id
}
## Role-scheduler
module "scheduler_role" {
  source       = "../../modules/iam_role"
  default_tags = var.default_tags
  role_name    = var.role_name_scheduler
  service      = var.service_scheduler
}
## Policy-scheduler
module "scheduler_policy" {
  source             = "../../modules/iam_policy"
  default_tags       = var.default_tags
  policy_name        = var.policy_name_scheduler
  policy_description = var.policy_description_scheduler
  policy_template    = data.template_file.scheduler.rendered
}
## PolicyAttachment-scheduler
module "scheduler_policy_attach" {
  source     = "../../modules/iam_policy_attach"
  policy_arn = module.scheduler_policy.policy_arn
  role_arn   = module.scheduler_role.role_id
}
## Role-step_function
module "stf_role" {
  source       = "../../modules/iam_role"
  default_tags = var.default_tags
  role_name    = var.role_name_stf
  service      = var.service_stf
}
## Policy-stf
module "stf_policy" {
  source             = "../../modules/iam_policy"
  default_tags       = var.default_tags
  policy_name        = var.policy_name_stf
  policy_description = var.policy_description_stf
  policy_template    = data.template_file.step_function.rendered
}
## PolicyAttachment-stf
module "stf_policy_attach" {
  source     = "../../modules/iam_policy_attach"
  policy_arn = module.stf_policy.policy_arn
  role_arn   = module.stf_role.role_id
}
#----------------------------SECURITY RESOURCES -----------------------------------------------------#
## KMS for SQS
module "kms_key" {
  source              = "../../modules/kms_key"
  template            = data.template_file.policy.rendered
  enable_key_rotation = var.enable_key_rotation
  kmskey              = var.kmskey
  tags                = var.default_tags
}

#************************************* S3 and related resources ***************************************#

## S3 for storage and triggering lambda
module "s3" {
  source       = "../../modules/s3"
  bucket_name  = var.bucket_name
  default_tags = var.default_tags
  kms_key_arn  = module.kms_key.key_arn 
  retention    = var.retention_s3
}

module "s3_folder" {
  source      = "../../modules/s3_folder"
  count       = length(var.folder_name)
  bucket_name = module.s3.bucket_id 
  folder_name = var.folder_name[count.index]
}
#******************************************************************************************

## ECS & RELATED----------------------------------------------------------------------------
#module for ecr
module "ecr" {
  source       = "../../Modules/ecr"
  count        = length(var.ecr_name)
  ecr_name     = var.ecr_name[count.index] ##
  default_tags = var.default_tags
}

# ecs sg
module "sg" {
  source       = "../../Modules/sg"
  count        = length(var.sg_name)
  vpc_id       = data.aws_vpc.vpc_id.id
  default_tags = var.default_tags
  sg_name      = var.sg_name[count.index]
  ingress      = var.ingress[count.index]
  egress       = var.egress[count.index]
}

# #ECS
module "Cluster" {
  source               = "../../Modules/Cluster"
  count                = length(var.cluster_name)
  name                 = var.cluster_name[count.index] ##
  ciname               = var.cluster_monitoring
  value                = var.cluster_monitoring_switch
  default_tags_cluster = var.default_tags
}

module "ecs" {
  source       = "../../Modules/ecs"
  count        = length(var.servicename)
  default_tags = var.default_tags
  ###task def
  family       = var.family[count.index] ##
  req_comp     = var.req_comp
  cpu          = var.cpu
  memory       = var.memory
  exe_role_arn = module.ecs_execution_role.role_arn
  nmode        = var.nmode
  policy       = data.template_file.policy[count.index].rendered

  ### Service
  servicename      = var.servicename[count.index]                                                                                                                                     ##
  clusterid        = endswith(var.servicename[count.index], "-02") || endswith(var.servicename[count.index], "manual-01") ? module.Cluster[1].clusterid : module.Cluster[0].clusterid ##
  desired_count    = var.desired_count[count.index]                                                                                                                                   ##
  subnet_ids       = [data.aws_subnet.subnets[0].id, data.aws_subnet.subnets[1].id, data.aws_subnet.subnets[2].id]
  sg_ids           = [module.sg[0].sg_id] ##
  assign_public_ip = var.assign_public_ip
  launch-type      = var.launch-type
  dc-type          = var.dc-type

  ### Log group
  retention = var.retention
  logs      = var.log_group_name[count.index] ##
}

##------------ SQS-1------------

module "sqs" {
  source = "../../Modules/sqs"
  count  = length(var.sqs_name)
  #Primary SQS
  sqs_name                       = var.sqs_name[count.index]
  sqs_visibility_timeout_seconds = var.sqs_visibility_timeout_seconds[count.index]
  sqs_delay_seconds              = var.sqs_delay_seconds
  sqs_max_message_size           = var.sqs_max_message_size
  sqs_message_retention_seconds  = var.sqs_message_retention_seconds
  sqs_receive_wait_time_seconds  = var.sqs_receive_wait_time_seconds
  #Attribute for dlq attach
  redrive_policy = var.sqs_max_receive_count[count.index] > 0 ? jsonencode({
    deadLetterTargetArn = module.dlq[0].dlq_arn
    maxReceiveCount     = var.sqs_max_receive_count[count.index]
  }) : ""
  ##SQS other
  kms_key_id   = module.kms_key.key_arn
  default_tags = var.default_tags
}

module "dlq" {
  source = "../../Modules/dlq"
  count  = length(var.dlq_name)
  # Dead letter Queues
  dlq_name                       = var.dlq_name[count.index]
  dlq_visibility_timeout_seconds = var.dlq_visibility_timeout_seconds
  dlq_delay_seconds              = var.dlq_delay_seconds
  dlq_max_message_size           = var.dlq_max_message_size
  dlq_message_retention_seconds  = var.dlq_message_retention_seconds
  dlq_receive_wait_time_seconds  = var.dlq_receive_wait_time_seconds
  kms_key_id   = module.kms_key.key_arn
  default_tags = var.default_tags
}

module "sqs_policy" {
  source    = "../../Modules/sqs_policy_attach"
  count     = length(data.template_file.sqs_policy)
  queue_url = [module.sqs[0].id, module.dlq[1].id][count.index]
  policy    = data.template_file.sqs_policy[count.index].rendered
}

module "asg" {
  source = "../../Modules/asg"
  count  = length(var.down_policy_name)
  #autoscaling target
  max_capacity       = var.max_capacity[count.index]
  min_capacity       = var.min_capacity[count.index]
  ecs_iam_role       = data.aws_iam_role.ecsIamRole.arn
  scalable_dimension = var.scalable_dimension
  service_namespace  = var.service_namespace
  clustername        = module.Cluster[count.index].clustername
  servicename        = module.ecs[count.index].ecs_service_name

  # scale down policy
  down_policy_name                 = var.down_policy_name[count.index]
  policy_type                      = var.policy_type
  adjustment_type                  = var.adjustment_type
  down_cooldown                    = var.down_cooldown
  down_metric_aggregation_type     = var.down_metric_aggregation_type
  down_metric_interval_upper_bound = var.down_metric_interval_upper_bound
  down_scaling_adjustment          = var.down_scaling_adjustment

  # scale up policy
  up_policy_name                 = var.up_policy_name[count.index]
  up_cooldown                    = var.up_cooldown
  up_metric_aggregation_type     = var.up_metric_aggregation_type
  up_metric_interval_lower_bound = var.up_metric_interval_lower_bound
  up_scaling_adjustment          = var.up_scaling_adjustment
}

module "ecs_cwa_up" {
  count               = length(var.alarm_name_up)
  source              = "../../Modules/cloudwatch_alarm"
  default_tags        = var.default_tags
  alarm_name          = var.alarm_name_up[count.index]
  comparison_operator = var.comp_operator_up
  evaluation_periods  = var.evaluation_periods
  metric_name         = var.metric_name
  namespace           = var.namespace
  period              = var.period
  statistic           = var.statistic
  threshold           = var.threshold_up
  alarm_description   = var.alarm_description_up
  dimension = {
    QueueName = var.sqs_name[0]
  }
  alarms_actions = module.asg[count.index].scale_policy_cpu_up_arn
}

module "ecs_cwadown" {
  source              = "../../Modules/cloudwatch_alarm"
  count               = length(var.alarm_name_down)
  default_tags        = var.default_tags
  alarm_name          = var.alarm_name_down[count.index]
  comparison_operator = var.comp_operator_down
  evaluation_periods  = var.evaluation_periods
  metric_name         = var.metric_name
  namespace           = var.namespace
  period              = var.period
  statistic           = var.statistic
  threshold           = var.threshold_down
  alarm_description   = var.alarm_description_down
  dimension = {
    QueueName = var.sqs_name[0]
  }
  alarms_actions = module.asg[count.index].scale_policy_cpu_down_arn
}

#secrets manager
module "secrets" {
  source                         = "../../Modules/secrets_manager"
  default_tags                   = var.default_tags
  name_secret                    = var.name_secret
  Secret_Recovery_Window_In_Days = var.Secret_Recovery_Window_In_Days
  secrets                        = var.secrets
  description                    = var.description
}

#************************************* S3 related resources ***************************************#
#### S3 Trigger -> lambda
module "s3_notif_batch" {
  source             = "../../modules/s3_notif"
  bucket_id          = module.s3.bucket_id
  function_notif_arn = module.lambda[0].lambda_arn #
  filter_prefix      = var.prefix
}

##----------------LAmbda----------------#
locals {
  environment_variables = [
    {},
    {},
    {
      sqs_url     = module.sqs[5].url, #Reponse sqs that triggers lambda
      cluster_arn = module.Cluster[0].clusterid,
      ecs_yetty    = var.servicename[2],
      ecs_scooby   = var.servicename[3]
    }
  ]
}
module "lambda" {
  count         = length(var.function_name)
  source        = "../../modules/lambda"
  default_tags  = var.default_tags
  function_name = var.function_name[count.index]
  description   = var.function_description[count.index]
  role_arn      = count.index == 0 ? module.lambda_role_2.role_arn : module.lambda_role.role_arn ############
  handler       = var.handler[count.index]
  memory_size   = var.memory_size[count.index]
  runtime       = var.runtime
  timeout       = var.timeout
  kms_key_arn   = module.kms_key.key_arn
  #EFS CONFIG look for EFS ARN
  mount_path       = var.mount_path[count.index]
  access_point_efs = var.access_point_efs
  # VPC config
  subnet_ids = [data.aws_subnet.subnets[0].id, data.aws_subnet.subnets[1].id, data.aws_subnet.subnets[2].id]
  sg_id      = [[module.sg[1].sg_id], null, null][count.index] #############
  #Environment variables
  environment_variables = local.environment_variables[count.index]
  ## Log group
  lg_name           = var.lg_name[count.index]
  retention_in_days = var.retention_in_days
}
module "lambda_perms" {
  count         = length(var.function_name)
  source        = "../../modules/lambda_perms"
  function_name = module.lambda[count.index].function_name
  statement_id  = var.statement_id_perm[count.index]
  principal     = var.principal_perm[count.index]
  source_arn    = [module.s3.bucket_arn, replace(module.stf[0].step_func_arn, "paris", "*"), module.sqs[5].sqs_arn][count.index] ############
}
module "remote-exec" {
  source           = "../../modules/null_resources"
  function_name    = module.lambda[0].function_name
  mount_path       = var.mount_path[0]
  access_point_efs = var.access_point_efs
}
module "lambda_trigger" {
  source           = "../../Modules/lambda_trigger"
  event_source_arn = module.sqs[5].sqs_arn
  function_name    = module.lambda[2].lambda_arn
}

module "stf" {
  source       = "../../modules/step_function"
  count        = length(var.stf_name)
  default_tags = var.default_tags
  definition   = data.template_file.stf[count.index].rendered
  name         = var.stf_name[count.index]
  role_arn     = module.stf_role.role_arn
}

module "scheduler" {
  source         = "../../modules/scheduler"
  count          = length(var.scheduler_name)
  cron           = var.cron[count.index]
  role_arn       = module.scheduler_role.role_arn
  scheduler_name = var.scheduler_name[count.index]
  target_arn     = module.stf[count.index].step_func_arn
  scheduler_input = {
    queue_url       = module.sqs[count.index + 1].url
    report_type     = var.report_type[count.index]
    stateMachineArn = module.stf[count.index].step_func_arn
  }
}
