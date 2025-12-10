# User Roles

A **user role** defines what actions a user can perform within your Versioner account. Roles control access to features and data, including the ability to approve releases and versions.

## Overview

Versioner uses role-based access control (RBAC) to manage permissions. Each user in your account is assigned a single role that determines what they can view, modify, and approve.

Roles are designed around common personas in software delivery:

- **Administrators** - Full control over account settings and users
- **Release Managers** - Manage releases and deployment workflows
- **Product Managers** - Create releases and approve product readiness
- **Developers** - Create versions and releases
- **DevOps/SRE** - Manage infrastructure and deployment automation
- **QA Engineers** - Approve quality standards
- **Security Team** - Approve security reviews
- **Compliance Team** - Approve regulatory compliance
- **Viewers** - Read-only access for stakeholders

## Available Roles

### Admin

Administrators have complete access to all features and settings.

**Permissions:**
- Full access to all features (unrestricted)
- Manage user roles and team members
- Configure billing and subscription settings
- Manage API keys
- All permissions of other roles

**Typical users:**
- Account owners
- Engineering directors
- Platform engineering leads

### Release Manager

Release managers oversee the entire release and deployment process.

**Permissions:**
- View and create products
- Manage environments
- Create and deploy releases
- Approve releases and versions
- Delete releases and deployment rules
- Manage deployment rules, variables, and templates
- View integrations

**Typical users:**
- Release engineering leads
- DevOps managers
- Deployment coordinators

### Product

Product managers control the release process and approve product readiness.

**Permissions:**
- View products, environments, and deployments
- Create releases
- Approve releases for deployment
- Approve versions for product readiness
- View deployment rules, variables, and templates

**Typical users:**
- Product managers
- Product owners
- Technical product leads

### Developer

Developers can create versions and releases for deployment.

**Permissions:**
- View products, environments, and deployments
- Create deployments
- Create releases and versions
- View deployment rules, variables, and templates
- View and create user-scoped API keys

**Typical users:**
- Software engineers
- Backend developers
- Full-stack developers

### SRE

Site Reliability Engineers manage infrastructure and deployment automation.

**Permissions:**
- View products, releases, and versions
- Manage environments
- Create deployments
- Approve versions for operational readiness
- Manage deployment rules, variables, and templates
- Manage integrations and notifications

**Typical users:**
- Site Reliability Engineers
- DevOps engineers
- Infrastructure engineers
- Platform engineers

### QA

QA engineers approve versions for quality standards.

**Permissions:**
- View all resources (read-only)
- Approve versions for quality assurance

**Typical users:**
- QA engineers
- Test engineers
- Quality assurance leads

### Security

Security team members approve versions for security compliance.

**Permissions:**
- View all resources (read-only)
- Approve versions for security reviews

**Typical users:**
- Security engineers
- Application security team
- Security architects

### Compliance

Compliance team members approve versions for regulatory requirements.

**Permissions:**
- View all resources (read-only)
- Approve versions for compliance sign-offs

**Typical users:**
- Compliance officers
- Regulatory affairs team
- Audit team members

### Billing

Billing managers handle subscription and payment settings.

**Permissions:**
- View all resources (read-only)
- Manage billing and subscription
- Download invoices

**Typical users:**
- Finance team
- Billing administrators
- Accounting staff

### Viewer

Viewers have read-only access to all deployment information.

**Permissions:**
- View all resources (read-only)
- No modification or approval permissions

**Typical users:**
- Stakeholders
- External auditors
- Customer success team
- Support staff

## Permission Matrix

The following table shows key capabilities for each role:

| Capability | Admin | Release Mgr | Product | Developer | SRE | QA | Security | Compliance | Billing | Viewer |
|-----------|-------|-------------|---------|-----------|-----|----|---------|-----------|---------|----|
| **View Resources** |
| View products, environments, deployments | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| View releases and versions | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| View deployment rules | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Create & Modify** |
| Create/edit products | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Create/edit environments | ✅ | ✅ | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Create releases | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Create versions | ✅ | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Create deployments | ✅ | ✅ | ❌ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Manage deployment rules | ✅ | ✅ | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Manage variables & templates | ✅ | ✅ | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| **Approvals** |
| Approve releases | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Approve versions | ✅ | ✅ | ✅ | ❌ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| **Administration** |
| Manage integrations | ✅ | ❌ | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Manage API keys | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Manage user roles | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Manage billing | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ |

!!! note "Version Approvals"
    Multiple roles can approve versions, but each approval is typed (e.g., "qa", "security", "compliance"). Deployment rules can require specific approval types before allowing deployment to production environments.

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

## Use Cases

### Small Startup Team

For a small team (3-8 people):

```
- 1-2 Admins (founders, tech leads)
- 3-5 Developers (engineers)
- 1 Product (product manager)
- 1 Viewer (stakeholder)
```

Simple structure where developers create releases and the product manager approves them.

### Growing SaaS Company

For a growing team (15-30 people):

```
- 2 Admins (engineering leadership)
- 1-2 Release Managers (DevOps leads)
- 2-3 SREs (infrastructure team)
- 10-15 Developers (engineers)
- 2 QA (QA engineers)
- 1 Security (security engineer)
- 1 Product (product manager)
- 2-3 Viewers (stakeholders)
```

Clear separation of concerns with dedicated approval roles for quality and security.

### Enterprise Organization

For large organizations (50+ people):

```
- 2-3 Admins (platform engineering directors)
- 3-5 Release Managers (release engineering team)
- 5-10 SREs (infrastructure team)
- 30-40 Developers (engineers across teams)
- 5 QA (QA team)
- 3 Security (security team)
- 2 Compliance (compliance officers)
- 3-5 Product (product managers)
- 1 Billing (finance team)
- 10+ Viewers (stakeholders, support, customer success)
```

Comprehensive approval workflow with multiple approval types required for production deployments.

## API Access

User roles also control API access:

- **API Keys** inherit the permissions of the user who created them
- **Service Accounts** can be assigned specific roles (coming soon)
- **Personal Access Tokens** have the same permissions as the user

!!! warning "API Key Security"
    API keys have the same permissions as your user role. Keep them secure and rotate them regularly.

## Best Practices

### 1. Principle of Least Privilege

Assign the minimum role needed for each user:

✅ **Good:**
- Product manager → Product role (can create/approve releases)
- QA engineer → QA role (can approve versions for quality)
- Junior engineer → Developer role (can create versions)
- Stakeholder → Viewer role (read-only)

❌ **Avoid:**
- Everyone as Admin
- Giving Developer role to users who only need to view
- Using Admin role for day-to-day work

### 2. Use Approval Roles Strategically

Leverage specialized approval roles for governance:

✅ **Good:**
- Require QA approval before production deployments
- Require Security approval for releases with dependency changes
- Require Compliance approval for regulated environments

❌ **Avoid:**
- Giving everyone approval permissions
- Skipping approval requirements for production

### 3. Regular Access Reviews

Review user roles periodically:

- Remove users who have left the team
- Adjust roles when responsibilities change
- Audit API keys and remove unused ones
- Review who has Admin access

### 4. Multiple Admins

Have at least 2 Admins to avoid lockout:

- Primary admin (day-to-day administration)
- Backup admin (emergency access)

### 5. Separate Service Accounts

Use dedicated API keys for CI/CD:

- Don't use personal API keys in CI/CD pipelines
- Create service-specific keys with descriptive names
- Rotate service keys on a regular schedule
- Use Developer role for CI/CD keys (can create versions)

## Security Considerations

### Role Changes

- Role changes take effect immediately
- Active sessions are not terminated
- Users are notified of role changes via email

### API Key Permissions

- API keys inherit user permissions at creation time
- Changing a user's role does not affect existing API keys
- Regenerate API keys after role changes

### Audit Trail

All role changes are logged:

- Who made the change
- When the change occurred
- What role was assigned
- Previous role (if applicable)

## Related Concepts

- **[Products](products.md)** - What users can deploy
- **[Environments](environments.md)** - Where users can deploy
- **[Notifications](notifications.md)** - Role-based notification settings

## Next Steps

- Learn about [API Authentication](../api/authentication.md)
- See the [Interactive API Docs](../api/interactive-docs.md)
- Explore [Deployment Rules](deployment-buttons.md) for approval workflows
