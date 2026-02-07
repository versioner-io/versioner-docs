# CLI Overview

The **Versioner CLI** is a command-line tool for tracking deployments and builds from any CI/CD system or deployment environment.

## What is the CLI?

A single-binary tool that submits deployment and build events to Versioner from any CI/CD system, IaC tool, or custom script.

## When to Use the CLI

**Use the CLI when:**

- Your CI/CD system doesn't have a [native integration](../integrations/index.md)
- You're deploying from scripts or IaC tools (Terraform, Ansible, etc.)
- You need maximum flexibility for custom workflows

## Key Features

### 🚀 Easy Installation

Single static binary with no dependencies. See the [Installation](installation.md) guide for all platforms.

### 🔍 Auto-Detection

Automatically detects build numbers, Git SHAs, branches, deployer info, and build URLs. See [CI/CD Systems](ci-cd/index.md) for details.

### ⚙️ Flexible Configuration

Configure via environment variables or command-line flags.

### 🔄 Retry Logic

Built-in retry with exponential backoff for reliable event delivery.

### 🛡️ Secure by Default

API keys via environment variables, security warnings for unsafe usage, and no credentials stored on disk.

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

*Additional metadata is auto-detected based on your CI/CD system.*

## Next Steps

1. **[Install the CLI](installation.md)** - Download and install
2. **[Learn usage](usage.md)** - Commands and configuration
3. **[Set up CI/CD integration](ci-cd/index.md)** - Auto-detect metadata in your CI/CD system

## Support

- **CLI Issues:** [GitHub Issues](https://github.com/versioner-io/versioner-cli/issues)
- **Documentation:** You're reading it!
- **API Reference:** [Interactive API Docs](../api/interactive-docs.md)
