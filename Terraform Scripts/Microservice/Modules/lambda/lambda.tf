resource "aws_lambda_function" "lambda" {
  filename         = "${path.module}/s3datacopier.zip"
  description      = var.description
  function_name    = var.function_name
  role             = var.role_arn
  handler          = var.handler
  source_code_hash = filebase64sha256("${path.module}/EC2_Tag_Existing.zip")
  runtime          = var.runtime
  timeout          = var.timeout
  memory_size      = var.memory_size
  kms_key_arn      = var.kms_key_arn

  dynamic "file_system_config" {
    for_each = var.access_point_efs != null && var.mount_path != null ? [true] : []
    content {
      arn              = var.access_point_efs #aws_efs_access_point.access_point_for_lambda.arn
      local_mount_path = var.mount_path       # Local mount path inside the lambda function. Must start with '/mnt/'.
    }
  }
  dynamic "vpc_config" {
    for_each = var.subnet_ids != null && var.sg_id != null ? [true] : []
    content {
      subnet_ids         = var.subnet_ids # Every subnet should be able to reach an EFS mount target in the same Availability Zone. Cross-AZ mounts are not permitted.
      security_group_ids = var.sg_id
    }
  }
  dynamic "environment" {
    for_each = length(keys(var.environment_variables)) == 0 ? [] : [true]
    content {
      variables = var.environment_variables
    }
  }

  tags = merge(var.default_tags, tomap({ "Name" = var.function_name }))
  lifecycle { ignore_changes = [source_code_hash] }
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = var.lg_name
  retention_in_days = var.retention_in_days
}