#
# Contextual output
#

output "walrus_project_name" {
  value       = try(local.context["project"]["name"], null)
  description = "The name of project where deployed in Walrus."
}

output "walrus_project_id" {
  value       = try(local.context["project"]["id"], null)
  description = "The id of project where deployed in Walrus."
}

output "walrus_environment_name" {
  value       = try(local.context["environment"]["name"], null)
  description = "The name of environment where deployed in Walrus."
}

output "walrus_environment_id" {
  value       = try(local.context["environment"]["id"], null)
  description = "The id of environment where deployed in Walrus."
}

output "walrus_resource_name" {
  value       = try(local.context["resource"]["name"], null)
  description = "The name of resource where deployed in Walrus."
}

output "walrus_resource_id" {
  value       = try(local.context["resource"]["id"], null)
  description = "The id of resource where deployed in Walrus."
}

output "cas_instance_id" {
  description = "CAS 实例 ID"
  value       = module.cas_instance.instance_ids[0]
}

output "cas_instance_ip" {
  description = "CAS 实例 IP 地址"
  value       = module.cas_instance.instance_ips[0]
}

output "cas_access_urls" {
  description = "CAS 访问 URL"
  value = {
    http  = "http://${module.cas_instance.instance_ips[0]}:8080/cas"
  }
}

output "ports" {
  description = "Service Ports"
  value       = 8080
}