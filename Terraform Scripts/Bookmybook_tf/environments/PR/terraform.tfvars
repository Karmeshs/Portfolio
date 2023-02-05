tags = {
  "Environment" = "PR"
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
logs_name = ["/ecs/bookmybook/production/shape-api-imports", "/ecs/bookmybook/production/import-cost-pausing"]
retention = "30"
#policy taskdef data.tf
cname      = ["shape-api-imports", "import-cost-pausing"]
entrypoint = ["worker_shape_api_imports", "worker_import_cost_pausing"]
