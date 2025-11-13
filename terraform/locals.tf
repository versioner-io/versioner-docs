locals {
  common_tags = merge(
    {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    },
    var.tags
  )

  # S3 bucket name must be globally unique
  bucket_name = "${var.project_name}-${var.environment}"
}
