# Configuration

Advanced configuration options for the Versioner CLI.

## Environment Variables

Configure the CLI using environment variables.

| Variable | Description | Default |
|----------|-------------|---------|
| `VERSIONER_API_KEY` | API key for authentication | - |
| `VERSIONER_API_URL` | API base URL | `https://api.versioner.io` |
| `VERSIONER_FAIL_ON_API_ERROR` | Fail command if API errors occur | `true` |

### Set Environment Variables

**Temporary (current session):**

```bash
export VERSIONER_API_KEY="sk_mycompany_k1_..."
export VERSIONER_API_URL="https://api.versioner.io"
export VERSIONER_FAIL_ON_API_ERROR=true
```

**Permanent (add to shell profile):**

```bash
# For bash
echo 'export VERSIONER_API_KEY="sk_mycompany_k1_..."' >> ~/.bashrc

# For zsh
echo 'export VERSIONER_API_KEY="sk_mycompany_k1_..."' >> ~/.zshrc
```

## Configuration Priority

When the CLI determines configuration values, it uses this priority order:

1. **Command-line flags** (highest priority)
2. **Environment variables**
3. **CI/CD auto-detection**
4. **Defaults** (lowest priority)

### Example

```bash
# API key from environment variable
export VERSIONER_API_KEY="sk_env_key"

# Override with command-line flag
versioner track deployment --api-key sk_flag_key ...
# Uses: sk_flag_key (flag takes precedence)
```

## Field Auto-Detection

In CI/CD environments, many fields are automatically detected. You can always override auto-detected values with flags.

### Example: Override Auto-Detection

```bash
# In GitHub Actions, SHA is auto-detected from GITHUB_SHA
# But you can override it:
versioner track build \
  --product my-api \
  --scm-sha custom-sha-value \
  --status completed
```

See [CI/CD Integration](ci-cd-systems.md) for details on what's auto-detected in each system.

## API Error Handling

Control how the CLI handles API connectivity and authentication errors.

### `--fail-on-api-error` Flag

**Default:** `true` (API errors fail the command)

**Purpose:** Controls whether API connectivity/authentication errors should block deployments.

**Use Cases:**

**Mission-Critical Audit Trail (Default):**
```bash
# Every deployment MUST be recorded
versioner track deployment \
  --product my-api \
  --environment production \
  --version 1.2.3 \
  --status completed \
  --fail-on-api-error=true  # Default behavior
```

**Best-Effort Observability:**
```bash
# Recording is nice-to-have, don't block production deployments
versioner track deployment \
  --product my-api \
  --environment production \
  --version 1.2.3 \
  --status completed \
  --fail-on-api-error=false
```

**Environment Variable:**
```bash
export VERSIONER_FAIL_ON_API_ERROR=false
versioner track deployment ...
```

**Affected Error Types:**
- 401 (Authentication failed)
- 403 (Authorization failed)
- 404 (Endpoint not found)
- 422 (Validation error)
- Connection refused
- Request timeout
- Other HTTP errors

!!! note "Preflight Checks"
    Preflight check rejections (409, 423, 428) always fail regardless of this flag. Policy enforcement is controlled server-side via rule status settings in the Versioner UI.

## Custom API Endpoint

To use a different API endpoint (e.g., for testing or self-hosted):

```bash
export VERSIONER_API_URL="https://custom-api.example.com"
```

Or use the flag:

```bash
versioner track deployment \
  --api-url https://custom-api.example.com \
  --product my-api \
  --environment production \
  --status completed
```

## Verbose and Debug Output

### Verbose Mode

Show detailed information about what the CLI is doing:

```bash
versioner track deployment \
  --product my-api \
  --environment production \
  --status completed \
  --verbose
```

Example output:
```
Auto-detected CI/CD system: github
Auto-detected repository: myorg/my-api
Auto-detected SHA: abc123def456
Auto-detected branch: main
Tracking deployment...
✓ Deployment tracked successfully
```

### Debug Mode

Show HTTP requests and responses for troubleshooting:

```bash
versioner track deployment \
  --product my-api \
  --environment production \
  --status completed \
  --debug
```

Example output:
```
POST https://api.versioner.io/v1/deployments
Headers:
  Authorization: Bearer sk_***
  Content-Type: application/json
Body:
  {"product_name":"my-api","environment_name":"production",...}

Response: 201 Created
{"id":"550e8400-e29b-41d4-a716-446655440000",...}
```

## Exit Codes

The CLI uses standard exit codes to indicate success or failure.

| Code | Description | Example Scenario |
|------|-------------|------------------|
| `0` | Success | Deployment tracked successfully |
| `1` | General error | Network error, unexpected failure |
| `4` | API error | Authentication, validation, server errors |
| `5` | Preflight check failure | Deployment blocked by policy rules |

### Using Exit Codes in Scripts

```bash
#!/bin/bash

if versioner track deployment \
  --product my-api \
  --environment production \
  --status completed; then
  echo "✓ Deployment tracked"
else
  exit_code=$?
  echo "✗ Failed to track deployment (exit code: $exit_code)"
  exit $exit_code
fi
```

### CI/CD Integration

Most CI/CD systems will automatically fail the build/deployment if a command exits with a non-zero code:

```yaml
# GitHub Actions - automatically fails if exit code != 0
- name: Track Deployment
  run: versioner track deployment --product my-api --environment production --status completed
```

## Retry Logic

The CLI includes built-in retry logic with exponential backoff for transient failures.

### Retry Behavior

- **Retries:** Up to 3 attempts
- **Backoff:** Exponential (1s, 2s, 4s)
- **Retryable errors:** Network errors, 5xx server errors, rate limits

### Example

```bash
versioner track deployment ...
# If request fails with 503 Service Unavailable:
# - Retry 1 after 1 second
# - Retry 2 after 2 seconds
# - Retry 3 after 4 seconds
# - If still failing, exit with error code 4
```

## Security Best Practices

### 1. Never Hardcode API Keys

❌ **Bad:**
```bash
versioner track deployment --api-key sk_mycompany_k1_abc123 ...
```

✅ **Good:**
```bash
export VERSIONER_API_KEY="sk_mycompany_k1_abc123"
versioner track deployment ...
```

### 2. Use Secrets Management in CI/CD

Store API keys as encrypted secrets in your CI/CD system:

**GitHub Actions:**
```yaml
env:
  VERSIONER_API_KEY: ${{ secrets.VERSIONER_API_KEY }}
```

**GitLab CI:**
```yaml
variables:
  VERSIONER_API_KEY: $VERSIONER_API_KEY  # Set in CI/CD settings
```

**Jenkins:**
```groovy
withCredentials([string(credentialsId: 'versioner-api-key', variable: 'VERSIONER_API_KEY')]) {
  sh 'versioner track deployment ...'
}
```

### 3. Rotate API Keys Regularly

1. Generate a new API key in [app.versioner.io](https://app.versioner.io)
2. Update the key in your CI/CD secrets
3. Delete the old key after verifying the new one works

### 4. Use Separate Keys for Different Environments

Create separate API keys for:
- Production deployments
- Staging/development
- Local testing

This allows you to revoke keys without affecting other environments.

## Troubleshooting

### "401 Unauthorized"

**Problem:** API key is invalid or not set.

**Solution:**
```bash
# Check if API key is set
echo $VERSIONER_API_KEY

# Set API key
export VERSIONER_API_KEY="sk_mycompany_k1_..."

# Verify it works
versioner track deployment --product test --environment dev --status completed --verbose
```

### "403 Forbidden"

**Problem:** API key doesn't have permission for the requested operation.

**Solution:**
- Verify the API key is for the correct organization
- Check that the API key hasn't been revoked
- Generate a new API key if needed

### "Connection refused" or "Network error"

**Problem:** Cannot connect to API endpoint.

**Solution:**
```bash
# Check API URL
echo $VERSIONER_API_URL

# Test connectivity
curl https://api.versioner.io/health

# Check if behind proxy
echo $HTTP_PROXY
echo $HTTPS_PROXY
```

### "Missing required field"

**Problem:** Required field not provided and not auto-detected.

**Solution:**
```bash
# Use --verbose to see what's auto-detected
versioner track deployment --verbose ...

# Provide missing fields explicitly
versioner track deployment \
  --product my-api \
  --environment production \
  --version 1.2.3 \
  --status completed
```

## Next Steps

- [Command Reference](commands.md) - Learn all available commands
- [CI/CD Integration](ci-cd-systems.md) - Auto-detect metadata in CI/CD systems
- [Installation](installation.md) - Installation and setup guide
