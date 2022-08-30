# Decommissioning AWS Project

## Secrets

If not created during deployment, a few secrets may need to be created. For dev, the value of these secrets can be found in our OpenShift Silver dev environment. The secret name and location of values:

- `kongh-cluster-tls-key` : kongh-cluster-cert > tls.key
- `kongh-cluster-tls-crt` : kongh-cluster-cert > tls.crt
- `kongh-cluster-ca-crt` : kongh-cluster-ca > ca.crt
- `plugins-ratelimiting-redis-password` : redis > redis-password

## Next Steps

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

- Uncomment `"aws_iam_role_policy_attachment"` Resouces from the earlier step.
- Save file, then rerun `terragrunt run-all apply`. This will create/modify some additional resources.

Once complete, the project should be in a working state and can be deployed using standard GitHub Actions workflow.
