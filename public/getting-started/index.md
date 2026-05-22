# Getting Started

Get up and running with Versioner in a few minutes.

## Prerequisites

- Access to your CI/CD system (GitHub Actions, Jenkins, GitLab CI, etc.)
- Basic familiarity with REST APIs or command-line tools

## Step 1: Create an Account and Get Your API Key

Visit [app.versioner.io](https://app.versioner.io) to create an account. New accounts get 30 days of full Enforce-level access to try all features.

Once logged in, go to **Settings → Integrations → API Keys** and create your first key.

Your API key will look like this:
```
sk_mycompany_k1_abc123def456...
```

## Step 2: Set Up Notifications (optional)
!!! note "Note: Slack required"
    Versioner currently supports Slack for notifications. If your team doesn't use Slack, [let us know](mailto:support@versioner.io) — other options are on the roadmap.

Before you submit your first event, connect a Slack channel so you can see deployment activity in real time.

Generate a webhook in your Slack administration settings, then go to **Settings → Integrations → Slack** and add your Slack webhook URL. Choose the events you want to receive notifications for and Versioner will post to that channel whenever a matching event is received.

## Step 3: Set Up Your Integration
Decide how you want to send build and deployment events to Versioner. Check out the associated guide and quickly wire it in to your pipeline.

| Type | Great for | Learn more |
|----------|----------|--------------|
| **Native Integrations** | Native plugins for specific platforms | [View guide](../integrations/native/index.md) |
| **CLI** | Any CI/CD system. One binary, works everywhere | [View guide](../cli/index.md) |
| **REST API** | Maximum control and transparency | [View guide](../api/index.md) |

Not sure which to use? [Compare options →](../integrations/index.md)

## Step 4: Submit Your First Event

Run your pipeline to submit your first event!

## Step 5: View Your Deployments

Visit your [dashboard](https://app.versioner.io/dashboard) to see all your environments and deployments in one place.

!!! success "You're all set!"
    You've successfully integrated Versioner and tracked your first deployment.

## What's Next?

<div class="grid cards" markdown>

-   :material-eye-outline: **See what's deployed**

    ---

    Check the [Environment State Matrix](../concepts/governance/environment-state-matrix.md) to see all your environments and versions at a glance.

-   :material-shield-check-outline: **Add approval workflows**

    ---

    Create [Deployment Requests](../concepts/governance/deployment-requests.md) to gate production changes with structured reviews.

-   :material-gavel: **Enforce policy**

    ---

    Define [Deployment Rules](../concepts/governance/deployment-rules.md) to automate no-deploy windows, required sequences, and approvals.

-   :material-robot-outline: **Connect an AI agent**

    ---

    Use the [MCP server](../ai-agents/mcp.md) to query deployment status and manage requests directly from Claude.

-   :material-account-multiple-plus-outline: **Invite your team**

    ---

    Add teammates in [Settings → Team](https://app.versioner.io/settings/team) so they can view deployments, approve requests, and collaborate.

</div>
