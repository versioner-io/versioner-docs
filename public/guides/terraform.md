# Tracking Terraform / IaC Versions

Terraform tracks *state* — which resources exist and what they look like. It doesn't track *what produced that state*. When infrastructure breaks in production, there's no native answer to "which commit is currently applied?" or "did staging and production drift?"

Versioner fills that gap. You decide what "version" means for your infrastructure, and it surfaces alongside your application versions in the same environment grid.

## Step 1 — Decide what's meaningful to track

Start with the question that matters in an incident: **if infrastructure broke in production right now, what's the first version you'd want to know?**

A few orienting questions:

- Is your IaC code in its own repo, or co-located with the application?
- Are you using community modules, internal versioned modules, or both?
- Who owns the infrastructure — a platform team, or the app team?
- Do you run Terraform manually, from CI, or via a tool like Terragrunt?

The answers point you toward the right version signal.

## Step 2 — Pick your version signal

These aren't mutually exclusive — pick the one that maps to the unit of change your team actually cares about.

| Signal | When it makes sense |
|--------|-------------------|
| **Git SHA of your IaC/Terragrunt config repo** | Config wrapper is the meaningful unit — the module source is stable, your config changes drive applies |
| **Git SHA of your application repo** | Terraform lives alongside app code — infra and app version are the same SHA; seeing divergence between them is the signal |
| **Module version tag** | Consuming a versioned internal module registry; the module version is what changes |
| **Terraform provider version** | Compliance-heavy teams tracking provider upgrades as first-class changes |
| **Workspace name + run ID** | Terraform Cloud users who want to tie back to a specific run |

For most teams starting out: **git SHA of your IaC config repo** is the right default. It's always available, requires no extra tooling, and makes the state grid immediately useful.

## Step 3 — Wire it in

The Versioner CLI's `track deployment` command is the primitive. Replace `--product`, `--environment`, and `--version` with values that match your setup.

!!! tip "Product naming for infrastructure"
    Use a prefix like `terraform-` or `infra-` to distinguish infrastructure products from application products in the state grid — e.g., `terraform-platform`, `infra-payments`.

=== "Terragrunt"

    Add `after_hook` and `error_hook` blocks to your `terragrunt.hcl`. The hooks fire after every `apply`, passing the current environment and git SHA automatically.

    ```hcl
    locals {
      environment = local.environment_vars.locals.environment
    }

    terraform {
      source = "git@github.com:your-org/your-infra.git//terraform?ref=main"

      after_hook "versioner_track" {
        commands     = ["apply"]
        run_on_error = false
        execute = [
          "versioner", "track", "deployment",
          "--product=terraform-my-infra",
          "--environment=${local.environment}",
          "--version=${run_cmd("git", "rev-parse", "HEAD")}",
          "--status=completed",
          "--source-system=terragrunt"
        ]
      }

      error_hook "versioner_track_failed" {
        commands  = ["apply"]
        on_errors = [".*"]
        execute = [
          "versioner", "track", "deployment",
          "--product=terraform-my-infra",
          "--environment=${local.environment}",
          "--version=${run_cmd("git", "rev-parse", "HEAD")}",
          "--status=failed",
          "--source-system=terragrunt"
        ]
      }
    }
    ```

    !!! note "No-op applies"
        These hooks fire on every `apply`, including runs with no changes. If you want to skip tracking when Terraform reports "No changes", use a wrapper script that checks the apply output before calling `versioner`. See the [advanced pattern](#advanced-pattern-skipping-no-op-applies) below.

=== "GitHub Actions"

    Add a post-apply tracking step. Use `if: always()` so failures are captured too.

    ```yaml
    - name: Apply Terraform
      id: apply
      run: terraform apply -auto-approve

    - name: Track infrastructure deployment
      if: always()
      run: |
        versioner track deployment \
          --product=terraform-my-infra \
          --environment=production \
          --version=${{ github.sha }} \
          --status=${{ steps.apply.outcome == 'success' && 'completed' || 'failed' }} \
          --source-system=github-actions
      env:
        VERSIONER_API_KEY: ${{ secrets.VERSIONER_API_KEY }}
    ```

    For dynamic environments, pass the environment name as a job input or matrix variable and substitute it for `production`.

=== "Shell script"

    A minimal wrapper for any system that can execute a shell script post-apply:

    ```bash
    #!/bin/bash
    # Usage: ./track-infra.sh <product> <environment> <status>
    set -e

    PRODUCT="$1"
    ENVIRONMENT="$2"
    STATUS="$3"
    VERSION=$(git rev-parse HEAD 2>/dev/null || echo "unknown")

    if [ -z "$VERSIONER_API_KEY" ]; then
      echo "VERSIONER_API_KEY not set — skipping tracking"
      exit 0
    fi

    versioner track deployment \
      --product="$PRODUCT" \
      --environment="$ENVIRONMENT" \
      --version="$VERSION" \
      --status="$STATUS" \
      --source-system=terraform
    ```

    Call it from wherever your apply runs:

    ```bash
    terraform apply && ./track-infra.sh my-infra production completed \
      || ./track-infra.sh my-infra production failed
    ```

## Advanced Pattern: Skipping No-op Applies

If you run Terraform on a schedule or in CI and want to avoid cluttering the state grid with no-change runs, check the apply output before tracking:

```bash
#!/bin/bash
# Only track if Terraform actually made changes

APPLY_OUTPUT=$(terraform apply -auto-approve 2>&1)
echo "$APPLY_OUTPUT"

# Skip if no changes were made
if echo "$APPLY_OUTPUT" | grep -q "No changes\. Your infrastructure matches"; then
  echo "No infrastructure changes — skipping tracking"
  exit 0
fi

if echo "$APPLY_OUTPUT" | grep -q "Apply complete! Resources: 0 added, 0 changed, 0 destroyed"; then
  echo "No infrastructure changes — skipping tracking"
  exit 0
fi

# Track the apply
versioner track deployment \
  --product=my-infra \
  --environment=production \
  --version=$(git rev-parse HEAD) \
  --status=completed \
  --source-system=terraform
```

## What You'll See

Once wired in, every Terraform apply appears in the environment state grid alongside your application versions. Staging and production running different infrastructure commits becomes immediately visible — the same way a stale app version would.

This is the "track anything" claim made concrete: infrastructure drift is visible without a separate tool, dashboard, or manual process.

## Related

- [CLI Installation](../cli/installation.md)
- [CLI Usage](../cli/usage.md)
- [Environment State Matrix](../concepts/governance/environment-state-matrix.md)
