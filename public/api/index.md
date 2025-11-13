# API Overview

The **Versioner REST API** provides direct programmatic access to all Versioner functionality. Use it when building custom integrations, internal tools, or when you need maximum control over your deployment tracking.

## What is the API?

The Versioner API is a RESTful HTTP API that lets you:

- **Submit events** - Track deployments and builds programmatically
- **Query data** - Retrieve deployment history, versions, and products
- **Manage resources** - Create and update products, environments, and releases
- **Configure notifications** - Set up webhooks and notification preferences

## When to Use the API

### ✅ Use the API When:

**Building custom integrations**

- Internal deployment platforms
- Custom CI/CD systems
- Proprietary tooling

**You need programmatic access**

- Automated workflows
- Data synchronization
- Integration with other systems

**Maximum control required**

- Custom event payloads
- Advanced error handling
- Specific retry logic

### 🔧 Use Native Integrations Instead When:

**Your platform is supported**

- GitHub Actions, Jenkins, Bitbucket, etc.
- Easier setup with automatic metadata extraction

[View Native Integrations →](../integrations/index.md)

### 🔧 Use the CLI Instead When:

**You're using unsupported CI/CD systems**

- Simpler than making HTTP requests
- Built-in retry logic and error handling
- Auto-detection of CI/CD metadata

[View CLI Documentation →](../cli/index.md)

## Base URL

**Production:** `https://api.versioner.io`
**Development:** `https://dev-api.versioner.io`

## Authentication

Versioner uses **dual authentication**:

- **API Keys** - For event tracking (`/build-events/`, `/deployment-events/`)
- **JWT Tokens** - For dashboard and resource management (all other endpoints)

```http
# API Key (for CI/CD event tracking)
Authorization: Bearer sk_mycompany_k1_...

# JWT Token (for dashboard/CRUD)
Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...
```

See [Authentication](../api/authentication.md) for details.

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
