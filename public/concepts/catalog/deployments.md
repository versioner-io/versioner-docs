# Deployments

A **deployment** represents the activity of having deployed a particular version of a product to a specific environment.
Every time you deploy a version to an environment, Versioner creates a deployment record that tracks:

- **What** was deployed (product and version)
- **Where** it was deployed (environment)
- **When** it was deployed (timestamp)
- **Who** deployed it (user or system)
- **How** it went (status: success, failed, etc.)

## Deployment Lifecycle

Deployments can progress through several states:

### States

| State | Description |
|-------|-------------|
| **Pending** | Deployment is queued or scheduled |
| **Started** | Deployment is in progress |
| **Completed** | Deployment succeeded |
| **Failed** | Deployment failed |
| **Aborted** | Deployment was cancelled |

## Deployment Events

You can submit deployment events from a variety of ways. ([Learn more...](../../integrations)) The example shown here uses the [GitHub Action](../../integrations/github-action.md) native integration, but other options exist as well.

```yaml
- name: Record Deployment Started in Versioner
  uses: versioner-io/versioner-github-action@v1
  with:
    api-key: ${{ secrets.VERSIONER_API_KEY }}
    product: my-service
    version: ${{ github.sha }}
    event-type: deployment
    status: started
    environment: production

- name: Record Deployment Completed in Versioner
  uses: versioner-io/versioner-github-action@v1
  with:
    api-key: ${{ secrets.VERSIONER_API_KEY }}
    product: my-service
    version: ${{ github.sha }}
    event-type: deployment
    status: completed
    environment: production
```

See [Event Types](../../api/event-types.md) for the full list of status values and payload options.

## Deployment Metadata

Deployments can include additional metadata:

```json
{
  "product_name": "my-service",
  "version": "1.2.3",
  "environment_name": "production",
  "status": "success",
  "deployed_by": "john.doe",
  "scm_branch": "main",
  "scm_sha": "abc123def456",
  "build_url": "https://ci.example.com/builds/123",
  "extra_metadata": {
    "deployment_duration_seconds": 120,
    "rollback_version": "1.2.2",
    "deployment_notes": "Hotfix for authentication bug"
  }
}
```

## Related Concepts

- **[Versions](versions.md)** - What gets deployed
- **[Environments](environments.md)** - Where deployments go
- **[Notifications](../configuration/notifications.md)** - Get alerted about deployments
