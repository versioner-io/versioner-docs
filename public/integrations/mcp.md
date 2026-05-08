# MCP Server

Versioner provides an MCP (Model Context Protocol) server so AI agents can query deployment state and run preflight checks as part of automated workflows.

!!! note "Availability"
    Phase 1 (read queries) is available on Free tier and above. Phase 2 (advisory preflight) requires Enforce tier.

## What is MCP?

MCP (Model Context Protocol) is a standardized protocol for AI agents to interact with external systems. The Versioner MCP server gives agents read access to your deployment state and—on Enforce tier—the ability to ask "what would it take to deploy X to Y right now?" before taking action.

## Connection Setup

### 1. Create a Personal Access Token

Visit [app.versioner.io](https://app.versioner.io) → Settings → Developer → Generate new token. Personal access tokens (PATs) are tied to your user account and used for MCP and personal tooling. They start with `pat_versioner_io_`.

!!! note "PATs vs API keys"
    API keys (`sk_...`) are for CI/CD systems submitting build and deployment events. PATs (`pat_versioner_io_...`) are for personal tooling like MCP clients. Use the right one for the right job.

### 2. Configure Your MCP Client

```json
{
  "mcp_servers": {
    "versioner": {
      "url": "mcp://mcp.versioner.io",
      "auth": {
        "type": "bearer",
        "token": "pat_versioner_io_..."
      }
    }
  }
}
```

## Example Interactions

### Understanding Current State

```
Agent: "What's the current state of production?"

→ get_environment_state(production)

Agent: "user-service is on 2.1.0, payment-api is on 1.5.2.
        Let me check if there are newer builds available."

→ get_deployment_history(user-service, production, limit=3)

Agent: "Latest build of user-service is 2.2.0. Production is still on 2.1.0—
        there's an update available."
```

### Preflight Before Deploying (no blockers)

```
Agent: "I want to deploy user-service v2.2.0 to staging.
        Is anything blocking that?"

→ advisory_preflight(user-service, 2.2.0, staging)

→ would_allow: true, no blocking rules

Agent: "Staging is clear. Proceeding with deployment."
```

### Preflight Before Deploying (blocked)

```
Agent: "I want to deploy payment-api v2.0.0 to production."

→ advisory_preflight(payment-api, 2.0.0, production)

→ would_allow: false
  blocking: deployment request required, security approval missing
  warning: not yet deployed to staging
  recommendations: create DR, get security approval, deploy to staging first

Agent: "Production is blocked—needs a DR and security sign-off, and we should
        test in staging first. This is a major version bump, so that tracks.
        Let me loop in the team."
```

## Available Tools

For full parameter and response schemas, see the [versioner-mcp repository](https://github.com/versioner-io/versioner-mcp).

### Phase 1: Read Queries (Free tier and above)

| Tool | What it does |
|------|-------------|
| `list_environments` | List all environments in your account |
| `get_deployment_status` | Current deployment status for a product/environment pair |
| `get_environment_state` | Full state matrix for an environment (all products and versions) |
| `get_deployment_history` | Deployment history for a product/environment pair |
| `check_deployment_request_status` | Status and approval state of a specific Deployment Request |

### Phase 2: Advisory Preflight (Enforce tier and above)

| Tool | What it does |
|------|-------------|
| `advisory_preflight` | Returns whether a deployment would be allowed right now, what's blocking it, and what steps are needed |


## Troubleshooting

### Can't connect

Verify the PAT token is correct (starts with `pat_`, no extra whitespace). Check network connectivity and firewall/proxy settings.

### Query returns empty

Product and environment names are case-sensitive. Confirm the names match what's in the Versioner UI and that you've recorded at least one deployment to that product/environment pair.

### Auth errors

Copy the token fresh from Settings → Developer. Confirm it starts with `pat_versioner_io_`, hasn't been revoked, and has no extra whitespace.

### Rate limiting

Reduce query frequency and cache results locally. Contact support if you need higher limits.

## Related Concepts

- **[Environment State Matrix](../concepts/governance/environment-state-matrix.md)** - Data behind read queries
- **[Deployment Requests](../concepts/governance/deployment-requests.md)** - What advisory preflight checks for
- **[Deployment Rules](../concepts/governance/deployment-rules.md)** - Rules advisory preflight evaluates
- **[API Documentation](../api/index.md)** - Underlying REST API
