output "anyscale_memorystore_id" {
  description = "The memorystore instance ID."
  value       = try(google_redis_instance.anyscale_memorystore[0].id, "")
}

output "anyscale_memorystore_host" {
  description = "The IP address of the instance."
  value       = try(google_redis_instance.anyscale_memorystore[0].host, "")
}

output "anyscale_memorystore_port" {
  description = "The port number of the exposed Redis endpoint."
  value       = try(google_redis_instance.anyscale_memorystore[0].port, "")
}

output "anyscale_memorystore_region" {
  description = "The region the instance lives in."
  value       = try(google_redis_instance.anyscale_memorystore[0].region, "")
}

output "anyscale_memorystore_current_location_id" {
  description = "The current zone where the Redis endpoint is placed."
  value       = try(google_redis_instance.anyscale_memorystore[0].current_location_id, "")
}

output "anyscale_memorystore_maintenance_schedule" {
  description = "The maintenance schedule for the instance."
  value       = try(google_redis_instance.anyscale_memorystore[0].maintenance_schedule, "")
}
