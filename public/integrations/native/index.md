# Native Integrations

Native integrations are platform-specific plugins built to work exactly the way each platform expects — minimal configuration, automatic metadata extraction, and platform-native syntax.

## When to use a native integration

Use a native integration when you're already on a supported platform and want the simplest possible setup: no CLI installation, no shell scripts, no manual metadata construction.

| | Native | CLI | REST API |
|---|---|---|---|
| **Setup effort** | Minimal | Low | Medium |
| **Configuration** | Platform-native YAML / config | Flags & env vars | HTTP requests |
| **Metadata extraction** | Automatic | Automatic | Manual |
| **Flexibility** | Platform-specific | Universal | Universal |

If your platform isn't listed below, use the [CLI](../../cli/index.md) — it works with any CI/CD system.

## Available

| Integration | Platform | Status |
|---|---|---|
| [GitHub Action](github-action.md) | GitHub Actions | ✅ Available |
| [Vercel](vercel.md) | Vercel | ✅ Available |

## Coming Soon

| Platform |
|---|
| GitLab CI |
| Bitbucket Pipelines |
| Jenkins |

## Request an integration

Have a platform you'd like to see supported? Email [support@versioner.io](mailto:support@versioner.io) — popular requests get prioritized.
