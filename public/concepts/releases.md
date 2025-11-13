# Releases

A **release** is a coordinated grouping of multiple product versions that should be deployed together. Releases help you track and manage multi-product deployments.

## Overview

Releases provide a way to:

- **Group versions** - Bundle multiple product versions into a single release
- **Track progress** - Monitor deployment status across environments
- **Coordinate teams** - Ensure all components reach production together
- **Maintain history** - Audit trail of what was released when

**Key Principle:** A release is a **tracking mechanism**, not a deployment orchestrator. Versioner tracks release progress but doesn't execute deployments.

## Use Cases

### Multi-Service Releases

Deploy multiple microservices together that have dependencies:

```
Release: "User Platform v2.0"
├── user-service: 1.2.3
├── auth-service: 2.1.0
└── api-gateway: 3.0.1
```

Track which services have been deployed to which environments and ensure all services reach production together.

### Sprint/Milestone Releases

Group all features completed in a sprint:

```
Release: "Q4 Sprint 3"
├── web-frontend: 4.5.0
├── mobile-app: 2.3.0
├── payment-api: 1.8.2
├── notification-service: 3.1.1
└── analytics-service: 2.0.0
```

Track overall sprint deployment progress and coordinate go-live timing across teams.

### Hotfix Coordination

Track emergency fixes across multiple services:

```
Release: "Security Patch 2024.10.1"
├── user-service: 1.2.4 (auth vulnerability fix)
├── payment-api: 4.5.7 (encryption update)
└── api-gateway: 3.0.2 (rate limiting fix)
```

Ensure all patches are deployed to production quickly with full audit trail for compliance.

## Release Lifecycle

### 1. Planning

Create a release and add versions:

```bash
POST /releases/
{
  "name": "Release 2024.10.1",
  "description": "Q4 Sprint 3 release",
  "status": "draft"
}
```

Add versions to the release:

```bash
POST /releases/{release-id}/versions
{
  "version_id": "version-uuid"
}
```

### 2. In Progress

Teams deploy versions through environments independently:

```
Product              Version   Dev   Test   Staging   Prod
user-service         1.2.3     ✓     ✓      ✓        ✗
payment-api          4.5.6     ✓     ✓      ✗        ✗
notification-service 2.1.0     ✓     ✓      ✓        ✓
```

Versioner tracks each deployment automatically as teams deploy using their existing CD tools.

### 3. Completed

Once all versions are deployed to production:

```bash
PATCH /releases/{release-id}
{
  "status": "completed"
}
```

Release is archived for historical tracking.

## Release Status

Releases have a status that tracks their lifecycle:

- **draft** - Planning phase, versions being added
- **in_progress** - Deployments underway
- **completed** - All versions deployed to production
- **cancelled** - Release cancelled, not deployed

## Deployment Progress Tracking

The release detail page shows deployment status across environments:

```
Product              Version   Dev   Test   Staging   Production
user-service         1.2.3     ✅    ✅     ✅       ❌
payment-api          4.5.6     ✅    ✅     ❌       ❌
notification-service 2.1.0     ✅    ✅     ✅       ✅
```

- ✅ **Success** - Version successfully deployed
- ❌ **Not deployed** - Version not yet deployed to this environment
- 🔴 **Failed** - Deployment failed
- 🟡 **In progress** - Deployment currently running

## Release Composition

### Adding Versions

Versions can be added to releases at any time:

```bash
POST /releases/{release-id}/versions
{
  "version_id": "version-uuid"
}
```

### Removing Versions

Versions can be removed from releases:

```bash
DELETE /releases/{release-id}/versions/{version-id}
```

### Validation Rules

- **One version per product** - A release can only contain one version of each product
- **Version immutability** - Versions themselves cannot be modified, only added/removed from releases
- **Multiple releases** - The same version can be in multiple releases

## Independent Deployment

Releases don't orchestrate deployments:

- Teams deploy versions independently using their existing CD tools (GitHub Actions, Jenkins, etc.)
- Versioner tracks deployment progress as events are submitted
- Release page provides visibility into overall progress

This approach:

- ✅ Works with any deployment tool
- ✅ No changes to existing workflows
- ✅ Teams maintain autonomy
- ✅ Centralized visibility

## Querying Releases

### List All Releases

```bash
GET /releases/
```

### Get Release Details

```bash
GET /releases/{release-id}
```

### Get Release Versions

```bash
GET /releases/{release-id}/versions
```

### Get Release Deployments

```bash
GET /releases/{release-id}/deployments
```

## Release Metadata

Releases can include rich metadata:

```json
{
  "name": "Release 2024.10.1",
  "description": "Q4 Sprint 3 release with new payment features",
  "status": "in_progress",
  "extra_metadata": {
    "jira_epic": "PROJ-123",
    "release_manager": "jane@company.com",
    "target_date": "2024-10-28",
    "stakeholders": ["product", "engineering", "qa"]
  }
}
```

## Future: Release Approval Workflow

!!! info "Coming Soon"
    Release approval workflow is planned for a future release.

Planned features:

- **Approval gates** - Require approval before production deployment
- **Pre-flight checks** - Validate release readiness
- **Approval tracking** - Audit trail of who approved what and when

## Best Practices

### Release Naming

Use clear, descriptive names:

- ✅ "User Platform v2.0"
- ✅ "Q4 Sprint 3"
- ✅ "Security Patch 2024.10.1"
- ❌ "Release 1"
- ❌ "New stuff"

### Release Scope

Keep releases focused:

- **Too broad** - "Everything we built this quarter" (hard to coordinate)
- **Too narrow** - "Fix typo in button text" (unnecessary overhead)
- **Just right** - "Payment platform upgrade" (clear scope, manageable)

### Documentation

Include helpful context in descriptions:

- What's included in the release
- Why these versions are grouped together
- Target deployment date
- Links to project management tools (Jira, etc.)

## Related Concepts

- **[Products](products.md)** - What gets versioned and released
- **[Versions](versions.md)** - Specific builds that go into releases
- **[Deployments](deployments.md)** - Records of versions deployed to environments
- **[Environments](environments.md)** - Where releases get deployed

## Next Steps

- Learn about [Products](products.md)
- Explore [Versions](versions.md)
- See the [Interactive API Docs](../api/interactive-docs.md)
