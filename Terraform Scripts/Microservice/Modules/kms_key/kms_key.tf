resource "aws_kms_key" "kms_key" {
  description         = "CMK for encryption"
  enable_key_rotation = var.enable_key_rotation
  policy              = var.template
  tags                = merge(var.tags, tomap({ "Name" = var.kmskey }))
}
#kms alias
resource "aws_kms_alias" "kms_alias" {
  name          = "alias/${var.kmskey}"
  target_key_id = aws_kms_key.kms_key.key_id
}
