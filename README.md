
# APS AWS Infra
<!--- [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](./LICENSE) --->

APS AWS IAC (infrastructure as code) managed by terraform for deploying api management solution

## Project Status
- [x] Development
- [ ] Production/Maintenance

## Getting Started

The following components are to be deployed

- Kong v2.x

## Prerequisites

### Tools Required

- Terraform
- Terragrunt
- Prometheus

### Environment Setup

#### Configure below parameters as repository secrets

|ENV VAR|Reference|
|-|-|
|`AWS_ACCESS_KEY_ID`|Parameter Store - (`/octk/service-accounts/ci`).`access_key_id`|
|`AWS_ACCOUNTS_ECR_READ_ACCESS`|["arn:aws:iam::DEV_ACCOUNT_NUMBER:root", "arn:aws:iam::TEST_ACCOUNT_NUMBER:root", "arn:aws:iam::PROD_ACCOUNT_NUMBER:root"]|
|`AWS_ECR_URI`|Amazon ECR (copy URI)|""|
|`AWS_ROLE_TO_ASSUME`|Parameter Store - (`/octk/service-accounts/ci`).`ecr_read_write`|
`AWS_SECRET_ACCESS_KEY`|Parameter Store - (`/octk/service-accounts/ci`).`access_key_secret`|
|`TFC_TEAM_TOKEN`|Parameter Store - (`/octk/tfc/team-token`)|

## Installation

### Locally

- Copy the token from `/systems-manager/parameters/octk/tfc/team-token`
- Create `.terraformrc` and configure tfc team token

  ```json
  credentials "app.terraform.io" {
   token = "<TFC_TEAM_TOKEN>"
  }
  ```

- Save path of `.terraformrc` in an env var - `export TF_CLI_CONFIG_FILE=<PATH_TO_TERRAFORMRC>`
- Run `terragrunt init` from each module directory to initialize plugins
- Run `terragrunt run-all validate` to validate the terraform code
- Run `terragrunt run-all plan` to create a plan for all the environments. Append `--terragrunt-working-dir ./terraform/dev/` to scope plan for dev

## Logging into ECS Fargate Container

```bash
# Install session manager plugin 
# https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html
# For Ubuntu/WSL
curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb"

sudo dpkg -i session-manager-plugin.deb

# Run this command and it should return (The Session Manager plugin was installed successfully. Use the AWS CLI to start a session.)
session-manager-plugin

# Update the Service
aws ecs update-service --cluster ecs-kong --service kong --region ca-central-1 --enable-execute-command --force-new-deployment > /dev/null

# Fetch task id from AWS Console and replace with TASK_ID
aws ecs describe-tasks --cluster ecs-kong --tasks <TASK_ID>

aws ecs execute-command --cluster ecs-kong --task 2d5a9dce3c0940edbb1172a40f61b9e5 --container prom-metrics-proxy --interactive --command "/bin/bash"
```

## Troubleshooting

### Plugin reinitialization required

```bash
cd ./terraform/dev
terragrunt init
```

## Getting Help or Reporting an Issue
<!--- Example below, modify accordingly --->
To report bugs/issues/feature requests, please file an [issue](../../issues).


## How to Contribute
<!--- Example below, modify accordingly --->
If you would like to contribute, please see our [CONTRIBUTING](./CONTRIBUTING.md) guidelines.

Please note that this project is released with a [Contributor Code of Conduct](./CODE_OF_CONDUCT.md). 
By participating in this project you agree to abide by its terms.


## Decommissioning Project

Complete steps in `Installation.Locally` section up to and including the `Save path of .terraformrc...` step before proceeding.

### Dev

Run:

```sh
cd terraform/dev
terragrunt init
```

Once that is complete, run:

```sh
terragrunt run-all destroy
```

This will destroy all resources in our AWS dev environment.

#### Rebuilding Dev Project

An initial deployment to create some resources was completed before hand.

Inside `./modules/aws/policy.tf`, comment out all `"aws_iam_role_policy_attachment"` Resource sections. Eg: `"ecs_task_exec_role_attach"`, `"ecs_kong_task_role_attach"`, etc.

Once complete, save the file, then run: `./terraform/dev $ terragrunt run-all apply`

If the deployment is successful, uncomment `"aws_iam_role_policy_attachment"` Resouces from the earlier steps. Save file, then rerun `terragrun run-all apply`. This will create/modify some additional resources. Once complete, the project should be in a working state.

## License
<!--- Example below, modify accordingly --->
    Copyright 2018 Province of British Columbia

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
