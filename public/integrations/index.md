# CI/CD Integrations

Versioner integrates with your existing deployment workflow — no need to consolidate tools or change your process. Choose the integration method that fits your stack.

## When to Use Which Integration

Pick based on your platform and how much control you need:

| | Native Integration | CLI | REST API |
|---|---|---|---|
| **Best for** | Quick/easy config | Any CI/CD system | Maximum control and trust |
| **Setup** | Minimal | Low | Medium |
| **Configuration** | Platform-native YAML | Flags & env vars | HTTP requests |
| **Metadata extraction** | Automatic | Automatic | Manual |
| **Platform support** | GitHub Actions (more coming) | Universal | Universal |
| **Customization** | Limited | Medium | Maximum |

## Available Integrations

### Native Integrations

Pre-built plugins for specific CI/CD platforms. Minimal configuration, automatic metadata extraction.

- [GitHub Action](github-action.md) ✅ — Available now
- Bitbucket Pipelines — Coming soon
- GitLab CI — Coming soon
- Jenkins — Coming soon

### CLI

A universal command-line tool that works with any system. Drop it into any pipeline with a single command.

[CLI Documentation →](../cli/index.md)

### REST API

Direct HTTP access for custom integrations, internal deployment platforms, or when you want full control over exactly what gets sent.

[API Documentation →](../api/index.md)

## Request an Integration

Have a platform you'd like to see supported? Email [support@versioner.io](mailto:support@versioner.io) — popular requests get prioritized.
