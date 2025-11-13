# Versioner Docs Infrastructure

Terraform configuration for deploying the MkDocs documentation site to AWS.

## Architecture

- **S3:** Private bucket for static files with versioning enabled
- **CloudFront:** Global CDN with HTTPS and caching
- **ACM:** SSL/TLS certificate (managed in us-east-1)
- **Route53:** DNS records pointing to CloudFront

## Files

| File | Description |
|------|-------------|
| `variables.tf` | Input variables |
| `locals.tf` | Local values and common tags |
| `s3.tf` | S3 bucket with versioning, encryption, and OAC policy |
| `cloudfront.tf` | CloudFront distribution with OAC |
| `acm.tf` | ACM certificate with DNS validation |
| `route53.tf` | DNS A and AAAA records |
| `outputs.tf` | Output values |
