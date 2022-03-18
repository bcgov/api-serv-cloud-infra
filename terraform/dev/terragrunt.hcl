terraform {
  source = "../../modules/aws"
}

include {
  path = find_in_parent_folders()
}

generate "dev_tfvars" {
  path              = "dev.auto.tfvars"
  if_exists         = "overwrite"
  disable_signature = true
  contents          = <<-EOF
    alb_name = "default"
    cloudfront = true
    cloudfront_origin_domain = "kong-dp.sjso4j-dev.nimbus.cloud.gov.bc.ca"
    service_names = ["kong"]
  EOF
}
