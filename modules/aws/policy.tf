resource "aws_iam_policy" "container_manage_logs" {
  name = "container_manage_logs"

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

resource "aws_iam_policy" "container_get_secrets" {
  name = "container_get_secrets"

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

resource "aws_iam_role_policy_attachment" "kong_manage_logs" {
  role = aws_iam_role.kong_container_role.name
  policy_arn = aws_iam_policy.container_manage_logs.arn
}

resource "aws_iam_role_policy_attachment" "kong_get_secrets" {
  role = aws_iam_role.kong_container_role.name
  policy_arn = aws_iam_policy.container_get_secrets.arn
}

resource "aws_iam_role_policy_attachment" "prom_manage_logs" {
  role = aws_iam_role.prom_container_role.name
  policy_arn = aws_iam_policy.container_manage_logs.arn
}