# Products

A **product** is a deployable software component that has versions. Products are the primary organizational unit in Versioner.

## Overview

Products represent the things you build and deploy. Think of a product as a deployable unit, often mapping to a single code repository. A product will have multiple versions, and each version can be deployed to your environments.

Each product has:

- **Name** - A unique identifier for the product
- **Description** - What the product does
- **Versions** - Different builds of the product
- **Deployments** - Records of versions deployed to environments

## Creating Products

Products are automatically created when you submit your first deployment event — no setup required. If you need to create a product manually, you can do so from the Products page.

## Product Metadata

Products can include additional metadata to capture ownership and context:

```json
{
  "name": "user-service",
  "description": "User authentication and profile management",
  "extra_metadata": {
    "team": "platform",
    "repository": "github.com/mycompany/user-service",
    "tech_stack": "Python/FastAPI",
    "owner": "platform-team@company.com"
  }
}
```

## Managing Products

Manage your products from the **Products** page. From there you can view all products, edit metadata, and delete products.

!!! warning "Deleting Products"
    Deleting a product will also delete all associated versions and deployments. This action cannot be undone.

For API-based product management, see the [Interactive API Docs](../../api/interactive-docs.md).

## Product Relationships

Products connect to other entities in Versioner:

- **Versions** - A product has many versions
- **Deployments** - Versions of a product are deployed to environments
- **Deployment Requests** - Products can be included in coordinated deployment requests
- **Environments** - Products are deployed to environments

## Best Practices

### Consistency

Use consistent naming across systems:

- Repository name: `user-service`
- Product name: `user-service`
- Docker image: `mycompany/user-service`

### Documentation

Include helpful metadata:

- Team ownership
- Repository links
- Tech stack
- Contact information

## Related Concepts

- **[Versions](versions.md)** - Builds of products that can be deployed
- **[Deployments](deployments.md)** - Records of product versions deployed to environments
- **[Deployment Requests](../governance/deployment-requests.md)** - Coordinated deployments of multiple products
- **[Environments](environments.md)** - Where products get deployed

## Next Steps

- Learn about [Versions](versions.md)
- Explore [Deployments](deployments.md)
- See the [Interactive API Docs](../../api/interactive-docs.md)
