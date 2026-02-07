# CI/CD Integration

The Versioner CLI automatically detects your CI/CD environment and extracts relevant metadata, reducing the number of flags you need to specify.

## Supported Systems

The CLI supports auto-detection for 8 CI/CD systems:

- [GitHub Actions](github-actions.md)
- [GitLab CI](gitlab-ci.md)
- [Jenkins](jenkins.md)
- [CircleCI](circleci.md)
- [Bitbucket Pipelines](bitbucket-pipelines.md)
- [Azure DevOps](azure-devops.md)
- [Travis CI](travis-ci.md)
- [Rundeck](rundeck.md)

## How Auto-Detection Works

When you run the CLI in a supported CI/CD system:

1. **System Detection** - CLI checks environment variables to identify the system
2. **Metadata Extraction** - Automatically populates fields like repository, SHA, build number, user
3. **Override Support** - You can always override auto-detected values with flags

!!! tip "See what's auto-detected"
    Use `--verbose` to see which values were auto-detected:
    ```bash
    versioner track deployment --product=api --environment=production --status=completed --verbose
    ```

## Auto-Detection Comparison

| System | Repository | Git SHA | Branch | Build # | Build URL | User | Email |
|--------|:----------:|:-------:|:------:|:-------:|:---------:|:----:|:-----:|
| **GitHub Actions** | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| **GitLab CI** | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Jenkins** | ✅ | ✅ | ✅ | ✅ | ✅ | ⚠️* | ⚠️* |
| **CircleCI** | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| **Bitbucket** | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| **Azure DevOps** | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Travis CI** | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| **Rundeck** | ❌ | ❌ | ❌ | ✅ | ✅ | ✅ | ❌ |

\* Requires [Build User Vars Plugin](https://plugins.jenkins.io/build-user-vars-plugin/)

## Installation in CI/CD

All examples include CLI download steps. The CLI is a single binary with no dependencies.

**Latest version:**
```bash
curl -L https://github.com/versioner-io/versioner-cli/releases/latest/download/versioner-linux-amd64 -o /usr/local/bin/versioner
chmod +x /usr/local/bin/versioner
```

**Specific version (recommended for production):**
```bash
VERSION=v1.0.3
curl -L https://github.com/versioner-io/versioner-cli/releases/download/${VERSION}/versioner-linux-amd64 -o /usr/local/bin/versioner
chmod +x /usr/local/bin/versioner
```

## Configuration Priority

When the CLI determines field values, it uses this priority order:

1. **CLI Flags** (highest priority) - `--version=1.2.3`
2. **Environment Variables** - `VERSIONER_VERSION=1.2.3`
3. **CI/CD Auto-Detection** - Extracted from CI system
4. **Defaults** (lowest priority)

**Example:**
```bash
# Auto-detected SHA is abc123, but you want to use a different version
versioner track deployment \
  --product=my-api \
  --environment=production \
  --version=1.2.3 \
  --status=completed
# Uses version "1.2.3" instead of auto-detected SHA
```

## Quick Examples

### Track a Build

```bash
# Most fields auto-detected from CI environment
versioner track build \
  --product my-api \
  --status completed
```

### Track a Deployment

```bash
# Most fields auto-detected from CI environment
versioner track deployment \
  --product my-api \
  --environment production \
  --status completed
```

## Next Steps

Choose your CI/CD system to see detailed integration examples:

- [GitHub Actions](github-actions.md)
- [GitLab CI](gitlab-ci.md)
- [Jenkins](jenkins.md)
- [CircleCI](circleci.md)
- [Bitbucket Pipelines](bitbucket-pipelines.md)
- [Azure DevOps](azure-devops.md)
- [Travis CI](travis-ci.md)
- [Rundeck](rundeck.md)
