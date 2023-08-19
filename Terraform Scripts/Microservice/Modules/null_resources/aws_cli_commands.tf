resource "null_resource" "efs-mount" {
  provisioner "local-exec" {
    interpreter = ["PowerShell", "-Command"]
    command     = <<-EOT
    aws lambda update-function-configuration --function-name ${var.function_name} --file-system-configs Arn=${var.access_point_efs},LocalMountPath=${var.mount_path} --region us-west-1 --profile paris
  EOT
  }
}