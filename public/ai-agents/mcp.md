# MCP Server

Versioner provides an MCP (Model Context Protocol) server that lets AI agents query your deployment state, check readiness before deploying, and prepare structured Deployment Requests as part of automated workflows.

## What is MCP?

MCP (Model Context Protocol) is a standardized protocol for AI agents to interact with external systems. The Versioner MCP server gives agents programmatic access to your deployments, rules, and governance—enabling smarter automation across your CI/CD pipelines.

## Availability

| Tier | Read Tools | Advisory Preflight | Write Tools |
|------|----------|-------------------|-------------|
| **Free** | ✓ | | |
| **Protect** | ✓ | | |
| **Enforce** | ✓ | ✓ | ✓ |

- **Read tools** (Free+) query deployment state, history, and governance rules
- **Advisory preflight** (Enforce+) evaluates whether a specific version can deploy to an environment right now
- **Write tools** (Enforce+) let agents create and configure Deployment Requests (humans approve and trigger in the UI)

## Connection Setup

### Step 1: Create a Personal Access Token

Visit [app.versioner.io](https://app.versioner.io) → Settings → Developer → Personal Access Tokens → Generate new token.

Personal access tokens (PATs) are tied to your user account and start with `pat_`. Use PATs for personal tooling like MCP.

!!! note "PATs vs API Keys"
    API keys (`sk_...`) are for CI/CD systems submitting build and deployment events. PATs (`pat_...`) are for personal tooling like MCP. Use the right one for the right job.

### Step 2: Install the MCP Server

Clone the repository and install dependencies via `uv`:

```bash
git clone https://github.com/versioner-io/versioner-mcp ~/.versioner-mcp
cd ~/.versioner-mcp
uv sync
```

Requires `uv`. [Install uv](https://docs.astral.sh/uv/).

### Step 3: Configure Your MCP Client

#### Claude Code

Add to `~/.claude.json` under `mcpServers`:

```json
"versioner": {
  "command": "uv",
  "args": ["run", "--directory", "/Users/yourname/.versioner-mcp", "versioner-mcp"],
  "env": {"VERSIONER_PAT": "pat_..."}
}
```

Replace `pat_...` with your PAT from Step 1.

#### Other MCP Clients

Configure the server as a local stdio process. Pass the server command and environment variables:

```
command: uv
args: ["run", "--directory", "/Users/yourname/.versioner-mcp", "versioner-mcp"]
env:
  VERSIONER_PAT: pat_...
```

Exact format depends on your client. Consult its documentation for stdio server configuration.

## Example Interactions

### Understanding Current State

```
Agent: "What's currently deployed to production?"

→ get_environment_status(production)

Agent: "Production has user-service v2.1.0, payment-api v1.5.2, and worker v3.0.1.
        There are no active Deployment Requests.
        The environment has three governance rules:
        - All production deployments require QA sign-off
        - Deployments are restricted to business hours (8am–6pm UTC)
        - Maximum 2 concurrent deployments"
```

### Preflight Check (Ready to Deploy)

```
Agent: "Is user-service v2.2.0 ready to deploy to staging?"

→ check_deployment_readiness(user-service, staging, v2.2.0)

Agent: "Yes, staging is clear. No blockers, no warnings. Ready to proceed."
```

### Agent Prepares a Deployment Request

```
Agent: "Deploy payment-service v1.6.0 to production. Include a pre-step to run
        database migrations and add QA as an approver."

→ get_deployment_briefing(payment-service)
→ check_deployment_readiness(payment-service, production, v1.6.0)
→ get_dr_requirements(production)
→ create_deployment_request("Deploy payment-service v1.6.0")
→ add_version_to_deployment_request(..., payment-service, v1.6.0)
→ add_approval_requirement(..., qa)
→ add_deployment_step(..., pre, "Run database migrations")
→ activate_deployment_request(...)

Agent: "Created Deployment Request. QA has been notified for approval.
        Once approved, the deployment can proceed. You can track progress here:
        https://app.versioner.io/deployment-requests/dr-123"
```

Note: Agents prepare DRs; humans review, approve, and trigger in the Versioner UI. Agents cannot approve their own DRs or trigger deployments.

## Available Tools

### Read Deployment State (Free+)

| Tool | What it does |
|------|-------------|
| `get_deployment_status` | Current deployed versions, optionally filtered by product or environment |
| `get_deployment_briefing` | Comprehensive product briefing: versions across environments, active DRs, applicable rules, recent history |
| `get_environment_status` | Current state of an environment: deployed versions, recent deployment history, active DRs |
| `get_deployment_requests` | List Deployment Requests with filters (status, date range) |
| `get_deployment_request_detail` | Full DR detail: versions, approval requirements, pre/post steps, deployment history |
| `get_deployments` | Deployment event history with filters (product, environment, status, date range) |
| `get_deployment_rules` | Governance rules, optionally filtered by product or environment |

### Check Readiness (Enforce+)

| Tool | What it does |
|------|-------------|
| `check_deployment_readiness` | Evaluates whether a version is ready to deploy to an environment right now. Returns hard blockers, warnings, current state, suggested next actions. Version must be registered in Versioner first. |
| `get_dr_requirements` | Governance checklist for a target environment: required approval types, required step types, restrictions. Call before creating a DR. |

### Prepare Deployment Requests (Enforce+)

| Tool | What it does |
|------|-------------|
| `list_dr_templates` | List Deployment Request templates with config summaries (step counts, approval types) |
| `create_deployment_request` | Create a draft DR targeting an environment by name |
| `create_deployment_request_from_template` | Create a DR pre-populated from a template (fewer follow-up calls) |
| `add_version_to_deployment_request` | Add a product+version to a draft DR; resolves names to IDs automatically |
| `add_approval_requirement` | Add an approval slot (common types: qa, security, release_manager) |
| `add_deployment_step` | Add a pre or post deployment step |
| `activate_deployment_request` | Move DR from draft to in_progress; triggers approval notifications |
| `get_approval_status` | Check whether all approval slots have been filled |

### Deployment Request Workflow

When creating a Deployment Request, follow this order:

1. `get_dr_requirements(environment_name)` — Understand required approvals and steps
2. `create_deployment_request(...)` or `create_deployment_request_from_template(...)` — Create the DR
3. `add_version_to_deployment_request(...)` — Add each product+version
4. `add_approval_requirement(...)` — Add each required approval
5. `add_deployment_step(...)` — Add required pre/post steps
6. `activate_deployment_request(...)` — Trigger approval notifications
7. `get_approval_status(...)` — Poll for approval completion

Do not activate a DR before versions have been added—the API will return an error.

## Troubleshooting

### Can't connect

Verify:
- The PAT is correct (starts with `pat_`, no extra whitespace)
- Network connectivity and firewall/proxy settings

### Query returns empty

Product and environment names are case-sensitive. Confirm they match what's in the Versioner UI. Versioner must have recorded at least one deployment to that product/environment pair.

### Auth errors

Copy the PAT fresh from Settings → Developer. Confirm it:
- Starts with `pat_`
- Has not been revoked
- Has no extra whitespace

### Rate limiting

Reduce query frequency and cache results locally. Contact support if you need higher limits.

## Related Concepts

- **[Deployment Requests](../concepts/governance/deployment-requests.md)** - What you create via write tools
- **[Deployment Rules](../concepts/governance/deployment-rules.md)** - Governance constraints `check_deployment_readiness` evaluates
- **[Environment State](../concepts/governance/environment-state-matrix.md)** - Data behind read queries
- **[API Documentation](../api/index.md)** - Underlying REST API
