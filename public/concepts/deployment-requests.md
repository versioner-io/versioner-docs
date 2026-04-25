# Deployment Requests

A **Deployment Request (DR)** is a governed workflow for safely and controllably shipping code. It combines environment visibility with approval gates, compliance checks, and pre/post-deployment steps to enforce organizational policies around deployments.

!!! info "Protect tier"
    Deployment Requests are available on Protect tier and above. During your 30-day trial, you have full Protect-level access.

## Overview

Deployment Requests provide a way to:

- **Gate deployments** - Require specific approvals before code ships
- **Enforce policy** - Apply your organization's deployment rules
- **Track compliance** - Audit trail of who approved what and when
- **Run custom steps** - Execute pre-deployment checks and post-deployment verification
- **Coordinate teams** - Clear visibility into who needs to approve

**Key Principle:** A DR is your organization's governance layer. Instead of deploying directly, teams create DRs that check policy, collect approvals, and execute deployment steps.

## Deployment Request Lifecycle

A DR flows through these states:

1. **Draft** - Initial creation, still being configured
2. **In Progress** - Submitted for approval, waiting on approval slots
3. **Approved** - All required approvals obtained, ready to deploy
4. **Rejected** - One or more approval slots was rejected, deployment blocked
5. **Completed** - Successfully deployed and post-steps completed

## Creating a Deployment Request

Deployment Requests are created in the Versioner dashboard:

1. Navigate to **Deployments → Deployment Requests**
2. Click **New Deployment Request**
3. Select the product and version
4. Select the target environment
5. Optionally select a DR template to pre-populate approvals and steps
6. Add approval slots by role
7. Save as draft or submit for approval

## Approval Gates

Approval gates ensure the right people review and approve deployments before code ships. Each gate maps to a specific approval type, and each approval type is tied to one or more user roles.

### Role → Approval Type Mapping

| Role | Can Approve |
|------|-------------|
| admin | All types |
| release_manager | All types |
| product | UAT |
| qa | QA, Performance |
| security | Security |
| developer | Code Review |
| compliance | Compliance |
| sre | Performance |
| billing | — |
| viewer | — |

### Approval Workflow

When a DR moves to **In Progress**:

1. Each approval slot is checked against user roles
2. Users whose role matches an approval slot receive an **approval email**
3. Email contains a link to the DR and the specific action needed
4. User reviews and approves or rejects in the Versioner dashboard
5. When the user acts, the **DR creator receives an email** with the outcome

**Example:** A DR requires UAT approval. All users with the `product` role are notified. When one approves, that slot is marked complete. If one rejects, the entire DR is rejected.

### Optional Approvals

Approval slots can be marked **optional** — deployment can proceed even if they aren't completed. Useful for advisory-only reviews that shouldn't block deployments.

## Multi-Product Deployments

A single DR can coordinate deployments across multiple products. When creating the DR, add all the products and versions being deployed together. This is useful for coordinating related services that ship together (e.g., an API and its web frontend). All products in the DR go through the same approval flow and produce a single audit record.

## Pre-Deployment Steps

Custom checklist items that must be completed before deployment begins. Useful for:

- Running smoke tests
- Verifying database migrations are ready
- Checking resource availability
- Custom validation steps

!!! info "Enforce tier"
    Pre-deployment steps are available on Enforce tier and above.

Steps are added when creating a DR (or via a template). Each step is manually marked complete by an authorized user during deployment review.

## Post-Deployment Steps

Custom checklist items that run after deployment completes. Useful for:

- Running health checks
- Notifying stakeholders
- Updating a status page or runbook
- Triggering monitoring verification

!!! info "Enforce tier"
    Post-deployment steps are available on Enforce tier and above.

## Deployment Request Templates

Templates are reusable DR configurations that pre-define approval slots, pre/post steps, and other settings. Select a template when creating a DR to auto-populate it — all settings can be customized for individual DRs.

!!! info "Protect tier"
    DR Templates are available on Protect tier and above.

### Creating a Template

1. Navigate to **Settings → Deployment Request Templates**
2. Click **New Template**
3. Configure the template name, description, default approval slots, pre/post steps, and which environments it applies to
4. Save

## Common Workflows

### Simple Approval

```
1. Create DR for new version
2. DR routes to product team for UAT approval
3. Product team reviews via email link
4. Product team approves in Versioner dashboard
5. DR transitions to Approved
6. Deployment proceeds
```

### Multi-Approval Flow

```
1. Create DR requiring product + security approval
2. Approval emails sent to both teams
3. Product team approves ✓
4. Security team reviewing... ⏳
5. Security team rejects ✗
6. DR transitions to Rejected
7. DR creator receives rejection email with feedback
8. Address feedback and create new DR
```

### Coordinated Multi-Service Deploy

```
1. Create multi-product DR for api:2.0.0 + web:3.1.0
2. Both products require QA approval
3. QA reviews both in single DR
4. QA approves
5. Both services deploy with a single audit record
```

## Best Practices

### Approval Structure

- **Require the minimum** - Only gate on approvals your organization truly needs
- **Use optional approvals** - For advisory roles (e.g., optional Security review)
- **Match your team** - Align approval types with your actual team structure
- **Template common flows** - Create templates for standard approval workflows

### Context for Approvers

- Include enough description for approvers to make an informed decision
- Add links to monitoring, logs, or staging results they might need
- Set realistic approval windows for non-critical deployments

## Related Concepts

- **[Deployment Rules](deployment-rules.md)** - Automated enforcement of deployment policy
- **[User Roles](user-roles.md)** - Roles determine who can approve which deployment types
- **[Environment State Matrix](environment-state-matrix.md)** - See current state before creating a DR
- **[Products](products.md)** - Products are deployed via DRs
- **[Versions](versions.md)** - Versions are what DRs deploy

## Next Steps

- Learn about [Deployment Rules](deployment-rules.md) to automate policy enforcement
- Explore [User Roles](user-roles.md) to understand approval capabilities
- Check [Getting Started](../getting-started.md) for setup guidance
