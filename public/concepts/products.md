# Products

A **product** is a deployable software component that has versions. Products are the primary organizational unit in Versioner.

## Overview

Products represent the things you build and deploy:

- **Microservices** - Individual services in a microservice architecture
- **Applications** - Web apps, mobile apps, desktop applications
- **Libraries** - Shared libraries or packages
- **Infrastructure** - Infrastructure as code, configuration bundles

Each product has:

- **Name** - A unique identifier for the product
- **Description** - What the product does
- **Versions** - Different builds/releases of the product
- **Deployments** - Records of versions deployed to environments

## Product Names

Product names should be:

- **Unique** - No two products can have the same name in your account
- **Descriptive** - Clear what the product is
- **Consistent** - Use the same name across all systems

### Examples

```
user-service
payment-api
mobile-app-ios
web-frontend
auth-library
terraform-infrastructure
```

!!! tip "Naming Convention"
    Use lowercase with hyphens for consistency. Match your repository or service names when possible.

## Creating Products

Products are automatically created when you submit your first event:

```bash
# First deployment creates the product
POST /deployment-events/
{
  "product_name": "my-service",
  "version": "1.0.0",
  "environment_name": "dev",
  "status": "success"
}
```

You can also create products explicitly via the UI or API:

```bash
POST /products/
{
  "name": "my-service",
  "description": "User authentication service"
}
```

## Product Metadata

Products can include additional metadata:

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

### List Products

```bash
GET /products/
```

### Get Product Details

```bash
GET /products/{product-id}
```

### Update Product

```bash
PATCH /products/{product-id}
{
  "description": "Updated description"
}
```

### Delete Product

```bash
DELETE /products/{product-id}
```

!!! warning "Deleting Products"
    Deleting a product will also delete all associated versions and deployments. This action cannot be undone.

## Use Cases

### Microservices Architecture

Track deployments across multiple services:

```
Products:
- user-service
- payment-api
- notification-service
- api-gateway
```

Each service has independent versions and deployment cycles.

### Monorepo with Multiple Apps

Track different applications in a single repository:

```
Products:
- web-frontend
- mobile-app-ios
- mobile-app-android
- shared-library
```

### Multi-Environment Deployments

Track the same product across environments:

```
Product: my-service

Environments:
- dev: v1.2.3
- staging: v1.2.2
- production: v1.2.1
```

## Product Relationships

Products are connected to other entities:

- **Versions** - A product has many versions
- **Deployments** - Versions of a product are deployed to environments
- **Releases** - Products can be grouped into coordinated releases
- **Environments** - Products are deployed to environments

## Best Practices

### Granularity

Choose the right level of granularity:

- **Too broad** - "backend" (hard to track individual components)
- **Too narrow** - "user-service-auth-module" (too much overhead)
- **Just right** - "user-service" (clear boundaries, manageable)

### Consistency

Use consistent naming across systems:

- Repository name: `user-service`
- Product name: `user-service`
- Docker image: `mycompany/user-service`
- Kubernetes deployment: `user-service`

### Documentation

Include helpful metadata:

- Team ownership
- Repository links
- Tech stack
- Contact information

## Related Concepts

- **[Versions](versions.md)** - Builds of products that can be deployed
- **[Deployments](deployments.md)** - Records of product versions deployed to environments
- **[Releases](releases.md)** - Coordinated releases of multiple products
- **[Environments](environments.md)** - Where products get deployed

## Next Steps

- Learn about [Versions](versions.md)
- Explore [Deployments](deployments.md)
- See the [Interactive API Docs](../api/interactive-docs.md)
