resource "aws_ecs_cluster" "test" {
  name = var.name
  tags = var.tags
}