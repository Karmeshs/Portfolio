output "postgresql_cluster_id" {
  value       = aws_rds_cluster.postgresql.cluster_identifier
}
output "instance_endpoint" {
  value       = aws_rds_cluster_instance.cluster_instances.endpoint
}
output "port" {
  value       = aws_rds_cluster_instance.cluster_instances.port
}
output "cluster_endpoint" {
  description = "Writer endpoint for the cluster"
  value       = aws_rds_cluster.postgresql.endpoint
}