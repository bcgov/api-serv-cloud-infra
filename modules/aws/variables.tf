//module variables should be defined and documented here.
variable "target_env" {
  description = "AWS workload account env (e.g. dev, test, prod, sandbox, unclass)"
}

variable "target_aws_account_id" {
  description = "AWS workload account id"
}

variable "aws_region" {
  description = "The AWS region things are created in"
  default     = "ca-central-1"
}

variable "common_tags" {
  description = "Common tags for created resources"
  default = {
    application = "kong-data-plane"
  }
}

variable "ecs_task_execution_role_name" {
  description = "ECS task execution role name"
  default     = "DefaultECSTaskExecutionRole"
}

variable "ecs_auto_scale_role_name" {
  description = "ECS auto scale role Name"
  default     = "DefaultECSAutoScaleRole"
}

variable "az_count" {
  description = "Number of AZs to cover in a given region"
  default     = "2"
}

variable "health_check_path" {
  default = "/status"
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = 1024
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = 4096
}

variable "kong_port_http" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 8000
}

variable "kong_port_https" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 8443
}

variable "kong_port_admin" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 8001
}

variable "kong_status_port_http" {
  description = "Port exposed by the docker image to fetch instance status"
  default     = 8100
}

variable "redis_port_http" {
  description = "Redis port"
  default     = 6379
}

variable "service_names" {
  description = "List of service names to use as subdomains"
  default     = ["startup-sample-project", "ssp"]
  type        = list(string)
}

variable "alb_name" {
  description = "Name of the internal alb"
  default     = "default"
  type        = string
}

variable "ecr_repository" {
  description = "Name for the container repository to be provisioned."
  type        = string
}

variable "budget_amount" {
  description = "The amount of spend for the budget. Example: enter 100 to represent $100"
  default     = "100.0"
}

variable "budget_tag" {
  description = "The Cost Allocation Tag that will be used to build the monthly budget. "
  default     = "Project=Startup Sample"
}

variable "cloudfront" {
  description = "enable or disable the cloudfront distrabution creation"
  type        = bool
}

variable "cloudfront_origin_domain" {
  description = "domain name of the ssp"
  type        = string
}