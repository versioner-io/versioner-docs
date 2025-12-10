# Core Concepts Overview

Understanding Versioner's core concepts will help you get the most out of the platform. These concepts form the foundation of how Versioner tracks and manages deployments.

## What are Concepts?

Concepts are the fundamental building blocks of Versioner. They represent the entities you work with when tracking deployments:

- **What you build** - Products and Versions
- **Where you deploy** - Environments
- **What you track** - Deployments
- **How you coordinate** - Releases
- **How you stay informed** - Notifications
- **How you trigger deployments** - Deployment Buttons
- **How you configure** - Variables
- **Who can do what** - User Roles

## The Versioner Model

Here's how these concepts relate to each other:

```
Products
  └─ Versions (builds of products)
       └─ Deployments (versions deployed to environments)
            └─ Environments (where things run)

Releases (coordinated groupings)
  └─ Versions (multiple products)
       └─ Deployments (tracked across environments)

Notifications (alerts about events)
  └─ Triggered by Deployments, Versions, etc.

Variables (configuration values)
  └─ Used by Deployment Buttons, future features

Deployment Buttons (quick deployment access)
  └─ Use Variables to create dynamic URLs

User Roles (access control)
  └─ Define what users can view and modify
```

## Start Here: The Basics

### 1. Products

**What:** Deployable software components (microservices, apps, libraries)

**Why it matters:** Products are the primary organizational unit. Everything else is organized around products.

**Example:** `user-service`, `payment-api`, `web-frontend`

[Learn about Products →](products.md)

### 2. Versions

**What:** Specific builds or releases of a product

**Why it matters:** Versions represent what can be deployed. They track build metadata and source control information.

**Example:** `1.2.3`, `abc123def`, `2024.11.06.1`

[Learn about Versions →](versions.md)

### 3. Environments

**What:** Deployment targets where your software runs

**Why it matters:** Environments define where versions get deployed. They help you track what's running where.

**Example:** `development`, `staging`, `production`

[Learn about Environments →](environments.md)

### 4. Deployments

**What:** Records of versions deployed to environments

**Why it matters:** Deployments are the core tracking mechanism. They answer "what version is running where?"

**Example:** `user-service:1.2.3` deployed to `production` at `2024-11-06 15:30:00`

[Learn about Deployments →](deployments.md)

## Advanced Concepts

### 5. Releases

**What:** Coordinated groupings of multiple product versions

**Why it matters:** Releases help you track multi-product deployments and coordinate go-live timing.

**Example:** "Q4 Sprint 3" includes `user-service:1.2.3`, `payment-api:4.5.6`, `notification-service:2.1.0`

[Learn about Releases →](releases.md)

### 6. Notifications

**What:** Real-time alerts about deployment and build events

**Why it matters:** Notifications keep your team informed about what's happening across your environments.

**Example:** Slack message when production deployment succeeds or fails

[Learn about Notifications →](notifications.md)

### 7. Variables

**What:** Reusable configuration values that can be referenced throughout Versioner

**Why it matters:** Variables eliminate repetition and enable dynamic templates for deployment buttons and future features.

**Example:** `rundeck_base_url = "https://rundeck.mycompany.com"`

[Learn about Variables →](variables.md)

### 8. Deployment Buttons

**What:** One-click shortcuts to your deployment tools with pre-configured parameters

**Why it matters:** Deployment buttons streamline your deployment workflow by automatically filling in version numbers and other parameters.

**Example:** Click "Deploy" in Slack → Rundeck opens with version 1.2.3 pre-filled

[Learn about Deployment Buttons →](deployment-buttons.md)

### 9. User Roles

**What:** Access control that defines what users can view and modify

**Why it matters:** User roles ensure team members have appropriate permissions for their responsibilities.

**Example:** Developers can deploy, viewers can only observe, admins can manage team settings

[Learn about User Roles →](user-roles.md)

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

1. **[Products](products.md)** - Understand what you're deploying
2. **[Versions](versions.md)** - Learn about build tracking
3. **[Environments](environments.md)** - Define your deployment targets
4. **[Deployments](deployments.md)** - Track what's running where
5. **[Releases](releases.md)** - Coordinate multi-product deployments
6. **[Notifications](notifications.md)** - Stay informed about events
7. **[Variables](variables.md)** - Configure reusable values
8. **[Deployment Buttons](deployment-buttons.md)** - Streamline deployment workflows
9. **[User Roles](user-roles.md)** - Manage team access and permissions

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

## Next Steps

Ready to dive deeper? Choose a concept to explore:

- [Products](products.md) - Deployable software components
- [Versions](versions.md) - Build artifacts and releases
- [Deployments](deployments.md) - Deployment tracking
- [Releases](releases.md) - Multi-product coordination
- [Environments](environments.md) - Deployment targets
- [Notifications](notifications.md) - Real-time alerts
- [Variables](variables.md) - Reusable configuration values
- [Deployment Buttons](deployment-buttons.md) - One-click deployment shortcuts
- [User Roles](user-roles.md) - Team access and permissions

Or jump to integration guides:

- [Native Integrations](../integrations/index.md) - Platform-specific plugins
- [CLI](../cli/index.md) - Universal command-line tool
- [API](../api/index.md) - Direct API integration
