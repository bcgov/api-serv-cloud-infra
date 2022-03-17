resource "aws_iam_policy" "secrets_manager_read_policy" {
  name        = "secrets-manager-read-policy"
  description = "A policy for reading secrets from secrets manager"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "secretsmanager:GetSecretValue"
      ],
      "Effect": "Allow",
      "Resource": [
          "arn:aws:secretsmanager:ca-central-1:648498837764:secret:kongh-cluster-ca-crt-hiYRLu",
          "arn:aws:secretsmanager:ca-central-1:648498837764:secret:kongh-cluster-tls-crt-9NVKnJ",
          "arn:aws:secretsmanager:ca-central-1:648498837764:secret:kongh-cluster-tls-key-D9iCSd"
      ]
    }
  ]
}
EOF
}