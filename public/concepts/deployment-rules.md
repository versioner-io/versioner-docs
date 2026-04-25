# Deployment Rules

**Deployment Rules** are automated policies that govern when, where, and how versions can be deployed. They evaluate at deployment time and either allow or block deployments based on your organization's requirements.

!!! info "Enforce tier"
    Deployment Rules are available on Enforce tier and above. During your 30-day trial, you have full Enforce-level access.

## Overview

Deployment Rules let you:

- **Define no-deploy windows** - Block deployments during maintenance or off-hours
- **Enforce deployment sequences** - Require staging deployment before production
- **Require approvals** - Gate production on having an approved Deployment Request
- **Require version reviews** - Block unless specific approval types have signed off
- **Report policy violations** - Run in report-only mode to measure compliance

**Key Principle:** Rules are **evaluated at deploy time** when a version event arrives. They log violations and either block or allow based on your configuration.

## Rule Types

### 1. Schedule Rules

Control when deployments can happen using no-deploy windows.

**What it blocks:** Deployments during specified times

**Use cases:**
- Maintenance windows (e.g., "No deploys Friday 5pm-9pm ET")
- Business hours restrictions (e.g., "No production deploys outside 9am-5pm ET")
- Blackout periods (e.g., "No deploys Dec 24-26")

**Configuration:**

```json
{
  "rule_type": "schedule",
  "name": "No Deploys Friday Night",
  "description": "Prevent Friday evening deployments for weekend stability",
  "target_type": "release",
  "target_environments": ["production"],
  "schedule": {
    "type": "weekly",
    "timezone": "America/New_York",
    "blocked_windows": [
      {
        "day": "friday",
        "start_time": "17:00",
        "end_time": "21:00"
      }
    ]
  },
  "enforcement_mode": "block"
}
```

**Recurrence types:**
- **Daily** - Same times every day
- **Weekly** - Specific days and times each week
- **Monthly** - Specific dates or day-of-week each month

**Timezones:** Supports any IANA timezone (e.g., `America/New_York`, `Europe/London`, `Asia/Tokyo`)

### 2. Flow Rules

Enforce deployment sequences across environments.

**What it blocks:** Deployments that skip required prior environments

**Use cases:**
- Require staging before production
- Enforce dev → test → staging → production flow
- Prevent jumping directly to production

**Configuration:**

```json
{
  "rule_type": "flow",
  "name": "Staging Before Production",
  "description": "All versions must deploy to staging before production",
  "target_type": "release",
  "source_environment": "staging",
  "target_environment": "production",
  "required_duration_minutes": 0,
  "enforcement_mode": "block"
}
```

**Key settings:**
- `source_environment` - Deployment must occur here first
- `target_environment` - Cannot deploy here until source is complete
- `required_duration_minutes` - Minimum soak time in source before deploying to target (e.g., "must be stable in staging for 24 hours = 1440 minutes")

### 3. Deployment Request Required

Gate deployments on having an approved Deployment Request.

**What it blocks:** Deployments without an approved DR

**Use cases:**
- Require all production deployments have approval
- Enforce compliance by requiring DR audit trail
- Prevent accidental direct deployments

!!! note
    This rule requires having the Protect tier (for Deployment Requests).

**Configuration:**

```json
{
  "rule_type": "deployment_request_required",
  "name": "Production Deployments Require Approval",
  "description": "All production deployments must have an approved DR",
  "target_type": "release",
  "target_environments": ["production"],
  "enforcement_mode": "block"
}
```

### 4. Version Approval Required

Block deployments unless specific approval types have been completed.

**What it blocks:** Deployments where required approval types are missing

**Use cases:**
- Production requires security approval before any deployment
- Critical services require compliance sign-off
- Mandatory code review for certain products

**Configuration:**

```json
{
  "rule_type": "version_approval_required",
  "name": "Production Security Approval",
  "description": "All production deployments require security approval",
  "target_type": "release",
  "target_environments": ["production"],
  "required_approvals": ["security"],
  "enforcement_mode": "block"
}
```

**Approval types:**
- `product` - Product team sign-off
- `qa` - QA/testing sign-off
- `security` - Security team sign-off
- `code_review` - Developer code review
- `compliance` - Compliance team sign-off
- `performance` - Performance/SRE sign-off

## Decision Engine

When a deployment event arrives, Versioner evaluates all rules in this order:

```
1. Fetch all rules for this product/environment
2. Evaluate each rule:
   a. Does rule apply to this product? (Check target rules)
   b. Does rule apply to this environment? (Check target_environments)
   c. Does deployment violate this rule? (Check rule-specific logic)
3. If violation found:
   - If enforcement_mode = "block": Reject deployment (exit code 5)
   - If enforcement_mode = "report": Log violation, allow deployment
4. If all rules pass: Allow deployment
```

### Example: Multiple Rules

Product `payment-api` deploying version `2.0.0` to `production`:

```
Rule 1: Schedule (No Deploys Friday 5-9pm ET)
  → Current time: Wednesday 2pm ET
  → Check: Does not violate (wrong day)
  → Result: Pass ✓

Rule 2: Flow (Staging Before Production)
  → Check: Is version 2.0.0 deployed to staging?
  → Result: Yes ✓

Rule 3: Deployment Request Required
  → Check: Is there an approved DR for this deployment?
  → Result: Yes ✓

Rule 4: Version Approval Required (security)
  → Check: Does version have security approval?
  → Result: Yes ✓

All rules pass: Deployment allowed
```

## Enforcement Modes

Each rule can be set to either **block** or **report**:

### Block Mode

Violating this rule **blocks the deployment** with exit code 5. The deployment is rejected and not executed.

**Use for:**
- Critical policies your organization won't compromise on
- Safety guardrails (e.g., no weekend deploys to production)
- Compliance requirements

### Report Mode

Violating this rule **logs the violation but allows the deployment**. Useful for:

- **Building confidence** - Run in report mode for a week, observe violations, then switch to block
- **Advisory rules** - "Best practice but not mandatory"
- **Gradual enforcement** - Start reporting, then enforce once adoption is high

**Example workflow:**

```
Week 1-2: Schedule rule in report mode
  → Log all violations
  → Team gets used to deployment windows
  
Week 3: Switch to block mode
  → Now violations actually block deployments
  → Team has context and support
```

### Configuration

```json
{
  "rule_type": "schedule",
  "name": "No Deploys Friday Night",
  "enforcement_mode": "report"  # Report violations but allow deployments
}
```

## Target Configuration

Rules can target specific products, environments, or all:

```json
{
  "target_type": "release",              # Type: always "release"
  "target_product_ids": ["prod-1", "prod-2"],  # Optional: specific products
  "target_environments": ["production"]  # Optional: specific environments
}
```

If `target_product_ids` and `target_environments` are both empty, the rule applies to **all products and environments**.

## GitOps Scoping Note

Deployment Rules evaluate specific versions sent via deployment events. In GitOps setups where a platform controller automatically reconciles desired state from Git:

- The controller pushes desired state (e.g., "version 2.0.0 should run in production")
- Versioner doesn't receive individual version deployment events
- Rules don't apply the same way

If you use GitOps, you may need to:

1. Have your controller emit deployment events to Versioner
2. Evaluate rules outside of Versioner (in your GitOps controller logic)
3. Use Versioner for visibility only (no rule enforcement)

Talk to support about your specific GitOps setup.

## Rule Lifecycle

### Creating a Rule

1. Navigate to **Settings → Deployment Rules**
2. Click **New Rule**
3. Select rule type
4. Configure target products/environments
5. Configure rule-specific settings
6. Set enforcement mode (block or report)
7. Save

### Disabling a Rule

Rules can be disabled without deletion:

```bash
PATCH /deployment-rules/{rule-id}
{
  "enabled": false
}
```

Disabled rules are not evaluated during deployment.

### Testing Rules

Before enabling block mode:

1. Create rule in report mode
2. Observe violations over a week
3. Ensure team understands the policy
4. Switch to block mode
5. Monitor exit code 5 rejections

### Monitoring Violations

View all rule violations:

```bash
GET /deployment-rules/violations
```

Filters:
- By rule
- By product
- By environment
- By date range
- By violation type (blocked vs. reported)

## Integration with CI/CD

When a rule blocks a deployment, your CI/CD system receives exit code **5**:

```bash
$ versioner track deployment \
  --product payment-api \
  --environment production \
  --version 2.0.0 \
  --status completed
  
Error: Deployment blocked by rule: "Production Security Approval Required"
Exit code: 5
```

**GitHub Actions:**

```yaml
- uses: versioner-io/versioner-github-action@v1
  with:
    product: payment-api
    environment: production
    
# If rule blocks:
# - Workflow fails
# - exit code 5 in logs
# - PR checks fail
```

**CLI:**

```bash
versioner track deployment ... || {
  if [ $? -eq 5 ]; then
    echo "Deployment blocked by Versioner rule"
    # Handle rule violation
    exit 1
  fi
}
```

## Best Practices

### Start Simple

Begin with one or two critical rules:

- Schedule rule for major maintenance windows
- Flow rule for staging → production

Add more as you become comfortable with the system.

### Use Report Mode First

Before enabling block mode:

1. Create rule in report mode
2. Monitor for 1-2 weeks
3. Discuss violations with team
4. Ensure everyone understands the policy
5. Then switch to block mode

### Clear Naming

Name rules to clearly describe what they enforce:

✅ **Good:**
- "No Production Deploys Friday After 5pm"
- "Payment Service Requires Security Approval"
- "All Services Must Deploy to Staging First"

❌ **Avoid:**
- "Rule 1"
- "Compliance"
- "Policy"

### Document Policies

Add descriptions explaining why the rule exists:

```json
{
  "name": "No Weekend Production Deploys",
  "description": "Reduce on-call burden and ensure full team is available for issues. Exceptions via ticket in #deploy-exceptions."
}
```

### Regular Reviews

Quarterly, review your rules:

- Are they still needed?
- Are they blocking legitimate deployments?
- Have team workflows changed?
- Should any rules move to block mode?

## Related Concepts

- **[Deployment Requests](deployment-requests.md)** - Manual governed deployments
- **[User Roles](user-roles.md)** - Roles determine who can create/manage rules
- **[Environment State Matrix](environment-state-matrix.md)** - See current state before rules evaluate
- **[Environments](environments.md)** - Rules target specific environments

## Next Steps

- Learn about [Deployment Requests](deployment-requests.md) for manual approval workflows
- Review [User Roles](user-roles.md) to understand permission model
- Explore [getting-started.md](../getting-started.md) for implementation guidance
