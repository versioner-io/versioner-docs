# Event Tracking API

The Event Tracking API allows you to submit deployment and build events from your CI/CD pipelines. These are the primary endpoints for external integrations.

## Authentication

Event endpoints use **API Key authentication**:

```http
Authorization: Bearer sk_mycompany_k1_...
```

Get your API key from [app.versioner.io/settings](https://app.versioner.io/settings).

See [Authentication](authentication.md) for details.

## Base URLs

- **Production:** `https://api.versioner.io`
- **Development:** `https://dev-api.versioner.io`

## Deployment Events

Track deployments to environments.

### Submit Deployment Event

```http
POST /deployment-events/
```

**Request Body:**

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
    "deployment_duration_seconds": 120
  }
}
```

**Required Fields:**

| Field | Type | Description |
|-------|------|-------------|
| `product_name` | string | Name of the product/service |
| `version` | string | Version being deployed |
| `environment_name` | string | Target environment |
| `status` | string | Deployment status (see below) |

**Optional Fields:**

| Field | Type | Description |
|-------|------|-------------|
| `deployed_by` | string | User who triggered deployment |
| `scm_branch` | string | Git branch |
| `scm_sha` | string | Git commit SHA |
| `scm_repository` | string | Repository URL |
| `build_url` | string | Link to CI/CD build |
| `build_number` | string | CI/CD build number |
| `source_system` | string | CI/CD system name |
| `invoke_id` | string | Unique run/invocation ID |
| `extra_metadata` | object | Custom metadata (JSON) |

**Status Values:**

| Status | Maps To | Description |
|--------|---------|-------------|
| `pending`, `queued`, `scheduled` | `deployment.pending` | Queued for deployment |
| `started`, `in_progress`, `deploying` | `deployment.started` | Deployment in progress |
| `success`, `completed`, `deployed` | `deployment.completed` | Deployment succeeded |
| `failed`, `failure`, `error` | `deployment.failed` | Deployment failed |
| `aborted`, `cancelled`, `skipped` | `deployment.aborted` | Deployment cancelled |

**Response:** `200 OK`

```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "product_name": "my-service",
  "version": "1.2.3",
  "environment_name": "production",
  "status": "completed",
  "deployed_at": "2025-11-06T15:30:00Z",
  "deployed_by": "john.doe"
}
```

### Examples

=== "Success"

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

=== "Failed"

    ```bash
    curl -X POST https://api.versioner.io/deployment-events/ \
      -H "Authorization: Bearer $VERSIONER_API_KEY" \
      -H "Content-Type: application/json" \
      -d '{
        "product_name": "my-service",
        "version": "1.2.3",
        "environment_name": "production",
        "status": "failed",
        "extra_metadata": {
          "error": "Lambda timeout after 30s",
          "error_code": "TIMEOUT"
        }
      }'
    ```

=== "With Full Metadata"

    ```bash
    curl -X POST https://api.versioner.io/deployment-events/ \
      -H "Authorization: Bearer $VERSIONER_API_KEY" \
      -H "Content-Type: application/json" \
      -d '{
        "product_name": "my-service",
        "version": "1.2.3",
        "environment_name": "production",
        "status": "success",
        "deployed_by": "john.doe",
        "scm_branch": "main",
        "scm_sha": "abc123def456",
        "scm_repository": "github.com/mycompany/my-service",
        "build_url": "https://github.com/mycompany/my-service/actions/runs/123",
        "build_number": "456",
        "source_system": "github",
        "extra_metadata": {
          "deployment_duration_seconds": 120,
          "deployment_method": "terraform"
        }
      }'
    ```

## Build Events

Track builds and version creation.

### Submit Build Event

```http
POST /build-events/
```

**Request Body:**

```json
{
  "product_name": "my-service",
  "version": "1.2.3",
  "status": "completed",
  "built_by": "github-actions",
  "scm_branch": "main",
  "scm_sha": "abc123def456",
  "build_url": "https://github.com/...",
  "extra_metadata": {
    "build_duration_seconds": 180,
    "docker_image": "mycompany/my-service:1.2.3"
  }
}
```

**Required Fields:**

| Field | Type | Description |
|-------|------|-------------|
| `product_name` | string | Name of the product/service |
| `version` | string | Version being built |
| `status` | string | Build status (see below) |

**Optional Fields:**

| Field | Type | Description |
|-------|------|-------------|
| `built_by` | string | User/system that triggered build |
| `scm_branch` | string | Git branch |
| `scm_sha` | string | Git commit SHA |
| `scm_repository` | string | Repository URL |
| `build_url` | string | Link to CI/CD build |
| `build_number` | string | CI/CD build number |
| `source_system` | string | CI/CD system name |
| `invoke_id` | string | Unique run/invocation ID |
| `extra_metadata` | object | Custom metadata (JSON) |

**Status Values:**

| Status | Maps To | Description |
|--------|---------|-------------|
| `started`, `in_progress`, `building` | `build.started` | Build in progress |
| `success`, `completed`, `built` | `build.completed` | Build succeeded |
| `failed`, `failure`, `error` | `build.failed` | Build failed |
| `aborted`, `cancelled`, `skipped` | `build.aborted` | Build cancelled |

**Response:** `200 OK`

```json
{
  "id": "660e8400-e29b-41d4-a716-446655440001",
  "product_name": "my-service",
  "version": "1.2.3",
  "status": "completed",
  "created_at": "2025-11-06T15:25:00Z"
}
```

### Examples

=== "Success"

    ```bash
    curl -X POST https://api.versioner.io/build-events/ \
      -H "Authorization: Bearer $VERSIONER_API_KEY" \
      -H "Content-Type: application/json" \
      -d '{
        "product_name": "my-service",
        "version": "1.2.3",
        "status": "completed",
        "built_by": "github-actions",
        "scm_sha": "abc123def456"
      }'
    ```

=== "Failed"

    ```bash
    curl -X POST https://api.versioner.io/build-events/ \
      -H "Authorization: Bearer $VERSIONER_API_KEY" \
      -H "Content-Type: application/json" \
      -d '{
        "product_name": "my-service",
        "version": "1.2.3",
        "status": "failed",
        "extra_metadata": {
          "error": "Compilation failed",
          "exit_code": 1
        }
      }'
    ```

=== "With Full Metadata"

    ```bash
    curl -X POST https://api.versioner.io/build-events/ \
      -H "Authorization: Bearer $VERSIONER_API_KEY" \
      -H "Content-Type: application/json" \
      -d '{
        "product_name": "my-service",
        "version": "1.2.3",
        "status": "completed",
        "built_by": "github-actions",
        "scm_branch": "main",
        "scm_sha": "abc123def456",
        "scm_repository": "github.com/mycompany/my-service",
        "build_url": "https://github.com/mycompany/my-service/actions/runs/123",
        "build_number": "456",
        "source_system": "github",
        "extra_metadata": {
          "build_duration_seconds": 180,
          "docker_image": "mycompany/my-service:1.2.3",
          "test_coverage": "85%"
        }
      }'
    ```

## Auto-Creation Behavior

### Products and Environments

Products and environments are **automatically created** when you submit events:

```bash
# First deployment creates:
# - Product: "my-service"
# - Environment: "production"
# - Version: "1.2.3"
POST /deployment-events/
{
  "product_name": "my-service",
  "version": "1.2.3",
  "environment_name": "production",
  "status": "success"
}
```

No need to pre-create entities - just start tracking!

### Version Immutability

Versions are **immutable** once created:

```bash
# First build creates version with SHA abc123
POST /build-events/
{
  "product_name": "my-service",
  "version": "1.2.3",
  "scm_sha": "abc123",
  "status": "completed"
}

# Attempting to create same version with different SHA fails
POST /build-events/
{
  "product_name": "my-service",
  "version": "1.2.3",
  "scm_sha": "def456",  # Different SHA!
  "status": "completed"
}
# Returns: 409 Conflict
```

This ensures version integrity - the same version number always refers to the same code.

## Common Workflows

### Track Build and Deployment

```bash
# 1. Build starts
POST /build-events/
{
  "product_name": "my-service",
  "version": "1.2.3",
  "status": "started"
}

# 2. Build completes
POST /build-events/
{
  "product_name": "my-service",
  "version": "1.2.3",
  "status": "completed",
  "scm_sha": "abc123"
}

# 3. Deploy to staging
POST /deployment-events/
{
  "product_name": "my-service",
  "version": "1.2.3",
  "environment_name": "staging",
  "status": "success"
}

# 4. Deploy to production
POST /deployment-events/
{
  "product_name": "my-service",
  "version": "1.2.3",
  "environment_name": "production",
  "status": "success"
}
```

### Track Deployment Lifecycle

```bash
# 1. Deployment queued
POST /deployment-events/
{
  "product_name": "my-service",
  "version": "1.2.3",
  "environment_name": "production",
  "status": "pending"
}

# 2. Deployment starts
POST /deployment-events/
{
  "product_name": "my-service",
  "version": "1.2.3",
  "environment_name": "production",
  "status": "started"
}

# 3. Deployment completes
POST /deployment-events/
{
  "product_name": "my-service",
  "version": "1.2.3",
  "environment_name": "production",
  "status": "success"
}
```

## Error Handling

### 400 Bad Request

Missing or invalid fields:

```json
{
  "detail": "Field 'product_name' is required"
}
```

### 401 Unauthorized

Invalid or missing API key:

```json
{
  "detail": "Invalid API key"
}
```

### 409 Conflict

Version immutability violation:

```json
{
  "detail": "Version 1.2.3 already exists with different SHA"
}
```

See [Response Codes](response-codes.md) for complete reference.

## Best Practices

### 1. Include Source Control Info

Always include git metadata when available:

```json
{
  "scm_branch": "main",
  "scm_sha": "abc123def456",
  "scm_repository": "github.com/mycompany/my-service"
}
```

This enables traceability and links to source code.

### 2. Track All States

Track deployments from start to finish:

```bash
# Start
POST /deployment-events/ { "status": "started" }

# Complete
POST /deployment-events/ { "status": "success" }
```

This provides visibility into deployment duration and in-progress state.

### 3. Include Error Details

For failures, include error information:

```json
{
  "status": "failed",
  "extra_metadata": {
    "error": "Connection timeout",
    "error_code": "TIMEOUT",
    "stack_trace": "..."
  }
}
```

This helps with debugging and incident response.

### 4. Use Consistent Status Values

Pick one status value and stick with it:

✅ **Good:** Always use `"success"`  
❌ **Avoid:** Mix of `"success"`, `"completed"`, `"finished"`

### 5. Add Custom Metadata

Use `extra_metadata` for custom tracking:

```json
{
  "extra_metadata": {
    "deployment_method": "terraform",
    "terraform_workspace": "prod",
    "deployment_duration_seconds": 120,
    "rollback_enabled": true
  }
}
```

## Integration Examples

### GitHub Actions

```yaml
- name: Track Deployment
  run: |
    curl -X POST https://api.versioner.io/deployment-events/ \
      -H "Authorization: Bearer ${{ secrets.VERSIONER_API_KEY }}" \
      -H "Content-Type: application/json" \
      -d '{
        "product_name": "my-service",
        "version": "${{ github.sha }}",
        "environment_name": "production",
        "status": "success",
        "deployed_by": "${{ github.actor }}",
        "scm_branch": "${{ github.ref_name }}",
        "scm_sha": "${{ github.sha }}",
        "build_url": "${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }}"
      }'
```

### Jenkins

```groovy
sh """
  curl -X POST https://api.versioner.io/deployment-events/ \\
    -H "Authorization: Bearer ${VERSIONER_API_KEY}" \\
    -H "Content-Type: application/json" \\
    -d '{
      "product_name": "my-service",
      "version": "${BUILD_NUMBER}",
      "environment_name": "production",
      "status": "success",
      "deployed_by": "${BUILD_USER}",
      "build_url": "${BUILD_URL}"
    }'
"""
```

### GitLab CI

```yaml
deploy:
  script:
    - |
      curl -X POST https://api.versioner.io/deployment-events/ \
        -H "Authorization: Bearer $VERSIONER_API_KEY" \
        -H "Content-Type: application/json" \
        -d '{
          "product_name": "my-service",
          "version": "'$CI_COMMIT_SHORT_SHA'",
          "environment_name": "production",
          "status": "success",
          "deployed_by": "'$GITLAB_USER_LOGIN'",
          "scm_branch": "'$CI_COMMIT_REF_NAME'",
          "scm_sha": "'$CI_COMMIT_SHA'",
          "build_url": "'$CI_JOB_URL'"
        }'
```

## Next Steps

- **Easier integration:** Use the [CLI](../cli/index.md) or [GitHub Action](../integrations/github-action.md)
- **Event types:** See [Event Types](event-types.md) for all status values
- **Error handling:** Review [Response Codes](response-codes.md)
- **Notifications:** Set up [Slack notifications](../concepts/notifications.md)
