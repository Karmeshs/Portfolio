#Security group
resource "aws_security_group" "SecurityGroupecs" {
  name   = var.sg_name
  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress
    content {
      from_port       = ingress.value.from_port
      to_port         = ingress.value.to_port
      protocol        = ingress.value.protocol
      cidr_blocks     = ingress.value.cidr_blocks
      description     = ingress.value.description
      prefix_list_ids = ingress.value.prefix_list
    }
  }
  dynamic "egress" {
    for_each = var.egress
    content {
      from_port       = egress.value.from_port
      to_port         = egress.value.to_port
      protocol        = egress.value.protocol
      cidr_blocks     = egress.value.cidr_blocks
      description     = egress.value.description
      prefix_list_ids = egress.value.prefix_list
    }
  }
  tags = merge(var.default_tags, tomap({ "Name" = var.sg_name }))
}
