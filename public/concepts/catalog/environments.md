# Environments

An **environment** represents a deployment target where versions of your products run.

## Overview

Environments are where your software gets deployed. Common examples:

- **Development** - Developer testing environments
- **Staging** - Pre-production testing
- **UAT** - User acceptance testing
- **Production** - Live customer-facing systems

## Environment Types

Versioner categorizes environments into types:

| Type | Description | Examples |
|------|-------------|----------|
| **dev** | Development environments | dev, local, sandbox |
| **test** | Testing environments | test, qa, integration |
| **staging** | Pre-production environments | staging, uat, preprod |
| **production** | Production environments | production, prod, live |

Environment types serve two purposes: they control how environments are ordered and grouped in the dashboard and Deployment Requests, and they give Versioner a sense of your deployment progression — so features like promotion tracking and deployment rules can reason about which environments are "earlier" or "later" in your pipeline.

!!! Auto-Detection
    Versioner automatically infers the environment type from the name you provide, using the patterns in the table above. No explicit type configuration is required.

## Creating Environments

Environments are created automatically the first time you deploy to them — no pre-configuration needed. If you want to set one up ahead of time, you can create it from the dashboard.

## Environment Metadata

Environments can include additional metadata:

```json
{
  "name": "production-us-east",
  "type": "production",
  "description": "Production environment in US East",
  "metadata": {
    "region": "us-east-1",
    "cluster": "prod-cluster-1",
    "kubernetes_namespace": "production"
  }
}
```

## Multiple Environments

You can have multiple environments of the same type:

- **production-us-east** (production)
- **production-eu-west** (production)
- **production-ap-south** (production)

Or different naming schemes:

- **dev-team-a** (dev)
- **dev-team-b** (dev)
- **qa-regression** (test)
- **qa-smoke** (test)

## Best Practices

### 1. Consistent Naming

Use consistent environment names across products:

✅ **Good:**

- `production`
- `staging`
- `dev`

❌ **Avoid:**

- `prod` (for one product)
- `production` (for another product)
- `live` (for a third product)

### 2. Descriptive Names

For multiple environments of the same type, use descriptive names:

✅ **Good:**

- `production-us-east`
- `production-eu-west`

❌ **Avoid:**

- `production-1`
- `production-2`

### 3. Environment Types

Let Versioner auto-detect types when possible:

✅ **Auto-detected:**

- `production` → production type
- `staging` → staging type
- `dev` → dev type

## Related Concepts

- **[Deployments](deployments.md)** - Deploying to environments
- **[Versions](versions.md)** - What gets deployed
- **[Notifications](../configuration/notifications.md)** - Environment-specific alerts
