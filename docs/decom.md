## Decommissioning AWS Project

Complete steps in `./README.md`, section: `Installation.Locally` up to and including the `Save path of .terraformrc...` step before proceeding.

The following steps occurred to decommission the project in `dev` environment:

Run:

```sh
cd ./terraform/dev
terragrunt init
```

Once that is complete, run:

```sh
terragrunt run-all destroy
```

This will destroy all resources in our AWS dev environment.

### Rebuilding Project

An initial deployment to create some resources was completed beforehand:

- Inside `./modules/aws/policy.tf`, comment out all `"aws_iam_role_policy_attachment"` Resource sections.
  - Eg: `"ecs_task_exec_role_attach"`, `"ecs_kong_task_role_attach"`, etc.
- Once complete, save the file, then run: `./terraform/dev $ terragrunt run-all apply`

If the deployment is successful:

- Uncomment `"aws_iam_role_policy_attachment"` Resouces from the earlier steps.
- Save file, then rerun `terragrun run-all apply`. This will create/modify some additional resources.

Once complete, the project should be in a working state and can be deployed using GitHub workflow files.