# CLI Usage

Complete guide to using the Versioner CLI.

## Commands

The CLI provides two main commands for tracking events.

### track deployment

Submit a deployment event to track when a version is deployed to an environment.

```bash
versioner track deployment [OPTIONS]
```

**Required Options:**

| Option | Description |
|--------|-------------|
| `--product` | Product/service name |
| `--environment` | Target environment (e.g., `production`, `staging`) |

**Optional Options:**

| Option | Description | Default |
|--------|-------------|---------|
| `--version` | Version being deployed | Auto-detected in CI/CD |
| `--status` | Deployment status (must be one of the accepted values below) | `completed` |
| `--deployed-by` | User who deployed | Auto-detected in CI/CD |
| `--deployed-by-email` | Email of user who deployed | Auto-detected in CI/CD |
| `--scm-repository` | Git repository (e.g., `owner/repo`) | Auto-detected in CI/CD |
| `--scm-branch` | Git branch name | Auto-detected in CI/CD |
| `--scm-sha` | Git commit SHA | Auto-detected in CI/CD |
| `--build-number` | Build number from CI system | Auto-detected in CI/CD |
| `--build-url` | Link to build in CI system | Auto-detected in CI/CD |

!!! warning "Valid Status Values"
    The `--status` flag **must** be one of these exact values:
    
    - `pending` - Deployment is pending/queued
    - `started` - Deployment has started
    - `completed` - Deployment completed successfully
    - `failed` - Deployment failed
    - `aborted` - Deployment was aborted/cancelled

**Examples:**

```bash
# Basic deployment
versioner track deployment \
  --product my-api \
  --environment production \
  --version 1.2.3 \
  --status completed

# Handle failures
if ./deploy.sh production; then
  versioner track deployment --product my-api --environment production --status completed
else
  versioner track deployment --product my-api --environment production --status failed
  exit 1
fi
```

---

### track build

Submit a build event to track when a version is built.

```bash
versioner track build [OPTIONS]
```

**Required Options:**

| Option | Description |
|--------|-------------|
| `--product` | Product/service name |

**Optional Options:**

| Option | Description | Default |
|--------|-------------|---------|
| `--version` | Version being built | Auto-detected in CI/CD |
| `--status` | Build status (must be one of the accepted values below) | `completed` |
| `--built-by` | User/system that built the version | Auto-detected in CI/CD |
| `--built-by-email` | Email of user who built | Auto-detected in CI/CD |
| `--scm-repository` | Git repository (e.g., `owner/repo`) | Auto-detected in CI/CD |
| `--scm-branch` | Git branch name | Auto-detected in CI/CD |
| `--scm-sha` | Git commit SHA | Auto-detected in CI/CD |
| `--build-number` | Build number from CI system | Auto-detected in CI/CD |
| `--build-url` | Link to build in CI system | Auto-detected in CI/CD |

!!! warning "Valid Status Values"
    The `--status` flag **must** be one of these exact values:
    
    - `started` - Build has started
    - `completed` - Build completed successfully
    - `failed` - Build failed
    - `aborted` - Build was aborted/cancelled

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
| `VERSIONER_API_KEY` | API key for authentication | - |
| `VERSIONER_API_URL` | API base URL | `https://api.versioner.io` |
| `VERSIONER_FAIL_ON_API_ERROR` | Fail command if API errors occur | `true` |

### Configuration Priority

Configuration values are resolved in this order:

1. **Command-line flags** (highest priority)
2. **Environment variables**
3. **CI/CD auto-detection**
4. **Defaults** (lowest priority)

---

## Error Handling

### API Errors

The `--fail-on-api-error` flag controls whether API errors block your deployment (default: `true`).

```bash
# Mission-critical: deployment MUST be recorded
versioner track deployment --product my-api --environment production --fail-on-api-error=true

# Best-effort: don't block deployments if API is down
versioner track deployment --product my-api --environment production --fail-on-api-error=false
```

!!! note "Preflight Checks"
    Preflight check rejections always fail regardless of this flag.

---

### Exit Codes

| Code | Description |
|------|-------------|
| `0` | Success |
| `1` | General error (network issues, invalid arguments) |
| `4` | API error (authentication, validation) |
| `5` | Preflight check failure (deployment blocked) |

---

## Debugging

Use `--verbose` to see auto-detected values or `--debug` to see HTTP requests/responses:

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

---

## Next Steps

- [CI/CD Integration](ci-cd/index.md) - Auto-detect metadata in CI/CD systems
- [Installation](installation.md) - Installation and setup guide
