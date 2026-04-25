# MCP Server

Versioner provides an MCP (Model Context Protocol) server to integrate with AI agents and enable intelligent deployment workflows.

!!! note "Availability"
    Phase 1 (Read queries) is available on Free tier and above. Phase 2 (Advisory preflight) requires Enforce tier.

## What is MCP?

MCP (Model Context Protocol) is a standardized protocol for AI agents to interact with external systems. The Versioner MCP server allows AI agents to:

- Query deployment status
- Check environment state
- Understand what would be required for a deployment
- Make informed deployment decisions

## Connection Setup

### 1. Get Your API Key

Visit [app.versioner.io](https://app.versioner.io) → Settings → API Keys to create or copy your API key.

API keys start with `sk_` and look like:

```
sk_mycompany_k1_abc123def456...
```

### 2. Configure MCP Client

Connect your AI agent or MCP client to the Versioner MCP server:

```json
{
  "mcp_servers": {
    "versioner": {
      "url": "mcp://mcp.versioner.io",
      "auth": {
        "type": "bearer",
        "token": "sk_mycompany_k1_abc123def456..."
      }
    }
  }
}
```

Or via environment variables:

```bash
export VERSIONER_API_KEY="sk_mycompany_k1_abc123def456..."
export VERSIONER_MCP_URL="mcp://mcp.versioner.io"
```

### 3. Test Connection

Once configured, test the connection by querying available tools:

```
Agent: "What tools are available in Versioner?"
MCP Server: Lists all available query and preflight tools
```

## Phase 1: Read Queries (Free Tier)

Phase 1 provides read-only access to deployment data. Perfect for AI agents to understand current state before making decisions.

### Available Tools

#### list_environments

Get all environments in your account.

**Returns:**

```json
[
  {
    "id": "env-prod-001",
    "name": "production",
    "created_at": "2024-01-15T10:00:00Z"
  },
  {
    "id": "env-staging-001",
    "name": "staging",
    "created_at": "2024-01-15T10:00:00Z"
  },
  {
    "id": "env-dev-001",
    "name": "development",
    "created_at": "2024-01-15T10:00:00Z"
  }
]
```

#### get_deployment_status

Get current deployment status for a product in an environment.

**Parameters:**

```json
{
  "product": "user-service",
  "environment": "production"
}
```

**Returns:**

```json
{
  "product": "user-service",
  "environment": "production",
  "current_version": "2.1.0",
  "status": "success",
  "deployed_at": "2024-11-07T14:32:00Z",
  "deployed_by": "github-actions",
  "previous_version": "2.0.3"
}
```

#### get_environment_state

Get complete state matrix for an environment.

**Parameters:**

```json
{
  "environment": "production"
}
```

**Returns:**

```json
{
  "environment": "production",
  "services": [
    {
      "product": "user-service",
      "version": "2.1.0",
      "status": "success",
      "deployed_at": "2024-11-07T14:32:00Z"
    },
    {
      "product": "payment-api",
      "version": "1.5.2",
      "status": "success",
      "deployed_at": "2024-11-07T12:15:00Z"
    }
  ]
}
```

#### get_deployment_history

Get deployment history for a product/environment pair.

**Parameters:**

```json
{
  "product": "user-service",
  "environment": "production",
  "limit": 10
}
```

**Returns:**

```json
[
  {
    "version": "2.1.0",
    "status": "success",
    "deployed_at": "2024-11-07T14:32:00Z",
    "deployed_by": "github-actions"
  },
  {
    "version": "2.0.3",
    "status": "success",
    "deployed_at": "2024-11-05T10:15:00Z",
    "deployed_by": "github-actions"
  }
]
```

#### check_deployment_request_status

Get status of a specific Deployment Request.

**Parameters:**

```json
{
  "dr_id": "dr-abc123"
}
```

**Returns:**

```json
{
  "id": "dr-abc123",
  "product": "payment-api",
  "version": "2.0.0",
  "environment": "production",
  "status": "in_progress",
  "approvals": {
    "product": {
      "status": "approved",
      "approved_by": "jane@company.com",
      "approved_at": "2024-11-07T10:00:00Z"
    },
    "security": {
      "status": "pending",
      "requested_at": "2024-11-07T08:00:00Z"
    }
  }
}
```

## Phase 2: Advisory Preflight (Enforce Tier)

Phase 2 adds advisory preflight checks—the ability to ask "what would it take to deploy X to Y right now?" without actually deploying.

!!! info "Enforce tier"
    Advisory preflight checks require Enforce tier and above.

### available_tool: advisory_preflight

Ask what would be required to deploy a version.

**Parameters:**

```json
{
  "product": "payment-api",
  "version": "2.0.0",
  "environment": "production"
}
```

**Returns:**

```json
{
  "product": "payment-api",
  "version": "2.0.0",
  "environment": "production",
  "would_allow": false,
  "blocking_rules": [
    {
      "rule_id": "rule-123",
      "rule_type": "deployment_request_required",
      "rule_name": "Production Deployments Require Approval",
      "reason": "No approved deployment request exists for this version"
    }
  ],
  "missing_approvals": [
    {
      "approval_type": "security",
      "reason": "Version has not been reviewed by security team"
    }
  ],
  "warnings": [
    {
      "type": "flow_not_complete",
      "message": "Version has not been deployed to staging yet. Flow rule requires staging deployment first."
    }
  ],
  "recommendations": [
    "Create a deployment request for this version",
    "Obtain security approval for this version",
    "First deploy to staging environment"
  ]
}
```

### Use Case: Pre-Deployment Assessment

Before an AI agent or human triggers a deployment, use advisory preflight to understand requirements:

```
Agent: "Can I deploy payment-api v2.0.0 to production?"

Advisory Preflight Response:
- Blocking: No approved DR exists
- Blocking: No security approval
- Warning: Not yet deployed to staging
- Recommendation: Create DR, get approvals, test in staging

Agent: "I see. Let me first check if I can deploy to staging instead."

Advisory Preflight (staging):
- Would allow: true
- Recommendations: None
- Status: Ready to deploy

Agent: "Confirmed, deploying to staging now..."
```

## Example Interactions

### Phase 1: Visibility

**Scenario:** AI agent starts its day and wants to understand current state.

```
Agent: "What's the current state of production?"

MCP calls get_environment_state(production)

Agent: "I see user-service is on 2.1.0, payment-api is on 1.5.2...
        Let me check if there are newer builds available."

MCP calls get_deployment_history(user-service, production, limit=3)

Agent: "The latest version of user-service is 2.2.0 (built yesterday).
        Current production is 2.1.0, so there's an update available."
```

### Phase 2: Advisory Preflight

**Scenario:** AI agent is considering triggering a deployment.

```
Agent: "I want to deploy user-service v2.2.0 to staging.
        What would be required?"

MCP calls advisory_preflight(user-service, 2.2.0, staging)

MCP returns: would_allow = true, no blocking rules, no missing approvals

Agent: "Great, staging has no blockers. I'll proceed with deployment."
```

**Scenario with blockers:**

```
Agent: "I want to deploy payment-api v2.0.0 to production.
        What would be required?"

MCP calls advisory_preflight(payment-api, 2.0.0, production)

MCP returns:
  - would_allow = false
  - blocking_rules: "deployment_request_required"
  - missing_approvals: ["security"]
  - recommendations: ["Create DR", "Get security approval", "Deploy to staging first"]

Agent: "Production requires a DR and security approval, and we should test in staging first.
        This is a major version change, so that makes sense. Let me gather the team."
```

## Best Practices

### 1. Use Phase 1 Before Phase 2

Even with advisory preflight available, start by using read queries:

- Get familiar with the tools
- Understand data structure
- Build confidence with simple queries

Then add advisory preflight for smarter decisions.

### 2. Respect Blocking Rules

If advisory preflight says "would_allow = false", respect that:

- Don't try to bypass blocking rules
- Address the underlying requirement
- Work with your team to resolve blocks

### 3. Use Recommendations

The advisory response includes actionable recommendations:

- First create DR (if blocking)
- Then get approvals (if missing)
- Then proceed with deployment

Follow them in order for best results.

### 4. Cache Data Appropriately

Read queries return current state, but don't over-query:

- Cache environment state for 30 seconds
- Refresh deployment history before deciding to deploy
- Don't poll status continuously—use webhooks if available (coming soon)

### 5. Handle Errors Gracefully

MCP calls might fail (API down, auth error, rate limit). Always handle:

```python
try:
    response = mcp.call("get_deployment_status", {
        "product": "user-service",
        "environment": "production"
    })
except MCP_ConnectionError:
    print("Versioner is unavailable. Proceeding with caution...")
except MCP_AuthError:
    print("Auth failed. Check API key.")
```

## Troubleshooting

### Connection Failed

**Problem:** Can't connect to MCP server.

**Solution:**
1. Verify API key is correct
2. Check that you have internet connectivity
3. Ensure MCP server is reachable (test with `curl`)
4. Check firewall/proxy settings

### Query Returns Empty

**Problem:** Query returns empty list or null.

**Solution:**
1. Verify product/environment names are correct (case-sensitive)
2. Confirm you've deployed to this product/environment (check matrix in UI)
3. Check that API key has access to the account
4. Look at API response code for errors

### Auth Errors

**Problem:** "Invalid API key" or "Unauthorized"

**Solution:**
1. Copy API key from [app.versioner.io](https://app.versioner.io) → Settings
2. Verify token starts with `sk_`
3. Ensure token isn't rotated or revoked
4. Check that token doesn't have whitespace around it

### Rate Limiting

**Problem:** Requests are being rate limited.

**Solution:**
1. Reduce query frequency
2. Cache results locally
3. Batch queries where possible
4. Contact support if you need higher limits

## Related Concepts

- **[Environment State Matrix](../concepts/environment-state-matrix.md)** - Data behind queries
- **[Deployment Requests](../concepts/deployment-requests.md)** - What you're ultimately deploying
- **[Deployment Rules](../concepts/deployment-rules.md)** - What advisory preflight checks against
- **[API Documentation](../api/index.md)** - Underlying API that MCP is built on

## Next Steps

- Set up MCP connection using instructions above
- Start with Phase 1 read queries to understand data structure
- Explore advisory preflight when ready
- Integrate into your AI agent workflows
- Contact support@versioner.io for help or feature requests
