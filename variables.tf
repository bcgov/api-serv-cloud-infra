//module variables should be defined and documented here.
variable "common_tags" {
  description = "Common tags for created resources"
  default = {
    Application = "Kong Data Plane"
  }
}

variable "ecs_task_execution_role_name" {
  description = "ECS task execution role name"
  default     = "DefaultECSTaskExecutionRole"
}

variable "app_count" {
  description = "Number of docker containers to run"
  default     = 2
}

variable "health_check_path" {
  default = "/"
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = 512
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = 1024
}

variable "kong_port_http" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 80
}

variable "kong_port_https" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 443
}