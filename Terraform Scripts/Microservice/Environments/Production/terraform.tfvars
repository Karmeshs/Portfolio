# For data block
subnet = {
  sub1    = "subnet-paris-prod-a"
  sub2    = "subnet-paris-prod-b"
}
subnet_names = ["sub1", "sub2"] 

# Tags
default_tags = {
  AppName      = "paris"
  AppAcronym   = "paris"
  ManagedBy            = "Roterdam"
  Environment          = "production"
}
### IAM role policy
role_name_service_execution = "role-prod-ecs-amsterdam"
service_service_execution   = "ecs-tasks.amazonaws.com"

policy_name_service_execution        = "policy-ecs-prod-amsterdam"
policy_description_service_execution = "Policy for ECS task execution"

# kms for sqs
enable_key_rotation = "true"
kmskey              = "kms-paris-prod-amsterdam-01"

#Lambda role 
service_lambda            = "lambda.amazonaws.com"
policy_description_lambda = "Policy for Lambda"

role_name_lambda   = ["role-lambda-prod-amsterdam", "role-LambdaReq-prod-amsterdam"]
policy_name_lambda = ["policy-lambda-prod-amsterdam", "policy-LambdaReq-prod-amsterdam"]

## S3 for storage and triggering lambda
bucket_name  = "s3bucket-paris-prod-amsterdam-01"
retention_s3 = "7"

#s3_folder
folder_name = ["prod/", "prod/in/", "prod/out", "prod/logs/"]

#Step function
role_name_stf          = "role-StepFunc-prod-amsterdam"
policy_name_stf        = "policy-StepFunc-prod-amsterdam"
service_stf            = "states.amazonaws.com"
policy_description_stf = "Policy for state function execution"

#Scheduler
role_name_scheduler          = "role-scheduler-prod-amsterdam"
policy_name_scheduler        = "policy-InvokeStepFunc-prod-amsterdam"
service_scheduler            = "scheduler.amazonaws.com"
policy_description_scheduler = "Policy scheduler to start stf exec"

#####################################################################################################

#ecr
ecr_name = [
  "paris-prod-amsterdam-01",
]

#ecs sg
sg_name = ["secg-paris-prod-amsterdam-01", "secg-paris-prod-amsterdam-02"]
ingress = [
  [
  ],
  [
    {
      from_port   = 8080,
      to_port     = 8080,
      protocol    = "TCP",
      description = "specific range",
      cidr_blocks = ["172.196.0.0/16"],
      prefix_list = []
    }
  ]
]
#List of Lists where First sublist is for ecs-sg & second is for lambda-sg
egress = [
  [
    {
      from_port   = 0,
      to_port     = 65535,
      protocol    = "tcp",
      description = "ALL allowed",
      cidr_blocks = ["0.0.0.0/0"],
      prefix_list = []
    }
  ],
  [
    {
      from_port   = 0,
      to_port     = 0,
      prodotocol    = "-1",
      description = "All ips",
      cidr_blocks = ["0.0.0.0/0"],
      prodefix_list = []
    }
  ]
]

#ecs cluster
cluster_name              = ["cluster-paris-prod-amsterdam-01", "cluster-paris-prod-amsterdam-02"]
cluster_monitoring        = "containerInsights"
cluster_monitoring_switch = "enabled"

#ecs
### task def
cpu    = "1024"
memory = "4096"
family = [
  "task-paris-prod-amsterdam-01",
  "task-paris-prod-amsterdam-02",
  "task-paris-prod-amsterdam-yetty-01",
  "task-paris-prod-amsterdam-scooby-01",
  "task-paris-prod-amsterdam-manual-01"
]
req_comp = ["FARGATE"]
nmode    = "awsvpc"

### Service
servicename = [
  "service-paris-prod-amsterdam-01",
  "service-paris-prod-amsterdam-02",
  "service-paris-prod-amsterdam-yetty-01",
  "service-paris-prod-amsterdam-scooby-01",
  "service-paris-prod-amsterdam-manual-01"
]
desired_count    = ["2", "1", "2", "2", "1"]
assign_public_ip = "false"
launch-type      = "FARGATE"
dc-type          = "ECS"

### Log_group ecs
log_group_name = [
  "/service/task-paris-prod-amsterdam-01",
  "/service/task-paris-prod-amsterdam-02",
  "/service/task-paris-prod-amsterdam-yetty-01",
  "/service/task-paris-prod-amsterdam-scooby-01",
  "/service/task-paris-prod-amsterdam-manual-01"
]
retention = "7"

### data.tf policy
cname = [
  "ctr-paris-prod-amsterdam-01",
  "ctr-paris-prod-amsterdam-02",
  "ctr-paris-prod-amsterdam-yetty-01",
  "ctr-paris-prod-amsterdam-scooby-01",
  "ctr-paris-prod-amsterdam-manual-01"
]
cpucontainer    = "1024"
memorycontainer = "4096"
port            = "8008"

#### SQS

sqs_name = [
  "queue-paris-prod-amsterdam-01",
  "queue-paris-prod-amsterdam-yetty-01",
  "queue-paris-prod-amsterdam-scooby-01",
  "queue-paris-prod-amsterdam-queen-01",
  "queue-paris-prod-amsterdam-svs-01",
  "queue-paris-prod-amsterdam-resp-01",
  "queue-paris-prod-amsterdam-async-yetty-01",
  "queue-paris-prod-amsterdam-async-scooby-01",
  "queue-paris-prod-amsterdam-async-queen-01",
  "queue-paris-prod-amsterdam-async-svs-01"
]
sqs_visibility_timeout_seconds = ["1500", "240", "240", "240", "240", "240", "240", "240", "240", "240"]
sqs_delay_seconds              = "0"      
sqs_max_message_size           = "262144" #256kb
sqs_message_retention_seconds  = "172800" 
sqs_receive_wait_time_seconds  = "0"      
sqs_max_receive_count          = [6, 0, 0, 0, 0, 0, 0, 0, 0, 0]

## DLQ-1 VARIABLES DECLARED

dlq_name = [
  "queue-paris-prod-amsterdam-dlq-01",
  "queue-paris-prod-amsterdam-dlq-sns-01",
  "queue-paris-prod-amsterdam-dlq-02"
]
dlq_visibility_timeout_seconds = "240"
dlq_delay_seconds              = "1"
dlq_max_message_size           = "262144"
dlq_message_retention_seconds  = "846000" 
dlq_receive_wait_time_seconds  = "0"

#-------------------------------------------------------------------------------------------------
####### App autoscaling target - web
max_capacity       = ["4", "0"]
min_capacity       = ["1", "0"]
scalable_dimension = "ecs:service:DesiredCount"
service_namespace  = "ecs"

######## Scale down policy
down_policy_name                 = ["down-paris-prod-amsterdam-01", "down-paris-prod-amsterdam-02"]
policy_type                      = "StepScaling"
adjustment_type                  = "ChangeInCapacity"
down_cooldown                    = "600"
down_metric_aggregation_type     = "Average"
down_metric_interval_upper_bound = "0"
down_scaling_adjustment          = "-1"
#-------------------------------------------------------------------------------------------------
######## Scale up policy
up_policy_name                 = ["up-paris-prod-amsterdam-01", "up-paris-prod-amsterdam-02"]
up_cooldown                    = "600"
up_metric_aggregation_type     = "Average"
up_metric_interval_lower_bound = "0"
up_scaling_adjustment          = "1"
###### CW alarm for ecs asg
alarm_name_down        = ["alarm-paris-prod-amsterdam-scaledown-01", "alarm-paris-prod-amsterdam-scaledown-02"]
alarm_name_up          = ["alarm-paris-prod-amsterdam-scaleup-01", "alarm-paris-prod-amsterdam-scaleup-02"]
comp_operator_up       = "GreaterThanOrEqualToThreshold"
comp_operator_down     = "LessThanOrEqualToThreshold"
metric_name            = "ApprodoximateNumberOfMessagesVisible"
namespace              = "AWS/SQS"
evaluation_periods     = "3"
period                 = "420"
statistic              = "Average"
threshold_up           = "7000"
threshold_down         = "2000"
alarm_description_up   = "Msgs >= 7000 for 3 points in 21 minutes"
alarm_description_down = "Msgs <= 2000 for 3 points in 21 minutes"

#secrets manager
name_secret                    = "screts-paris-prod-amsterdam-01"
Secret_Recovery_Window_In_Days = "0"
description                    = "Secrets for app"
secrets = {
  "name" : "Prod_DB_main",
  "db_type" : "mysql",
  "writer_endpoint" : "ds_Prod_DB_main.cluster-g7lk1gg5arpo.us-east-1.rds.amazonaws.com"
}
#s3_folder
prodefix = "prod/in"

### Lambda
function_name = [
  "lambda-paris-prod-amsterdam-transferer-01",
  "lambda-paris-prod-amsterdam-classifier-01",
  "lambda-paris-prod-amsterdam-verifier-01"
]
function_description = [
  "transfer the data from bucket to file sys",
  "classify app outputs",
  "verify app outputs"
] 
handler = [
  "transferer.lambda_handler",
  "classifier.lambda_handler",
  "verifier.lambda_handler"
] 
memory_size = ["512", "256", "256"]
runtime     = "python3.9"
timeout     = "360"
### Lambda log group
retention_in_days = "21"
lg_name = [
  "/aws/lambda/lambda-paris-prod-amsterdam-transferer-01",
  "/aws/lambda/lambda-paris-prod-amsterdam-classifier-01",
  "/aws/lambda/lambda-paris-prod-amsterdam-verifier-01"
]

### Lambda permission
statement_id_perm = ["AllowExecS3", "AllowExecStepFunc", "AllowExecSQS"]
prodincipal_perm    = ["s3.amazonaws.com", "states.amazonaws.com", "sqs.amazonaws.com"]
mount_path        = ["/mnt/home", null, null]
access_point_efs  = "arn:aws:elasticfilesystem:us-east-1:183625455214:access-point/fsap-856eac70a34cd1289"

#STep functionn
stf_name = [
  "stf-paris-prod-amsterdam-01",
  "stf-paris-prod-scooby-01"
]

#SCH
scheduler_name = [
  "cwr-paris-prod-amsterdam-yetty-01",
  "cwr-paris-prod-amsterdam-scooby-01"
]
cron = [
  "cron(14/30 7-18 ? * * *)",
  "cron(44/0 5-22 ? * 1-6 *)"
]
target_arn = "arn:aws:scheduler:::aws-sdk:sfn:startExecution"
report_type = [
  "YETTY",
  "SCOOBY"
]