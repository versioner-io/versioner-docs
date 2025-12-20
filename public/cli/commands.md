# Command Reference

Complete reference for all Versioner CLI commands.

## Global Options

These options work with all commands:

| Option | Description | Default |
|--------|-------------|---------|
| `--api-key` | Versioner API key | `$VERSIONER_API_KEY` |
| `--api-url` | API base URL | `https://api.versioner.io` |
| `--fail-on-api-error` | Fail command if API is unreachable or returns auth/validation errors | `true` |
| `--verbose` | Verbose output | `false` |
| `--debug` | Debug output (includes HTTP requests/responses) | `false` |
| `--help` | Show help | - |

## track build

Submit a build event to track when a version is built.

### Usage

```bash
versioner track build [OPTIONS]
```

### Options

| Option | Required | Description |
|--------|----------|-------------|
| `--product` | Yes | Product/service name |
| `--version` | No* | Version being built |
| `--status` | No | Build status (default: `completed`) |
| `--built-by` | No | User/system that built the version |
| `--built-by-email` | No | Email of user who built |
| `--scm-repository` | No | Git repository (e.g., `owner/repo`) |
| `--scm-branch` | No | Git branch name |
| `--scm-sha` | No | Git commit SHA |
| `--build-number` | No | Build number from CI system |
| `--build-url` | No | Link to build in CI system |
| `--invoke-id` | No | Unique invocation ID |
| `--fail-on-api-error` | No | Fail command if API errors occur (default: `true`) |

\* Auto-detected in CI/CD systems. See [CI/CD Integration](ci-cd-systems.md).

### Status Values

- `started` - Build has started
- `completed` - Build completed successfully
- `failed` - Build failed
- `aborted` - Build was aborted/cancelled

### Examples

**Basic build tracking:**

```bash
versioner track build \
  --product my-api \
  --version 1.2.3 \
  --status completed
```

**With full metadata:**

```bash
versioner track build \
  --product my-api \
  --version 1.2.3 \
  --status completed \
  --built-by john.doe \
  --built-by-email john.doe@example.com \
  --scm-repository myorg/my-api \
  --scm-branch main \
  --scm-sha abc123def456 \
  --build-number 42 \
  --build-url https://ci.example.com/builds/42
```

**Track build start and completion:**

```bash
# Build started
versioner track build \
  --product my-api \
  --version 1.2.3 \
  --status started

# ... build happens ...

# Build completed
versioner track build \
  --product my-api \
  --version 1.2.3 \
  --status completed
```

**In CI/CD (auto-detection):**

```bash
# Many fields auto-detected from CI environment
versioner track build \
  --product my-api \
  --status completed
```

---

## track deployment

Submit a deployment event to track when a version is deployed to an environment.

### Usage

```bash
versioner track deployment [OPTIONS]
```

### Options

| Option | Required | Description |
|--------|----------|-------------|
| `--product` | Yes | Product/service name |
| `--environment` | Yes | Target environment (e.g., `production`, `staging`) |
| `--version` | No* | Version being deployed |
| `--status` | No | Deployment status (default: `completed`) |
| `--deployed-by` | No | User who deployed |
| `--deployed-by-email` | No | Email of user who deployed |
| `--scm-repository` | No | Git repository (e.g., `owner/repo`) |
| `--scm-branch` | No | Git branch name |
| `--scm-sha` | No | Git commit SHA |
| `--build-number` | No | Build number from CI system |
| `--build-url` | No | Link to build in CI system |
| `--invoke-id` | No | Unique invocation ID |
| `--fail-on-api-error` | No | Fail command if API errors occur (default: `true`) |

\* Auto-detected in CI/CD systems. See [CI/CD Integration](ci-cd-systems.md).

### Status Values

- `pending` - Deployment is pending/queued
- `started` - Deployment has started (triggers preflight checks)
- `completed` - Deployment completed successfully
- `failed` - Deployment failed
- `aborted` - Deployment was aborted/cancelled

### Examples

**Basic deployment tracking:**

```bash
versioner track deployment \
  --product my-api \
  --environment production \
  --version 1.2.3 \
  --status completed
```

**With full metadata:**

```bash
versioner track deployment \
  --product my-api \
  --environment production \
  --version 1.2.3 \
  --status completed \
  --deployed-by john.doe \
  --deployed-by-email john.doe@example.com \
  --scm-repository myorg/my-api \
  --scm-branch main \
  --scm-sha abc123def456 \
  --build-url https://ci.example.com/builds/42
```

**Track deployment lifecycle:**

```bash
# Deployment started
versioner track deployment \
  --product my-api \
  --environment production \
  --version 1.2.3 \
  --status started

# ... deployment happens ...

# Deployment completed
versioner track deployment \
  --product my-api \
  --environment production \
  --version 1.2.3 \
  --status completed
```

**Handle failures:**

```bash
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

**In CI/CD (auto-detection):**

```bash
# Many fields auto-detected from CI environment
versioner track deployment \
  --product my-api \
  --environment production \
  --status completed
```

---

## version

Display CLI version information.

### Usage

```bash
versioner version
```

### Example Output

```
Versioner CLI v1.0.0
Commit: abc123
Build Date: 2025-11-06T12:00:00Z
```

---

## Best Practices

### 1. Track All Stages

Track when deployments start and when they complete to get accurate timing data:

```bash
# Start
versioner track deployment --status started ...

# Complete
versioner track deployment --status completed ...
```

### 2. Include Metadata

Provide as much context as possible for better visibility:

```bash
versioner track deployment \
  --product my-api \
  --environment production \
  --version 1.2.3 \
  --deployed-by $USER \
  --scm-branch main \
  --scm-sha abc123 \
  --build-url https://ci.example.com/builds/42
```

### 3. Use Environment Variables

Store your API key in environment variables, not in scripts:

```bash
export VERSIONER_API_KEY="sk_mycompany_k1_..."
versioner track deployment ...
```

### 4. Leverage Auto-Detection

In CI/CD systems, let the CLI auto-detect metadata:

```bash
# Auto-detects: repository, SHA, branch, build number, user, etc.
versioner track build --product my-api --status completed
```

See [CI/CD Integration](ci-cd-systems.md) for details on what's auto-detected in each system.

---

## Exit Codes

| Code | Description |
|------|-------------|
| `0` | Success |
| `1` | General error (network issues, invalid arguments) |
| `4` | API error (authentication, validation) |
| `5` | Preflight check failure (deployment blocked) |

### Example: Check Exit Code

```bash
if versioner track deployment --product my-api --environment production --status completed; then
  echo "Deployment tracked successfully"
else
  echo "Failed to track deployment (exit code: $?)"
  exit 1
fi
```

---

## Next Steps

- [CI/CD Integration](ci-cd-systems.md) - Auto-detect metadata in CI/CD systems
- [Configuration](configuration.md) - Advanced configuration options
- [Installation](installation.md) - Installation and setup guide
