# :bangbang: Note: This PR will eventually make changes to production systems :bangbang:

## Checklist

- [ ] **Required**: Pull request title contains the JIRA ticket number like [QS-XXX]
- [ ] **Required**: backend.tf file exists
- [ ] terraform fmt has been used
- [ ] **Required**: terraform validate runs successully on your machine
- [ ] **Required**: terraform plan runs successfully on your machine

Please make sure a `backend.tf` file is present in the directories you've changed and it refers to the `terraform-remote-files` s3 bucket to hold the state.

### Example backend.tf

```YAML
    terraform {
      backend "s3" {
        bucket         = "qass-tf-infrastructure-state"
        key            = "global/terraform.tfstate"
        region         = "us-east-1"
        dynamodb_table = "qass-tf-infrastructure-state-lock"
        encrypt        = true
      }
    }
```

Please make sure a `versions.tf` file is also present in the directiories to prevent terraform state accidental changes and/or conflicts.

### Example versions.tf

```YAML
    terraform {
        required_version = "~> 0.13"
    }
```

You can create workflows for your terraform module to make use of workspaces like `development`, `staging`, `qa` and `production`.

## PR description

Lorem ipsum ...
