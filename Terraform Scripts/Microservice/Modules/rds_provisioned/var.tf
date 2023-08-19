variable "default_tags" {}
#subnet grp
variable "subnet_group_name" {}
variable "subnet_ids" {}
#SG
variable "sg_name" {}
variable "vpc_id" {}
# rds cluster
variable "cluster_name" {}
variable "backup_retention" {}
variable "password" {}
variable "username" {}
variable "db_name" {}
variable "maintenance_window" {}
variable "backup_window" {}
variable "engine" {}
variable "engine_version" {}
#variable "snapshot" {}
# rds instance
variable "instance_name" {}
variable "instance_class" {}

#KMS
variable "kmskey" {}

#Param grp
variable "rpcg_name" {}
variable "rpg_name" {}
variable "family" {}
#LOG grp
variable "retention" {}
