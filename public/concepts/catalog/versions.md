# Versions

A **version** represents a specific build or release of a product that can be deployed to environments.

## Overview

A **build** is the CI/CD action that produces a deployable instance of your product — the **version** is that instance. Versioner tracks the version (the what) and lets you attach context about the build that produced it (the how and when).

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

Submit version events to track builds. The recommended approach is to use a native integration — the [Versioner GitHub Action](../../integrations/github-action.md) handles this automatically as part of your workflow:

```yaml
- name: Record Build Completed in Versioner
  uses: versioner-io/versioner-github-action@v1
  with:
    api-key: ${{ secrets.VERSIONER_API_KEY }}
    product: my-service
    version: ${{ github.sha }}
    event-type: build
    status: completed
```

See the [CI/CD Integrations](../../integrations/index.md) page for setup instructions for each integration type, including the CLI and direct API.

## Version Metadata

Versions can carry rich metadata to capture build context. When submitted via the API directly, the full payload looks like this:

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

Versions are automatically created when you submit events — no need to pre-create them. Submitting a deployment event for a version that doesn't exist yet will create it on-demand.

## Viewing Versions

You can view all versions for a product from the **Products** page in the dashboard.

!!! warning "Versions are immutable"
    Once created, a version's identifier cannot be changed. Version records are append-only — new events update the version's status, but the version itself is a permanent record.

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
