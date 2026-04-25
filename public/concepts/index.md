# Core Concepts Overview

Understanding Versioner's core concepts will help you get the most out of the platform. These concepts form the foundation of how Versioner tracks and manages deployments.

## What are Concepts?

Concepts are the fundamental building blocks of Versioner. They represent the entities and workflows you work with:

- **What you see** - Environment State Matrix, Products, Versions, Environments
- **How you control** - Deployment Requests, approval gates, pre/post steps
- **How you govern** - Deployment Rules, policy enforcement, compliance tracking
- **How you stay informed** - Notifications, email approvals
- **How you trigger** - Deployment Buttons
- **Who can do what** - User Roles, approval capabilities
- **How you configure** - Variables, templates

## The Versioner Model

Here's how these concepts relate to each other:

```
Environment State Matrix (Visibility)
  ├─ Products (what you build)
  │  └─ Versions (build artifacts)
  │
  ├─ Environments (where you deploy)
  │
  └─ Deployments (versions deployed to environments)

Deployment Requests (Control)
  ├─ Approval Gates (role-based approvals)
  ├─ Pre-Deployment Steps (validation)
  └─ Post-Deployment Steps (verification)

Deployment Rules (Governance)
  ├─ Schedule Rules (no-deploy windows)
  ├─ Flow Rules (required sequences)
  ├─ DR Required Rules (approval gates)
  └─ Version Approval Rules (required sign-offs)

Notifications (Communication)
  ├─ Slack Webhooks (event-based alerts)
  └─ DR Approval Emails (action-oriented)

Supporting Features
  ├─ Deployment Buttons (quick access)
  ├─ Variables (URL templates)
  ├─ Releases (multi-product tracking)
  └─ User Roles (permissions)
```

## Start Here: Visibility

### Environment State Matrix

**What:** A grid showing what version of each product is running in each environment.

**Why it matters:** This is your single source of truth for what's deployed where. See drift, track deployment progress, understand current state.

[Learn about Environment State Matrix →](environment-state-matrix.md)

### Core Building Blocks

Then understand the basic concepts that feed into the matrix:

- **[Products](products.md)** - Deployable software components (microservices, apps)
- **[Versions](versions.md)** - Build artifacts ready to deploy
- **[Environments](environments.md)** - Deployment targets (dev, staging, production)
- **[Deployments](deployments.md)** - Records of what's deployed where

## Next: Control & Governance

### Deployment Requests (Protect Tier+)

**What:** Governed workflow for shipping code with approval gates and audit trails

**Why it matters:** Control who can deploy what, when, and ensure compliance with your processes.

[Learn about Deployment Requests →](deployment-requests.md)

### Deployment Rules (Enforce Tier+)

**What:** Automated policies that gate, sequence, and enforce your deployment standards

**Why it matters:** Automatically enforce no-deploy windows, required sequences, approval requirements.

[Learn about Deployment Rules →](deployment-rules.md)

## Supporting Features

### Notifications

**What:** Slack webhooks for events + email notifications for approvals

**Why it matters:** Keep your team informed and route approvals to the right people.

[Learn about Notifications →](notifications.md)

### User Roles

**What:** Role-based permissions that define who can approve what

**Why it matters:** Align permissions with your org structure and governance needs.

[Learn about User Roles →](user-roles.md)

### Releases

**What:** Lightweight grouping for tracking multi-product deployments

**Why it matters:** Coordinate releases across services. Complement to Deployment Requests.

[Learn about Releases →](releases.md)

### Deployment Buttons

**What:** One-click shortcuts to your deployment tools

**Why it matters:** Trigger deployments faster with version and environment pre-filled.

[Learn about Deployment Buttons →](deployment-buttons.md)

### Variables

**What:** Reusable configuration values for templates

**Why it matters:** Avoid repetition and maintain deployment tools configuration in one place.

[Learn about Variables →](variables.md)

## Common Workflows

### Tracking a Simple Deployment

```
1. Build creates a Version
   └─ user-service:1.2.3 (built from commit abc123)

2. Deploy creates a Deployment
   └─ user-service:1.2.3 → production

3. Notification sent
   └─ Slack: "user-service:1.2.3 deployed to production ✅"
```

### Coordinating a Multi-Service Release

```
1. Create a Release
   └─ "User Platform v2.0"

2. Add Versions to Release
   ├─ user-service:1.2.3
   ├─ auth-service:2.1.0
   └─ api-gateway:3.0.1

3. Track Deployments across Environments
   └─ Monitor progress: dev → test → staging → production

4. Complete Release
   └─ All versions deployed to production
```

## How Concepts Work Together

### Example: Microservices Deployment

**Products:**
- `user-service`
- `payment-api`
- `notification-service`

**Environments:**
- `development`
- `staging`
- `production`

**Versions:**
- `user-service:1.2.3`
- `payment-api:4.5.6`
- `notification-service:2.1.0`

**Deployments:**
- `user-service:1.2.3` → `production` (success)
- `payment-api:4.5.6` → `production` (success)
- `notification-service:2.1.0` → `production` (failed)

**Release:**
- "Q4 Sprint 3" tracks all three services
- Shows deployment progress across environments
- Identifies that notification-service deployment failed

**Notifications:**
- Slack alert: "notification-service deployment to production failed ❌"
- Team can investigate and remediate

## Recommended Reading Order

If you're new to Versioner, we recommend reading the concepts in this order:

1. **[Environment State Matrix](environment-state-matrix.md)** - Understand what you're seeing
2. **[Products](products.md)** - What you're deploying
3. **[Versions](versions.md)** - Build artifacts
4. **[Environments](environments.md)** - Deployment targets
5. **[Deployments](deployments.md)** - How tracking works
6. **[Deployment Requests](deployment-requests.md)** - Governed workflows (if on Protect+)
7. **[Deployment Rules](deployment-rules.md)** - Policy enforcement (if on Enforce+)
8. **[Notifications](notifications.md)** - Stay informed
9. **[User Roles](user-roles.md)** - Team permissions and approvals
10. **[Deployment Buttons](deployment-buttons.md)** - Quick deployment access
11. **[Variables](variables.md)** - Template configuration
12. **[Releases](releases.md)** - Multi-product tracking

## Key Principles

### 1. Auto-Creation

Most entities are created automatically when you submit events:

- Products are created when you first deploy them
- Versions are created when you first build or deploy them
- Environments are created when you first deploy to them

**No pre-configuration required** - just start tracking deployments!

### 2. Flexible Schemas

Versioner doesn't enforce rigid schemas:

- Use any versioning scheme (semantic, build numbers, SHAs, custom)
- Name products and environments however you want
- Add custom metadata to any entity

**Works with your existing conventions** - no need to change your workflow!

### 3. Immutability

Certain entities are immutable to maintain data integrity:

- Versions cannot be changed once created (same version = same SHA)
- Deployments are historical records (cannot be modified)
- Releases track what was deployed when (audit trail)

**Reliable audit trail** - know exactly what happened and when!

## Ready to Get Started?

1. Check out the [Environment State Matrix](environment-state-matrix.md) to see your deployments
2. Set up [Notifications](notifications.md) to stay informed
3. For governance: Explore [Deployment Requests](deployment-requests.md) and [Deployment Rules](deployment-rules.md)

Or jump to integration guides:

- [Native Integrations](../integrations/index.md) - Platform-specific plugins
- [MCP Server](../agents/mcp.md) - AI agent integration
- [CLI](../cli/index.md) - Universal command-line tool
- [API](../api/index.md) - Direct API integration
