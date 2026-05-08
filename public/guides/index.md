# Guides

Use-case-driven guides for tracking deployments that don't fit neatly into a CI/CD pipeline step. Each guide covers what to track, which version signal makes sense for your setup, and how to wire it in.

## Available Guides

### [Tracking Terraform / IaC Versions](terraform.md)

Track Terraform applies and Terragrunt runs alongside your application deployments. Versioner fills the gap Terraform doesn't: which commit produced the current infrastructure state, visible in the same environment grid as your app versions.

## Coming Soon

- **Using Versioner with AI Agents** — patterns for querying deployment state, running preflight checks, and acting on Versioner data in agentic workflows
