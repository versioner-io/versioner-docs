# Deployment Rules

**Deployment Rules** are automated policies that govern when, where, and how versions can be deployed. They evaluate at deployment time and either allow or block deployments based on the rules you define.

!!! info "Enforce tier"
    Deployment Rules are available on the Enforce tier and above. During your 30-day trial, you have full Enforce-level access.

## Overview

Deployment Rules let you:

- **Define no-deploy windows** — Block deployments during maintenance or off-hours
- **Enforce deployment sequences** — Require staging before production
- **Require DR approval** — Gate production on having an approved Deployment Request
- **Require version approvals** — Block unless specific approval types have signed off
- **Report policy violations** — Run in report-only mode to measure compliance before enforcing

Rules are **evaluated at deploy time** when a deployment event arrives. They log violations and either block or allow based on your configuration.

## Creating a Rule

Navigate to **Settings → Deployment Rules** and click **+ New Rule**. A wizard guides you through two steps:

1. **Scope** — Choose which products and environments the rule governs
2. **Details** — Configure the rule name and type-specific settings

After creation, rules appear in the Deployment Rules list where you can enable, disable, or switch them to report-only mode.

## Rule Types

### 📅 Schedule

Blocks deployments during specified time windows — maintenance periods, off-hours, blackout dates.

**Scope:** Select specific products and environments, or apply globally to all.

**Details:**

- **Rule Name** — e.g. "No Deploy Fridays"
- **Recurrence** — One-time, Daily, Weekly, or Monthly
- **Window** — Start and end date/time for the no-deploy period
- **Timezone** — Defaults to UTC if not specified
- **Reason** (optional) — Description shown when a deployment is blocked

**Use cases:**

- Maintenance windows ("No deploys Friday 5pm–9pm ET")
- Business hours restrictions ("No production deploys outside 9am–5pm ET")
- Blackout periods ("No deploys Dec 24–26")

---

### 🔀 Flow

Can enforce deployment sequences across and/or minimum soak times in environments.

**Scope:** Select specific products. Environment targeting is not set here — the rule itself defines which environments are involved.

**Details:**

- **Rule Name** — e.g. "Test → Staging → Production"
- **Prerequisite Environments** — One or more environments that must receive the version first, in order
- **Target Environment** — The environment blocked until prerequisites are met
- **Enforce strict ordering** — When checked, prerequisites must be completed in the exact order listed; when unchecked, any order is accepted

**Use cases:**

- Require staging before production
- Enforce dev → test → staging → production flow
- Prevent direct-to-production deployments
- Soak times avoid gaming the ordering check

---

### 🛡️ DR Approval Required

Gates deployments on having an active, approved Deployment Request with the required sign-offs.

**Scope:** Select specific products and environments, or apply globally to all.

**Details:**

- **Rule Name** — e.g. "Prod Needs UAT"
- **Required Approval Types** — One or more approval types that must be signed off on the DR (e.g. QA, Security, User Acceptance Testing)
- **Approval Timeout** (optional) — Hours after which an approval request expires

The Deployment Request must be active (`in_progress`) at the time of deployment — a draft DR does not satisfy this rule.

**Use cases:**

- Require all production deployments to have an approved DR
- Enforce compliance audit trail before deploying
- Prevent unreviewed deployments to sensitive environments

---

### ✅ Version Approval Required

Blocks deployments unless specific approval types have been recorded on the version being deployed.

**Scope:** Select specific products and environments, or apply globally to all.

**Details:**

- **Rule Name** — e.g. "QA Approval Required"
- **Required Approval Types** — One or more approval types that must be present on the version (e.g. QA, Security, Code Review)
- **Prerequisite Environment** (optional) — Where the approval must have been granted. Defaults to "Any location" — approvals from any environment are accepted. Set this to require the approval was specifically granted after deploying to a particular environment (e.g. staging).

**Use cases:**

- Production requires security approval before any deployment
- Critical services require compliance sign-off
- Mandatory QA sign-off for certain products

---

## Rule Modes

Each rule has three mode options, set from the Deployment Rules list:

| Mode | Effect |
|--------|--------|
| **Enabled** | Rule is active. Violations block the deployment (exit code 5). |
| **Report Only** | Rule evaluates and logs violations, but does not block. |
| **Disabled** | Rule is not evaluated. |

**Report Only** is useful for building confidence before enforcing:

```
Week 1–2: Run rule in Report Only
  → Violations logged, deployments proceed
  → Team learns the policy without disruption

Week 3: Switch to Enabled
  → Violations now block deployments
  → Team has context and is prepared
```

To change a rule's mode, find it in **Settings → Deployment Rules** and use the dropdown on the rule row.

## Decision Engine

When a deployment event arrives, Versioner evaluates all rules in order:

```
1. Fetch all rules for this product/environment
2. Evaluate each rule:
   a. Does this rule apply to this product?
   b. Does this rule apply to this environment?
   c. Does the deployment violate this rule?
3. If violation found:
   - If Enabled: Reject deployment (exit code 5)
   - If Report Only: Log violation, allow deployment
4. If all rules pass: Allow deployment
```

### Example: Multiple Rules

`payment-api` deploying version `2.0.0` to `production`:

```
Rule 1: Schedule (No Deploys Friday 5–9pm ET)
  → Current time: Wednesday 2pm ET
  → Result: Pass ✓

Rule 2: Flow (Staging Before Production)
  → Check: Is version 2.0.0 deployed to staging?
  → Result: Yes ✓

Rule 3: DR Approval Required
  → Check: Is there an active DR with required approvals?
  → Result: Yes ✓

Rule 4: Version Approval Required (Security)
  → Check: Does version have a security approval?
  → Result: Yes ✓

All rules pass → Deployment allowed
```

## Integration with CI/CD

When a rule blocks a deployment, the Versioner API returns a **4xx** error response. The exact code varies by rule type and failure reason — see [API Response Codes](../../api/response-codes.md) for the full reference. How that surfaces in your pipeline depends on how you're integrating.

**CLI:**

The CLI translates the API error into a non-zero shell exit code. For rule violations, that's exit code **5** — but see [CLI Usage](../../cli/usage.md) for the full list of exit codes and error handling options.

```bash
$ versioner track deployment \
  --product payment-api \
  --environment production \
  --version 2.0.0 \
  --status completed

Error: Deployment blocked by rule: "Production Security Approval Required"
Exit code: 5
```

```bash
versioner track deployment ... || {
  if [ $? -eq 5 ]; then
    echo "Deployment blocked by Versioner rule"
    exit 1
  fi
}
```

**GitHub Actions:**

The action handles the API response for you — if a rule blocks the deployment, the step fails and the blocking rule name appears in the workflow log. You don't need to inspect status codes or exit codes directly. See [GitHub Action](../../integrations/github-action.md) for full configuration options.

```yaml
- uses: versioner-io/versioner-github-action@v1
  with:
    product: payment-api
    environment: production

# If a rule blocks:
# - Step fails with the blocking rule name in the log
# - Workflow run is marked failed
# - Any dependent PR checks fail
```

## Best Practices

### Start Simple

Begin with one or two critical rules:

- A Schedule rule for major maintenance windows
- A Flow rule for staging → production

Add more as you become comfortable with the system.

### Use Report Only First

Before switching a rule to Enabled:

1. Create the rule in **Report Only** mode
2. Monitor violations for 1–2 weeks
3. Discuss violations with your team
4. Ensure everyone understands the policy
5. Switch to **Enabled**

### Name Rules Clearly

Name rules to describe exactly what they enforce:

✅ **Good:**

- "No Production Deploys Friday After 5pm"
- "Payment Service Requires Security Approval"
- "All Services Must Deploy to Staging First"

❌ **Avoid:**

- "Rule 1"
- "Compliance"
- "Policy"

### Review Rules Regularly

Quarterly, review your rules:

- Are they still needed?
- Are they blocking legitimate deployments?
- Have team workflows changed?
- Should any report-only rules move to enabled?

## Related Concepts

- **[Deployment Requests](deployment-requests.md)** — Manual governed deployments
- **[User Roles](../configuration/user-roles.md)** — Roles determine who can create and manage rules
- **[Environment State Matrix](environment-state-matrix.md)** — See current state before rules evaluate
- **[Environments](../catalog/environments.md)** — Rules target specific environments
