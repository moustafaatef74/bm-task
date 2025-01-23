output "vnet_subnets_name_id" {
  description = "Can be queried subnet-id by subnet name by using lookup(module.vnet.vnet_subnets_name_id, subnet1)"
  value = {
    for key, value in module.vnet.vnet_subnets_name_id :
    replace(key, "nawy-prd-", "") => value
  }
}