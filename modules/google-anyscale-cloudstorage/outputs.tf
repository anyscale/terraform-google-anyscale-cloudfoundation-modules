output "cloudstorage_bucket_name" {
  description = "The Google Cloud Storage bucket name."
  value       = var.module_enabled ? try(local.computed_anyscale_bucketname, "") : ""
}

output "cloudstorage_bucket_selflink" {
  description = "The Google Cloud Storage self link."
  value       = try(google_storage_bucket.anyscale_bucket[0].self_link, "")
}

output "cloudstorage_bucket_url" {
  description = "The Google Cloud Storage url for the bucket. Will be in the format `gs://<bucket-name>`."
  value       = try(google_storage_bucket.anyscale_bucket[0].url, "")
}
