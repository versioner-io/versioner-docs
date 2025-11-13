# Native Integrations Overview

**Native integrations** are platform-specific plugins and extensions built for popular CI/CD systems and development platforms. They provide the easiest way to integrate Versioner with minimal configuration.

## What are Native Integrations?

Native integrations are pre-built tools that deeply integrate with specific platforms:

- **Platform-native configuration** - Use YAML, HCL, or platform-specific formats
- **Automatic metadata extraction** - No manual configuration of git SHAs, build URLs, etc.
- **Seamless workflow integration** - Works naturally within your existing pipelines
- **Platform-specific features** - Leverage unique capabilities of each platform

## Available Integrations

### GitHub Actions ✅

Official GitHub Action for tracking deployments and builds in GitHub workflows.

**Status:** Available now

**Use when:**
- Your code is hosted on GitHub
- You use GitHub Actions for CI/CD
- You want the simplest possible setup

[View Documentation →](github-action.md)

## Coming Soon

### Jenkins Plugin 🚧

Native Jenkins plugin for tracking deployments from Jenkins pipelines.

**Planned features:**
- Pipeline step integration
- Automatic Jenkins metadata extraction
- Build and deployment tracking
- Post-build actions

**Status:** Planned

### Bitbucket Pipes 🚧

Custom Bitbucket Pipe for Bitbucket Pipelines.

**Planned features:**
- Native pipe configuration
- Automatic Bitbucket metadata
- Deployment tracking per environment

**Status:** Planned

### GitLab Component 🚧

GitLab CI component for GitLab pipelines.

**Planned features:**
- Include-based configuration
- GitLab CI/CD variable integration
- Deployment environment tracking

**Status:** Planned

## When to Use Native Integrations

### ✅ Use Native Integrations When:

**You're using a supported platform**
- GitHub Actions, Jenkins, Bitbucket Pipelines, etc.
- The platform has an official Versioner integration

**You want the easiest setup**
- Minimal configuration required
- Automatic metadata extraction
- Platform-native experience

**You value tight integration**
- Leverage platform-specific features
- Native error handling and logging
- Consistent with platform patterns

### 🔧 Use the CLI Instead When:

**Your platform doesn't have a native integration**
- Unsupported CI/CD systems
- Custom deployment scripts
- Infrastructure as Code tools (Terraform, Ansible)

**You need maximum flexibility**
- Custom workflows
- Non-standard processes
- Multi-platform deployments

[Learn about the CLI →](../cli/index.md)

### 🔌 Use the API Instead When:

**You're building custom tooling**
- Internal deployment platforms
- Custom automation
- Integration with other systems

**You need maximum control**
- Custom event payloads
- Advanced error handling
- Programmatic integration

[Learn about the API →](../api/index.md)

## Comparison

| Feature | Native Integrations | CLI | API |
|---------|-------------------|-----|-----|
| **Setup Complexity** | Minimal | Low | Medium |
| **Configuration** | Platform-native | Flags/env vars | HTTP requests |
| **Metadata Extraction** | Automatic | Automatic | Manual |
| **Platform Support** | Specific platforms | Universal | Universal |
| **Customization** | Limited | Medium | Maximum |
| **Best For** | Supported platforms | Any CI/CD system | Custom tooling |

## How Native Integrations Work

All native integrations follow the same pattern:

1. **Configure** - Add integration to your pipeline/workflow
2. **Authenticate** - Provide Versioner API key (usually via secrets)
3. **Track Events** - Integration automatically submits events to Versioner
4. **View Results** - See deployments in Versioner dashboard

### Example: GitHub Action

```yaml
# .github/workflows/deploy.yml
- name: Track Deployment
  uses: versioner-io/versioner-github-action@v1
  with:
    api-key: ${{ secrets.VERSIONER_API_KEY }}
    product: my-service
    version: ${{ github.sha }}
    environment: production
    status: success
```

The action automatically extracts:
- Git commit SHA
- Branch name
- Deployer (GitHub user)
- Build URL
- Repository information

## Request a New Integration

Have a platform you'd like to see supported? Let us know!

- **Email:** support@versioner.io

Popular requests will be prioritized for development.

## Contributing

Interested in building an integration for your platform? We'd love to collaborate!

Native integrations are open source and community contributions are welcome. Reach out to discuss:

- **GitHub:** [versioner-io](https://github.com/versioner-io)
- **Email:** support@versioner.io

## Next Steps

- [GitHub Action Documentation](github-action.md)
- [CLI Documentation](../cli/index.md)
- [API Documentation](../api/index.md)
- [Getting Started Guide](../getting-started.md)
