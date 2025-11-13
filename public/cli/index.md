# CLI Overview

The **Versioner CLI** is a command-line tool for tracking deployments and builds from any CI/CD system or deployment environment.

## What is the CLI?

The Versioner CLI is a single-binary tool written in Go that lets you submit deployment and build events to Versioner from:

- **Any CI/CD system** - Jenkins, GitLab CI, CircleCI, Bitbucket Pipelines, Azure DevOps, Travis CI
- **Infrastructure as Code** - Terraform, Ansible, CloudFormation
- **Deployment tools** - Rundeck, custom scripts, manual deployments
- **Local development** - Test integrations before deploying

## When to Use the CLI

### Use the CLI When:

✅ **Your CI/CD system doesn't have a native integration**
- Jenkins, GitLab CI, CircleCI, etc.
- No official Versioner plugin available

✅ **You're deploying from scripts or IaC tools**
- Terraform deployments
- Custom deployment scripts
- Infrastructure automation

✅ **You need maximum flexibility**
- Custom workflows
- Non-standard deployment processes
- Local testing and development

### Use Native Integrations When Available:

🎯 **GitHub Actions** → Use the [Versioner GitHub Action](../integrations/github-action.md)
- Tighter integration with GitHub workflows
- Automatic metadata extraction
- Simpler configuration

## Key Features

### 🚀 Easy Installation

Single static binary with no dependencies:

```bash
curl -L https://github.com/versioner-io/versioner-cli/releases/latest/download/versioner-linux-amd64 -o versioner
chmod +x versioner
sudo mv versioner /usr/local/bin/
```

!!! info "Full installation docs"
    See examples for all platforms on the [Installation](installation.md) page.

### 🔍 Auto-Detection

Automatically detects CI/CD metadata:

- Build numbers
- Git commit SHAs
- Branch names
- Deployer information
- Build URLs

**Supports:** GitHub Actions, GitLab CI, Jenkins, CircleCI, Bitbucket, Azure DevOps, Travis CI, Rundeck

### ⚙️ Flexible Configuration

Configure via:

- Environment variables (`VERSIONER_*`)
- Command-line flags
- Config files (coming soon)

### 🔄 Retry Logic

Built-in retry with exponential backoff ensures events are delivered even in unstable network conditions.

### 🛡️ Secure by Default

- API keys via environment variables (not exposed in process lists)
- Security warnings if keys passed as flags
- No credentials stored on disk

## Quick Example

Track a deployment in any CI/CD system:

```bash
# Set your API key
export VERSIONER_API_KEY="sk_mycompany_k1_..."

# Track a deployment
versioner track deployment \
  --product my-service \
  --version 1.2.3 \
  --environment production \
  --status success
```

Depending on the CI/CD system, the CLI can automatically detect things like:

- Who deployed it
- Build number
- Git commit SHA
- Build URL

## Use Cases

### Jenkins Pipeline

```groovy
pipeline {
    agent any
    stages {
        stage('Deploy') {
            steps {
                sh './deploy.sh'
                sh '''
                    versioner track deployment \
                        --product my-service \
                        --version ${BUILD_NUMBER} \
                        --environment production \
                        --status success
                '''
            }
        }
    }
}
```

### Terraform Deployment

```bash
#!/bin/bash
# deploy.sh

terraform apply -auto-approve

versioner track deployment \
  --product infrastructure \
  --version $(git rev-parse --short HEAD) \
  --environment production \
  --status success \
  --extra-metadata '{"terraform_workspace":"prod"}'
```

### GitLab CI

```yaml
deploy:
  stage: deploy
  script:
    - ./deploy.sh
    - |
      versioner track deployment \
        --product my-service \
        --version $CI_COMMIT_SHORT_SHA \
        --environment production \
        --status success
```

## Architecture

The CLI is designed to be:

- **Lightweight** - Single binary, minimal resource usage
- **Portable** - Works on Linux, macOS, Windows
- **Resilient** - Retries on failure, doesn't block deployments
- **Transparent** - Clear error messages and exit codes

## Getting Started

Ready to use the CLI? Follow these steps:

1. **[Install](installation.md)** - Download and install the CLI
2. **[Commands](commands.md)** - Learn the available commands
3. **[CI/CD Integration](ci-cd-systems.md)** - Set up auto-detection for your CI/CD system
4. **[Configuration](configuration.md)** - Advanced configuration options

## Comparison: CLI vs. GitHub Action

| Feature | CLI | GitHub Action |
|---------|-----|---------------|
| **Platform** | Any CI/CD system | GitHub Actions only |
| **Installation** | Download binary | Add to workflow YAML |
| **Auto-detection** | 8 CI/CD systems | GitHub-specific metadata |
| **Flexibility** | Maximum | GitHub workflows |
| **Best for** | Jenkins, GitLab, scripts | GitHub repositories |

Both tools submit the same events to Versioner - choose based on your deployment platform.

## Support

- **CLI Issues:** [GitHub Issues](https://github.com/versioner-io/versioner-cli/issues)
- **Documentation:** You're reading it!
- **API Reference:** [Interactive API Docs](../api/interactive-docs.md)

## Next Steps

- [Install the CLI](installation.md)
- [Learn the commands](commands.md)
- [Set up CI/CD integration](ci-cd-systems.md)
