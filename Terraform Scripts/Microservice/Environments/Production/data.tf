# # Data block for fetching the VPC ID
data "aws_vpc" "vpc_id" {
  filter {
    name   = "tag:Name"
    values = ["vpc-paris-production"]
  }
}
# Data block for fetching the subnet ID for different subnets
data "aws_subnet" "subnets" {
  vpc_id = data.aws_vpc.vpc_id.id
  count  = length(var.subnet_names)
  tags = {
    Name = lookup(var.subnet, var.subnet_names[count.index])
  }
}
###STF policy
data "template_file" "step_function" {
  template = file("scripts/policy_stepfunc.json")
}
###sch policy
data "template_file" "scheduler" {
  template = file("scripts/policy_scheduler.json")
}
###Lambda datacopier
data "template_file" "policy_lambda_2" {
  template = file("scripts/policy_lambda_2.json")
}
###Lambda Request response
data "template_file" "policy_lambda" {
  template = file("scripts/policy_lambda.json")
}
###ECS Execution
data "template_file" "policy_ecstaskexecution_template" {
  template = file("scripts/policy_ecstaskexecution.json")
}
data "aws_iam_policy" "AWSLambdaVPCAccessExecutionRole" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

### kms policy for sqs
data "template_file" "policy" {
  template = file("scripts/kms_policy.json")
  vars = {
    ecs_role   = var.role_name_ecs_execution
    lmb_role   = var.role_name_lambda[0]
    lmb_role_2 = var.role_name_lambda[1]
  }
}

########################################################################################

#data for ecs
data "template_file" "policy" {
  template = file("scripts/service.json")
  count    = length(var.cname)
  vars = {
    name    = var.cname[count.index]
    port    = var.port
    ecrname = var.ecr_name[count.index]
    cpu     = var.cpucontainer
    memory  = var.memorycontainer
    logs    = var.log_group_name[count.index]
  }
}

data "template_file" "sqs_policy" {
  count    = 2
  template = file("scripts/sqs_policy.json")
  vars = {
    sqs_name = [var.sqs_name[0], var.dlq_name[1]][count.index]
  }
}
#Step func def
data "template_file" "stf" {
  template = file("scripts/stf_definition.json")
  count    = length(var.stf_name)
  vars = {
    timeout      = [3300, 5400, 1350, 450][count.index]
    cluster_name = var.cluster_name[0]
    ecs_name     = var.servicename[count.index + 2]
    lmb_arn      = module.lambda[1].lambda_arn
  }
}

data "aws_iam_role" "ecsIamRole" {
  name = "AWSServiceRoleForApplicationAutoScaling_ECSService"
}