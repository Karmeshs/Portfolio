tags = {
  "Environment" = "ST"
}
#ECS
ecs_name                   = ["shape-api-imports", "import-cost-pausing"]
propagate_tags             = "SERVICE"
deployment_minimum_percent = "0"
deployment_maximum_percent = "100"
desired_count              = "1"
# ordered_placement_strategy 
type  = "binpack"
field = "cpu"

#task def
family = ["shape-api-imports", "import-cost-pausing"]
#Log grp
logs_name = ["/ecs/bookmybook/staging/shape-api-imports", "/ecs/bookmybook/staging/import-cost-pausing"]
retention = "30"
#policy taskdef data.tf
cname      = ["shape-api-imports", "import-cost-pausing"]
entrypoint = ["worker_shape_api_imports", "worker_import_cost_pausing"]










# tags = {
#   "acronym" = "test"
# }

# ecr_name = "test-ecr"

# cluster_name = "my-cluster"

# role_name = "test"
# sg_name   = "test"
# ## ECS
# ecs_name = ["shape-api-imports", "import-cost-pausing"]
# family   = ["shape-api-imports", "import-cost-pausing"]
# logs     = ["/ecs/bookmybook/staging/shape-api-imports", "/ecs/bookmybook/staging/import-cost-pausing"]

# # ecs_name2 = "worker2"
# # family2   = "worker2"

# cname      = ["shape-api-imports", "import-cost-pausing"]
# entrypoint = ["worker_shape_api_imports", "worker_import_cost_pausing"]