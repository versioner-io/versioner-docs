# API Overview

The **Versioner REST API** (`https://api.versioner.io`) provides direct programmatic access to all Versioner functionality. Use it when building custom integrations, internal tools, or when you need maximum control over your deployment tracking.

- **Submit events** - Track deployments and builds programmatically
- **Query data** - Retrieve deployment history, versions, and products
- **Manage resources** - Create and update products, environments, and releases
- **Configure notifications** - Set up webhooks and notification preferences

!!! info "Choosing an Integration"
    The API is best for custom integrations and internal tooling that need full control. For standard CI/CD pipelines, the [CLI](../cli/index.md) or a [native integration](../integrations/index.md) is usually simpler.

## Quick Start

### Submit a Deployment Event

```bash
curl -X POST https://api.versioner.io/deployment-events/ \
  -H "Authorization: Bearer $VERSIONER_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "product_name": "my-service",
    "version": "1.2.3",
    "environment_name": "production",
    "status": "success",
    "deployed_by": "john.doe"
  }'
```

**Response:**

```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "product_name": "my-service",
  "version": "1.2.3",
  "environment_name": "production",
  "status": "completed",
  "deployed_at": "2025-10-28T15:30:00Z",
  "deployed_by": "john.doe"
}
```

### Submit a Build Event

```bash
curl -X POST https://api.versioner.io/version-events/ \
  -H "Authorization: Bearer $VERSIONER_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "product_name": "my-service",
    "version": "1.2.3",
    "status": "completed",
    "built_by": "github-actions",
    "scm_sha": "abc123def456",
    "scm_branch": "main"
  }'
```

### List Deployments

```bash
curl https://api.versioner.io/deployments/ \
  -H "Authorization: Bearer $VERSIONER_API_KEY"
```

## Complete Documentation

For complete API documentation, see:

- **[Authentication](../api/authentication.md)** - API key management
- **[Event Tracking](../api/event-tracking.md)** - Submit deployment and build events
- **[Interactive Docs](../api/interactive-docs.md)** - Explore all endpoints
- **[Event Types](../api/event-types.md)** - Deployment and version events
- **[Response Codes](../api/response-codes.md)** - Error handling

## Interactive API Documentation

Visit the interactive API documentation at [api.versioner.io/docs](https://api.versioner.io/docs) to:

- Browse all endpoints
- See request/response schemas
- Download OpenAPI specification

## SDK Libraries

!!! info "Coming Soon"
    Official SDK libraries for Python, JavaScript, Go, and Ruby are planned.

## Next Steps

- Start with [Event Tracking](../api/event-tracking.md)
- Learn about [Event Types](../api/event-types.md)
- Explore [Interactive Docs](../api/interactive-docs.md)
