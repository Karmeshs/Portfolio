resource "aws_ecr_repository" "worker" {
  name = var.name
  tags = var.tags
}