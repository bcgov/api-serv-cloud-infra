# ECS task execution role
resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "DefaultECSTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role_policy_doc.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
    aws_iam_policy.ecs_task_cwlogs_policy.arn
  ]
  tags = local.common_tags
}

resource "aws_iam_role" "ecs_kong_task_role" {
  name               = "ECSKongTaskRole"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role_policy_doc.json
  managed_policy_arns = [
    aws_iam_policy.ecs_task_manage_logs_policy.arn,
    aws_iam_policy.ecs_task_get_secrets_policy.arn
  ]
  tags = local.common_tags
}

resource "aws_iam_role" "ecs_prom_task_execution_role" {
  name               = "ECSPrometheusTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role_policy_doc.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
    aws_iam_policy.ssm_get_params_policy.arn
  ]
  tags = local.common_tags
}

resource "aws_iam_role" "ecs_prom_task_role" {
  name               = "ECSPrometheusTaskRole"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role_policy_doc.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
    aws_iam_policy.ecs_task_manage_logs_policy.arn,
    aws_iam_policy.ecs_task_read_resources_policy.arn
  ]
  tags = local.common_tags
}
