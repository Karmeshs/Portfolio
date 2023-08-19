#ECS Cluster
resource "aws_ecs_cluster" "cluster" {
  name = var.name
  setting {
    name  = var.ciname
    value = var.value
  }
  tags = merge(var.default_tags_cluster, tomap({ "Name" = var.name }))
}

