terraform {
  source = "../../tf-modules/az-resource-group"
}

locals {
  tags = {
    "m-service"       = "resource-group"
    "m-task"          = "mb-task"
  }
}

include {
  path = find_in_parent_folders()
}

inputs = {
  tags = local.tags
}