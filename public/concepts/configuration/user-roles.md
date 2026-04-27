# User Roles

A **user role** defines what actions a user can perform within your Versioner account. Roles control access to features and data, including the ability to approve deployment request slots.

!!! note "Tier Availability"
    Admin and Viewer roles are available on Free tier. All roles are available on Protect tier and above.

## Overview

Versioner uses role-based access control (RBAC) to manage permissions. Each user in your account is assigned a single role that determines what they can view, modify, and approve.

## Approval Type Mapping

Deployment request approval slots are assigned an **approval type**. This table shows which roles can fulfill each type:

| Approval Type | Roles That Can Approve |
|---------------|------------------------|
| UAT | product, admin, release_manager |
| QA | qa, admin, release_manager |
| Performance | sre, qa, admin, release_manager |
| Security | security, admin, release_manager |
| Code Review | developer, admin, release_manager |
| Compliance | compliance, admin, release_manager |

**Note:** Admin and Release Manager can fulfill any approval type.

## Available Roles

- **Admin** — Full unrestricted access; the only role that can manage users and account API keys.
- **Release Manager** — Owns end-to-end deployment workflow; can manage environments, rules, and templates, and can fulfill any approval type.
- **Product** — Represents product readiness; creates and manages deployment requests and provides UAT sign-off.
- **Developer** — Primary builder role; creates and manages deployment requests, and can view account API keys.
- **SRE** — Infrastructure-focused; manages environments, rules, integrations, and variables, and approves performance-related slots.
- **QA** — Read-only access plus the ability to fulfill QA and Performance approval slots.
- **Security** — Read-only access plus the ability to fulfill Security approval slots.
- **Compliance** — Read-only access plus the ability to fulfill Compliance approval slots.
- **Billing** — Read-only access plus billing and subscription management.
- **Viewer** — Read-only access with no modification or approval permissions.

!!! note "Versions and CI/CD"
    Versions are created automatically when your CI/CD pipeline sends a build event to Versioner via an account API key. This is not a user-role action — no user role grants the ability to create versions directly.

## Permission Matrix

| Capability | Admin | Release Mgr | Product | Developer | SRE | QA | Security | Compliance | Billing | Viewer |
|-----------|-------|-------------|---------|-----------|-----|----|---------|-----------|---------|----|
| **View Resources** |
| View products, environments, deployments | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| View deployment requests | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| View deployment rules | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Create & Modify** |
| Create/edit products | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Create/edit environments | ✅ | ✅ | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Create/manage deployment requests | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Create deployments | ✅ | ✅ | ❌ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Manage deployment rules | ✅ | ✅ | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Manage variables & templates | ✅ | ✅ | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| **Approvals** |
| Fulfill deployment request approval slots | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| Approve versions | ✅ | ✅ | ✅ | ❌ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| **Administration** |
| Manage integrations | ✅ | ❌ | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Manage account API keys | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Create personal access tokens | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| Manage user roles | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| View billing | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ |
| Manage billing | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ |

!!! note "Deployment Request Approvals"
    Approval slots in a deployment request are fulfilled based on their assigned type, not a blanket "approve DR" permission. A user can only fulfill a slot if their role matches that slot's approval type. See [Deployment Requests](../governance/deployment-requests.md) for details.

!!! note "Fulfilling Approval Slots"
    The "Fulfill deployment request approval slots" row indicates the role *can* fulfill slots — but only for the approval types mapped to their role. For example, a QA user can fulfill QA and Performance slots but not Security or UAT slots.

## Managing User Roles

### Assigning Roles

Account administrators can assign roles to users:

1. Navigate to **Settings** → **Team**
2. Find the user you want to modify
3. Click the role dropdown
4. Select the new role

### Changing Your Own Role

Users cannot change their own role. Contact an account administrator to request a role change.

### Role Requirements

- Every account must have at least one Admin
- The last Admin cannot be removed or downgraded
- Only Admins can assign roles to other users
- Users cannot change their own role

## Related Concepts

- **[Products](../catalog/products.md)** - What users can deploy
- **[Environments](../catalog/environments.md)** - Where users can deploy
- **[Deployment Requests](../governance/deployment-requests.md)** - Approval workflows that use roles
- **[Notifications](notifications.md)** - Email notifications for approvals
