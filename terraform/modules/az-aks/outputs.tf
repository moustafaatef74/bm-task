output "cluster_id" {
  value       = module.aks.aks_id
  description = "The id of the AKS cluster"
}

output "cluster_name" {
  value       = module.aks.aks_name
  description = "The name of the AKS cluster"
}