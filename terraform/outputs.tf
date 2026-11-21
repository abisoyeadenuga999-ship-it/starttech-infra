output "cloudfront_domain_name" {
  value = module.cdn.domain_name
}

output "cloudfront_distribution_id" {
  value = module.cdn.distribution_id
}

output "frontend_bucket" {
  value = module.storage.bucket_id
}

output "ecr_repository_url" {
  value = module.storage.ecr_repository_url
}

output "redis_endpoint" {
  value = module.database.redis_endpoint
}

output "cluster_name" {
  value = module.eks.cluster_name
}
