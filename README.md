
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

- Create `.terraformrc` and configure tfc team token
  ```yaml
  credentials "app.terraform.io" {
   token = "<TFC_TEAM_TOKEN>"
  }
  ```
- Save path of `.terraformrc` in an env var - `export TF_CLI_CONFIG_FILE=<PATH_TO_TERRAFORMRC>`
- Run `terragrunt run-all validate` to validate the terraform code
- Run `terragrunt run-all plan` to create a plan for all the environments. Append `--terragrunt-working-dir ./terraform/dev/` to scope plan for dev

## Getting Help or Reporting an Issue
<!--- Example below, modify accordingly --->
To report bugs/issues/feature requests, please file an [issue](../../issues).


## How to Contribute
<!--- Example below, modify accordingly --->
If you would like to contribute, please see our [CONTRIBUTING](./CONTRIBUTING.md) guidelines.

Please note that this project is released with a [Contributor Code of Conduct](./CODE_OF_CONDUCT.md). 
By participating in this project you agree to abide by its terms.


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
