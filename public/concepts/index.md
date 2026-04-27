# Core Concepts

!!! tip "New to Versioner?"
    Read [How It Works](../getting-started/how-it-works.md) first — it explains how these concepts fit together before you dive into the details.

Versioner is built around a small set of concepts. Here's what each one does:

## Visibility

| Concept | What it is |
|---|---|
| [Environment State Matrix](governance/environment-state-matrix.md) | Grid showing what version of each product is running in each environment — your deployment source of truth |
| [Products](catalog/products.md) | Deployable software components (services, apps, libraries) |
| [Versions](catalog/versions.md) | Build artifacts ready to deploy |
| [Environments](catalog/environments.md) | Deployment targets (dev, staging, production) |
| [Deployments](catalog/deployments.md) | Records of what was deployed where and when |

## Control & Governance

| Concept | What it is |
|---|---|
| [Deployment Requests](governance/deployment-requests.md) | Governed deploy workflow with approval gates and audit trails *(Govern tier+)* |
| [Deployment Rules](governance/deployment-rules.md) | Automated policies that gate, sequence, and enforce your deployment standards *(Orchestrate tier+)* |
| [User Roles](configuration/user-roles.md) | Role-based permissions defining who can approve what |

## Notifications & Access

| Concept | What it is |
|---|---|
| [Notifications](configuration/notifications.md) | Slack webhooks for events + email notifications for approvals |
| [Deployment Buttons](configuration/deployment-buttons.md) | One-click shortcuts to your deployment tools |
| [Variables](configuration/variables.md) | Reusable values for URL templates and configuration |
