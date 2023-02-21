resource "aws_lambda_function" "lambda" {
  filename         = "${path.module}/s3datacopier.zip"
  description      = var.description
  function_name    = var.function_name
  role             = var.role_arn
  handler          = var.handler
  source_code_hash = filebase64sha256("${path.module}/s3datacopier.zip")
  runtime          = var.runtime
  timeout          = var.timeout
  memory_size      = var.memory_size

  file_system_config {
    arn              = var.access_point_efs #aws_efs_access_point.access_point_for_lambda.arn
    local_mount_path = var.mount_path       # Local mount path inside the lambda function. Must start with '/mnt/'.
  }

  vpc_config {
    subnet_ids         = var.subnet_ids # Every subnet should be able to reach an EFS mount target in the same Availability Zone. Cross-AZ mounts are not permitted.
    security_group_ids = var.sg_id
  }
  tags = merge(var.default_tags, tomap({ "Name" = var.function_name }))
  lifecycle {
    ignore_changes = [
      source_code_hash # file_system_config
    ]
  }
}

resource "aws_lambda_permission" "permission" {
  depends_on = [
    aws_lambda_function.lambda
  ]
  statement_id  = var.statement_id
  action        = "lambda:InvokeFunction"
  function_name = var.function_name
  principal     = var.principal
  source_arn    = var.source_arn
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = var.lg_name
  retention_in_days = var.retention_in_days
}

resource "null_resource" "efs-mount" {
  depends_on = [aws_lambda_function.lambda]
  provisioner "local-exec" {
    interpreter = ["PowerShell", "-Command"]
    command     = <<-EOT
    aws lambda update-function-configuration --function-name ${var.function_name} --file-system-configs Arn=${var.access_point_efs},LocalMountPath=${var.mount_path} --region eu-west-1 --profile parcels-np
  EOT
  }
  #aws lambda update-function-configuration --function-name lmb-parcels-st2-euwe01-hos-fens-s3datacopier-01 --file-system-configs Arn=arn:aws:elasticfilesystem:eu-west-1:528181836254:access-point/fsap-029eac70a34cd3495,LocalMountPath=/mnt/hosfens --region eu-west-1 --profile parcels-np
  #  triggers = {
  #    always_run = timestamp()
  #  }
}