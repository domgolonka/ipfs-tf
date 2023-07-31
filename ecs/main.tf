resource "aws_ecs_cluster" "blockparty" {
  name = "${upper(var.project)}-${upper(var.env)}-${upper(var.ecs_cluster_name)}"
}

