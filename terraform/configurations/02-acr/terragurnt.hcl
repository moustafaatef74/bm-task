terraform {
  source = "../../tf-modules/az-acr"
}

locals {

  tags = {
    "m-service"       = "acr"
    "m-task"          = "mb-task"
  }
}
 

include {
  path = find_in_parent_folders()
}

inputs = {
  registry_name = "maadi"
  tags          = local.tags
}
