//module variables should be defined and documented here.

variable "cloudfront" {
  description = "enable or disable the cloudfront distrabution creation"
  type        = bool
}

variable "cloudfront_origin_domain" {
  description = "domain name of the ssp"
  type        = string
}

variable "service_names" {
  description = "List of service names to use as subdomains"
  default     = ["startup-sample-project", "ssp"]
  type        = list(string)
}

variable "common_tags" {
  description = "Common tags for created resources"
  default = {
    Application = "Kong Data Plane"
  }
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