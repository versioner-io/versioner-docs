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

### Auto-Detection

When you submit events, Versioner automatically detects environment types based on names:

```bash
# Automatically detected as "production" type
POST /deployment-events/
{
  "environment_name": "production"
}

# Automatically detected as "staging" type
POST /deployment-events/
{
  "environment_name": "staging"
}
```

## Creating Environments

Environments are automatically created when you first deploy to them:

```bash
# First deployment to "production" creates the environment
POST /deployment-events/
{
  "product_name": "my-service",
  "version": "1.2.3",
  "environment_name": "production",
  "status": "success"
}
```

No pre-configuration needed!

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

## Querying Environments

### List All Environments

```bash
GET /environments/
```

### Filter by Type

```bash
GET /environments/?type=production
```

### Get Environment Details

```bash
GET /environments/{environment-id}
```

## Use Cases

### Deployment Tracking

Track what's deployed to each environment:

```
Production:     my-service v1.2.3 (deployed 2 hours ago)
Staging:        my-service v1.2.4 (deployed 30 minutes ago)
Dev:            my-service v1.3.0 (deployed 5 minutes ago)
```

### Environment Drift Detection

Detect when environments are out of sync:

- Production running v1.2.3
- Staging running v1.2.4
- **Alert:** Staging is ahead of production!

### Deployment Flows

Enforce deployment order:

```
dev → test → staging → production
```

Pre-flight checks are coming soon - stay tuned!

### No-Deploy Windows

Restrict deployments to certain environments:

- No production deployments on Fridays after 3pm
- No staging deployments during business hours
- Holiday freeze windows

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
- **[Notifications](notifications.md)** - Environment-specific alerts

## Next Steps

- Learn about [Deployments](deployments.md)
- Set up [Notifications](notifications.md) per environment
- Explore the [Interactive API Docs](../api/interactive-docs.md)
