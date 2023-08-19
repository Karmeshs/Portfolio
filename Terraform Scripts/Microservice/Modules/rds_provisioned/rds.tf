##### RDS security group

resource "aws_security_group" "rds_sg" {
  name        = var.sg_name
  vpc_id      = var.vpc_id
  description = "SG RDS"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "TCP"
    cidr_blocks = ["172.196.0.0/16"]
    description = "Inbound calls from specific range"
  }
  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "TCP"
    cidr_blocks = ["172.196.0.0/16"]
  }
  tags = merge(var.default_tags, tomap({ "Name" = var.sg_name }))
}
resource "aws_db_subnet_group" "subnet_group" {
  name        = var.subnet_group_name
  description = "Subnet Group RDS"
  subnet_ids  = var.subnet_ids
  tags        = merge(var.default_tags, tomap({ "Name" = var.subnet_group_name }))
}

resource "aws_rds_cluster" "postgresql" {
  cluster_identifier              = var.cluster_name
  engine                          = var.engine
  engine_version                  = var.engine_version
  preferred_backup_window         = var.backup_window
  preferred_maintenance_window    = var.maintenance_window
  availability_zones              = ["us-west-1a", "us-west-1b", "us-west-1c"]
  database_name                   = var.db_name
  master_username                 = var.username
  master_password                 = var.password
  db_subnet_group_name            = aws_db_subnet_group.subnet_group.name
  vpc_security_group_ids          = [aws_security_group.rds_sg.id]
  backup_retention_period         = var.backup_retention #1
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.pg.name
  deletion_protection             = "true"
  copy_tags_to_snapshot           = "true"
  tags                            = merge(var.default_tags, tomap({ "Name" = var.cluster_name }))
  storage_encrypted               = "true"
  kms_key_id                      = var.kmskey
  enabled_cloudwatch_logs_exports = ["postgresql"]
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  identifier                   = var.instance_name
  cluster_identifier           = aws_rds_cluster.postgresql.id
  instance_class               = var.instance_class
  engine                       = var.engine
  engine_version               = var.engine_version
  preferred_maintenance_window = var.maintenance_window
  db_parameter_group_name      = aws_db_parameter_group.pg.name
  tags                         = merge(var.default_tags, tomap({ "Name" = var.instance_name }))
}
resource "aws_rds_cluster_parameter_group" "pg" {
  name   = var.rpcg_name
  family = var.family
  tags   = merge(var.default_tags, tomap({ "Name" = var.rpcg_name }))
}

resource "aws_db_parameter_group" "pg" {
  name   = var.rpg_name
  family = var.family
  tags   = merge(var.default_tags, tomap({ "Name" = var.rpg_name }))
}
resource "aws_cloudwatch_log_group" "rds_log_group" {
  name              = "/aws/rds/cluster/${var.cluster_name}/postgresql"
  retention_in_days = var.retention
}