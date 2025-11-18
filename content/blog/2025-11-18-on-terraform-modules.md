+++
title = "On Terraform Module Design"
date = 2025-11-18
[taxonomies]
tags = ["terraform", "iac", "devops"]
+++

When designing Terraform modules for enterprise use, convention over configuration
is your friend. After building 166+ AWS modules serving 302+ teams, a few principles
have proven invaluable:

## Keep Modules Focused

A module should do one thing well. Don't create a "kitchen sink" module that
provisions VPCs, databases, and application servers. Split concerns:

```hcl
module "vpc" {
  source = "./modules/vpc"
  cidr   = "10.0.0.0/16"
}

module "rds" {
  source = "./modules/rds"
  vpc_id = module.vpc.id
}
```

## Sensible Defaults

90% of your users should need to specify only 2-3 variables. Everything else should
have production-ready defaults:

```hcl
variable "backup_retention_days" {
  type    = number
  default = 7  # Sensible for most cases
}
```

## Validation at the Source

Use variable validation to catch errors early, before `terraform apply`:

```hcl
variable "environment" {
  type = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}
```

## Documentation is Code

Your `README.md` should be generated from your module code. Use tools like
`terraform-docs` to keep docs in sync with reality.

The goal: make it easy to do the right thing, hard to do the wrong thing.
