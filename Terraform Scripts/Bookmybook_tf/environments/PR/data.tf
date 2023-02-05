
data "aws_iam_role" "taskrole" {
  name = "ecs-task-execution-role"
}

data "aws_ecs_cluster" "cluster" {
  cluster_name = "production-workers"
}

data "template_file" "taskdef" {
  count    = length(var.cname)
  template = file("scripts/taskdef.json")
  vars = {
    cname      = var.cname[count.index]
    logs       = var.logs_name[count.index]
    entrypoint = var.entrypoint[count.index]
  }
}