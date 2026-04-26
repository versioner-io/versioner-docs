# Quick Start

Get up and running with Versioner in a few minutes.

## Prerequisites

- Access to your CI/CD system (GitHub Actions, Jenkins, GitLab CI, etc.)
- Basic familiarity with REST APIs or command-line tools

## Step 1: Create an Account and Get Your API Key

Visit [app.versioner.io](https://app.versioner.io) to create an account. New accounts get 30 days of full Enforce-level access to try all features.

Once logged in, go to **Settings → Organization → API Keys** and create your first key.

Your API key will look like this:
```
sk_mycompany_k1_abc123def456...
```

!!! warning "Keep Your API Key Secret"
    Never commit your API key to version control. Store it as a secret in your CI/CD system.

## Step 2: Choose Your Integration

Versioner offers three ways to integrate with your deployment workflow:

### Native Integrations

Platform-specific plugins that integrate directly with your CI/CD system. Currently supports GitHub Actions with more platforms coming soon.

[:octicons-arrow-right-24: View Native Integrations Guide](../integrations/index.md)

### CLI

A universal command-line tool that works with any CI/CD system or deployment environment. Perfect for custom scripts and workflows.

[:octicons-arrow-right-24: View CLI Documentation](../cli/index.md)

### REST API

Direct API access for maximum flexibility and custom integrations.

[:octicons-arrow-right-24: View API Documentation](../api/index.md)

## Step 3: Set Up Notifications (Optional)

Before you submit your first event, connect a Slack channel so you can see deployment activity in real time.

Generate a webhook in your Slack administration settings, then go to **Settings → Integrations** and add your Slack webhook URL. Choose the events you want to receive notifications for and Versioner will post to that channel whenever a matching event is received.

!!! note "Slack required"
    Versioner currently supports Slack for notifications. If your team doesn't use Slack, [let us know](mailto:support@versioner.io) — other options are on the roadmap.

## Step 4: Submit Your First Event

Follow the setup instructions in your chosen integration guide. Each guide includes step-by-step instructions and examples.

Once you've submitted an event, you'll receive a JSON response confirming the deployment was tracked successfully.

## Step 5: View Your Deployments

Visit your [dashboard](https://app.versioner.io/dashboard) to see all your environments and deployments in one place.

!!! success "You're all set!"
    You've successfully integrated Versioner and tracked your first deployment.

## What's Next?

Versioner works in three levels. Start with visibility, then add control, then governance.

#### Level 1: Observe
- You now have visibility into what's deployed where.
- **Next**: Explore the [Environment State Matrix](../concepts/governance/environment-state-matrix.md) to see your deployments organized by product and environment.

#### Level 2: Protect
- Add governed workflows for shipping code.
- **Next**: Learn about [Deployment Requests](../concepts/governance/deployment-requests.md) to create approval gates and track compliance.

#### Level 3: Enforce
- Add automated policies that enforce organizational standards.
- **Next**: Explore [Deployment Rules](../concepts/governance/deployment-rules.md) to define no-deploy windows, required sequences, and approval requirements.

### Learning Path

**1. Get familiar with the basics:**

- [Environment State Matrix](../concepts/governance/environment-state-matrix.md) — what's running where
- [Deployments](../concepts/catalog/deployments.md) — how tracking works
- [Products, Versions, Environments](../concepts/catalog/products.md) — core data model

**2. Set up notifications:**

- [Notifications](../concepts/configuration/notifications.md) — Slack alerts and approval emails

**3. Add governance (Protect and above):**

- [Deployment Requests](../concepts/governance/deployment-requests.md) — approval workflows
- [User Roles](../concepts/configuration/user-roles.md) — who can approve what

**4. Enforce policy (Enforce tier):**

- [Deployment Rules](../concepts/governance/deployment-rules.md) — automated policy enforcement
- [Deployment Buttons](../concepts/configuration/deployment-buttons.md) — quick deployment shortcuts

### Need Help?

- [Interactive API Docs](../api/interactive-docs.md) — detailed endpoint documentation
- [Response Codes](../api/response-codes.md) — error troubleshooting
- [support@versioner.io](mailto:support@versioner.io)
