# CLI Usage

## Configuration

### Global Options

These options work with all commands:

| Option | Description | Default |
|--------|-------------|---------|
| `--api-key` | Versioner API key | `$VERSIONER_API_KEY` |
| `--api-url` | API base URL | `https://api.versioner.io` |
| `--fail-on-api-error` | Fail command if API errors occur | `true` |
| `--verbose` | Verbose output | `false` |
| `--debug` | Debug output (includes HTTP requests/responses) | `false` |

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `VERSIONER_API_KEY` | API key for authentication | — |
| `VERSIONER_API_URL` | API base URL | `https://api.versioner.io` |
| `VERSIONER_FAIL_ON_API_ERROR` | Fail command if API errors occur | `true` |

### Configuration Priority

Configuration values are resolved in this order:

1. **Command-line flags** (highest priority)
2. **Environment variables**
3. **CI/CD auto-detection**
4. **Defaults** (lowest priority)

---

## Commands

### track deployment

Emit a `started` event **before** your deployment script runs and Versioner will evaluate any open [Deployment Requests](../concepts/deployment-requests.md) or matching [Deployment Rules](../concepts/deployment-rules.md). If the deployment violates a policy (no-deploy window, missing approval, flow violation), the CLI exits with a non-zero code and your pipeline fails before anything is deployed. Emit a `completed` or `failed` event after the deployment finishes to close out the record.

```bash
versioner track deployment [OPTIONS]
```

| Option | Description | Default |
|--------|-------------|---------|
| `--product` *(required)* | Product/service name | — |
| `--environment` *(required)* | Target environment (e.g., `production`, `staging`) | — |
| `--version` | Version being deployed | Auto-detected in CI/CD |
| `--status` | Deployment status (see valid values below) | `completed` |
| `--deployed-by` | User who deployed | Auto-detected in CI/CD |
| `--deployed-by-email` | Email of user who deployed | Auto-detected in CI/CD |
| `--scm-repository` | Git repository (e.g., `owner/repo`) | Auto-detected in CI/CD |
| `--scm-branch` | Git branch name | Auto-detected in CI/CD |
| `--scm-sha` | Git commit SHA | Auto-detected in CI/CD |
| `--build-number` | Build number from CI system | Auto-detected in CI/CD |
| `--build-url` | Link to build in CI system | Auto-detected in CI/CD |

!!! warning "Valid `--status` Values"
    - `pending` — Deployment is pending/queued
    - `started` — Deployment has started
    - `completed` — Deployment completed successfully
    - `failed` — Deployment failed
    - `aborted` — Deployment was aborted/cancelled

**Example — basic tracking:**

```bash
versioner track deployment \
  --product my-api \
  --environment production \
  --version 1.2.3 \
  --status completed
```

**Example — full pre/post-deploy pattern:**

Send `started` before deploying so Versioner can block on policy violations, then send `completed` or `failed` based on the result.

```bash
versioner track deployment \
  --product my-api \
  --environment production \
  --version 1.2.3 \
  --status started

if ./deploy.sh production; then
  versioner track deployment \
    --product my-api \
    --environment production \
    --version 1.2.3 \
    --status completed
else
  versioner track deployment \
    --product my-api \
    --environment production \
    --version 1.2.3 \
    --status failed
  exit 1
fi
```

---

### track build

Tracking builds registers a **version** in Versioner. Versions are the unit Versioner uses for deployment tracking and notifications. When a build completes, Versioner can notify your team with the version that's ready to deploy. If you've set up [Deployment Buttons](../concepts/deployment-buttons.md), that notification becomes actionable: one click deploys directly from the notification or the dashboard.

```bash
versioner track build [OPTIONS]
```

| Option | Description | Default |
|--------|-------------|---------|
| `--product` *(required)* | Product/service name | — |
| `--version` | Version being built | Auto-detected in CI/CD |
| `--status` | Build status (see valid values below) | `completed` |
| `--built-by` | User/system that built the version | Auto-detected in CI/CD |
| `--built-by-email` | Email of user who built | Auto-detected in CI/CD |
| `--scm-repository` | Git repository (e.g., `owner/repo`) | Auto-detected in CI/CD |
| `--scm-branch` | Git branch name | Auto-detected in CI/CD |
| `--scm-sha` | Git commit SHA | Auto-detected in CI/CD |
| `--build-number` | Build number from CI system | Auto-detected in CI/CD |
| `--build-url` | Link to build in CI system | Auto-detected in CI/CD |

!!! warning "Valid `--status` Values"
    - `started` — Build has started
    - `completed` — Build completed successfully
    - `failed` — Build failed
    - `aborted` — Build was aborted/cancelled

**Example:**

```bash
versioner track build \
  --product my-api \
  --version 1.2.3 \
  --status completed
```

---

### version

Display CLI version information.

```bash
versioner version
```

---

## Error Handling

### Exit Codes

| Code | Description |
|------|-------------|
| `0` | Success |
| `1` | General error (network issues, invalid arguments) |
| `4` | API error (authentication, validation) |
| `5` | Deployment Rule violation (deployment blocked by policy) |

### API Errors

The `--fail-on-api-error` flag controls whether API errors block your deployment (default: `true`).

```bash
# Mission-critical: deployment MUST be recorded
versioner track deployment --product my-api --environment production --fail-on-api-error=true

# Best-effort: don't block deployments if API is down
versioner track deployment --product my-api --environment production --fail-on-api-error=false
```

!!! note "Deployment Rule Violations"
    Rule violations (exit code 5) always fail regardless of this flag. See [Deployment Rules](../concepts/deployment-rules.md).

---

## Debugging

Use `--verbose` to see auto-detected values or `--debug` to see full HTTP traffic:

```bash
# See what's being auto-detected
versioner track deployment --product my-api --environment production --verbose

# See full HTTP traffic
versioner track deployment --product my-api --environment production --debug
```

---

## Security

**Always use environment variables for API keys:**

```bash
# Good
export VERSIONER_API_KEY="sk_mycompany_k1_..."
versioner track deployment ...

# Bad - exposed in process lists
versioner track deployment --api-key sk_mycompany_k1_...
```

**Use your CI/CD system's secrets management:**

- GitHub Actions: `${{ secrets.VERSIONER_API_KEY }}`
- GitLab CI: Set in CI/CD settings
- Jenkins: Use `withCredentials`

**Rotate keys regularly** at [app.versioner.io](https://app.versioner.io)
