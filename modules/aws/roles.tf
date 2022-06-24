# ECS task execution role
resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "DefaultECSTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role_policy_doc.json
  tags               = local.common_tags
}

resource "aws_iam_role" "ecs_kong_task_role" {
  name               = "ECSKongTaskRole"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role_policy_doc.json
  tags               = local.common_tags
}

resource "aws_iam_role" "ecs_prom_task_execution_role" {
  name               = "ECSPrometheusTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role_policy_doc.json
  tags               = local.common_tags
}

resource "aws_iam_role" "ecs_prom_task_role" {
  name               = "ECSPrometheusTaskRole"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role_policy_doc.json
  tags               = local.common_tags
}
