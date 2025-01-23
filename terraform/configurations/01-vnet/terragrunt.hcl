terraform {
  source = "../../tf-modules/az-vnet"
}

locals {
  tags = {
    "m-service"       = "vnet"
    "m-task"          = "mb-task"
  }
}

include {
  path = find_in_parent_folders()
}

inputs = {
  tags = local.tags
}