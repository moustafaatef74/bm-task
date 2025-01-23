#------------------------------------------------------------------------------
# Root terragrunt config
#------------------------------------------------------------------------------
locals {
  tags = {
    "m-env"         = "dev"
  }
}

generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
    backend "azurerm" {
      resource_group_name  = "mb-task-rg"
      storage_account_name = "mbtaskrgtfstateliveall"
      container_name       = "tf-state-live"
      use_oidc             = true
      key                  = "mb-task-rg/${path_relative_to_include()}/terraform.tfstate"
  }
}
EOF
}

terraform {
  before_hook "before_cache" {
    commands     = [get_terraform_command()]
    execute      = ["mkdir", "-p", abspath("${get_repo_root()}/.terragrunt-cache/.plugins")]
  }
  extra_arguments "terragrunt_plugins" {
    commands = [get_terraform_command()]
    env_vars = {
      TF_PLUGIN_CACHE_DIR = abspath("${get_repo_root()}/.terragrunt-cache/.plugins")
    }
  }
}

# ------------------------------------------------------------------------------
# Allow reusing inputs on the account, environment & cluster level.
# ------------------------------------------------------------------------------

inputs = merge(
  try(
    yamldecode(file(find_in_parent_folders("account.yaml"))),
    {}
  )
)