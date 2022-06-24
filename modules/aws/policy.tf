# ECS task execution role data
data "aws_iam_policy_document" "ecs_task_assume_role_policy_doc" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "ssm_get_params_policy" {
  name   = "SystemsManagerGetParams"
  policy = jsonencode({
      "Version": "2012-10-17",
      "Statement": [
          {
              "Effect": "Allow",
              "Action": [
                  "ssm:GetParameters"
              ],
              "Resource": [
                  "arn:aws:ssm:*:*:parameter/otel-collector-config"
              ]
          }
      ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_ssm_get_params_attach" {
  role = aws_iam_role.ecs_prom_task_execution_role.id
  policy_arn = aws_iam_policy.ssm_get_params_policy.arn
}

resource "aws_iam_policy" "ecs_task_cwlogs_policy" {
  name = "CloudWatchCreateLogGroup"
  policy = jsonencode({
      "Version": "2012-10-17",
      "Statement": [
          {
              "Effect": "Allow",
              "Action": [
                  "logs:CreateLogGroup"
              ],
              "Resource": [
                  "arn:aws:logs:*:*:*"
              ]
          }
      ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_cwlogs_attach" {
  role = aws_iam_role.ecs_task_execution_role.id
  policy_arn = aws_iam_policy.ecs_task_cwlogs_policy.arn
}

# Attaching task execution and read from secrets manager policies to task execution role
# resource "aws_iam_role_policy_attachment" "ecs_task_exec_role_attach" {
#   role       = aws_iam_role.ecs_task_execution_role.name
#   for_each = toset([
#     "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
#   ])
#   policy_arn = each.value
# }

resource "aws_iam_policy" "ecs_task_manage_logs_policy" {
  name = "CloudWatchManageLogs"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ],
        "Resource": [
          "arn:aws:logs:*:*:*"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "ecs_task_get_secrets_policy" {
  name = "SecretsManagerGetSecrets"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "secretsmanager:GetSecretValue"
        ],
        "Resource": [
          "arn:aws:secretsmanager:ca-central-1:648498837764:secret:*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_kong_task_manage_logs_attach" {
  role = aws_iam_role.ecs_kong_task_role.name
  policy_arn = aws_iam_policy.ecs_task_manage_logs_policy.arn
}

resource "aws_iam_role_policy_attachment" "ecs_kong_get_secrets_attach" {
  role = aws_iam_role.ecs_kong_task_role.name
  policy_arn = aws_iam_policy.ecs_task_get_secrets_policy.arn
}

resource "aws_iam_policy" "ecs_task_read_resources_policy" {
  name = "ECSReadResources"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "ECS:ListTasks",
          "ECS:ListServices",
          "ECS:DescribeContainerInstances",
          "ECS:DescribeServices",
          "ECS:DescribeTasks",
          "ECS:DescribeTaskDefinition"
        ],
        "Resource": "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_prom_task_manage_logs_attach" {
  role = aws_iam_role.ecs_prom_task_role.name
  policy_arn = aws_iam_policy.ecs_task_manage_logs_policy.arn
}

resource "aws_iam_role_policy_attachment" "ecs_prom_task_read_resources_attach" {
  role = aws_iam_role.ecs_prom_task_role.name
  policy_arn = aws_iam_policy.ecs_task_read_resources_policy.arn
}