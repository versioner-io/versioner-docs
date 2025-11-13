# Versions

A **version** represents a specific build or release of a product that can be deployed to environments.

## Overview

Versions are created when you build your software. Each version has:

- **Product** - Which product this version belongs to
- **Version identifier** - A unique identifier (semantic version, build number, commit SHA, etc.)
- **Build metadata** - Information about how it was built
- **Source control info** - Git branch, commit SHA, repository

## Version Identifiers

Versioner supports flexible versioning schemes:

### Semantic Versioning

```
1.2.3
2.0.0-beta.1
3.1.4-rc.2
```

### Build Numbers

```
123
456
789
```

### Commit SHAs

```
abc123def456
a1b2c3d4e5f6
```

### Custom Schemes

```
2025.10.28.1
release-q4-2025
hotfix-auth-bug
```

!!! tip "Choose What Works"
    Use whatever versioning scheme makes sense for your team. Versioner doesn't enforce a specific format.

## Version Events

Submit version events to track builds:

```bash
# Build started
POST /version-events/
{
  "product_name": "my-service",
  "version": "1.2.3",
  "status": "started",
  "built_by": "github-actions"
}

# Build completed
POST /version-events/
{
  "product_name": "my-service",
  "version": "1.2.3",
  "status": "completed",
  "scm_sha": "abc123def456",
  "scm_branch": "main",
  "build_url": "https://github.com/..."
}
```

## Version Metadata

Versions can include rich metadata:

```json
{
  "product_name": "my-service",
  "version": "1.2.3",
  "status": "completed",
  "built_by": "github-actions",
  "scm_repository": "github.com/mycompany/my-service",
  "scm_sha": "abc123def456",
  "scm_branch": "main",
  "source_system": "github",
  "build_number": "456",
  "invoke_id": "1234567890",
  "build_url": "https://github.com/mycompany/my-service/actions/runs/1234567890",
  "extra_metadata": {
    "docker_image": "mycompany/my-service:1.2.3",
    "build_duration_seconds": 180,
    "test_coverage": "85%",
    "tags": ["hotfix", "security"]
  }
}
```

## Auto-Creation

Versions are automatically created when you submit events:

```bash
# First deployment of version 1.2.3 creates the version
POST /deployment-events/
{
  "product_name": "my-service",
  "version": "1.2.3",
  "environment_name": "dev",
  "status": "success"
}
```

No need to pre-create versions - they're created on-demand.

## Querying Versions

### List All Versions

```bash
GET /versions/?product=my-service
```

### Get Version Details

```bash
GET /versions/{version-id}
```

### Find by Commit SHA

```bash
GET /versions/?scm_sha=abc123def456
```

## Use Cases

### Build Tracking

Track every build of your software:

- Build success/failure rates
- Build duration trends
- Which commits were built

### Deployment Readiness

Know which versions are ready to deploy:

- Build status (completed, failed)
- Test results
- Security scan results

### Traceability

Link builds to source control:

- Which commit produced this version?
- What branch was it built from?
- Link to CI/CD build logs

## Related Concepts

- **[Deployments](deployments.md)** - Deploying versions to environments
- **[Environments](environments.md)** - Where versions get deployed
- **[Products](products.md)** - What versions belong to

## Next Steps

- Learn about [Deployments](deployments.md)
- Explore [Event Types](../api/event-types.md)
- See the [Interactive API Docs](../api/interactive-docs.md)
