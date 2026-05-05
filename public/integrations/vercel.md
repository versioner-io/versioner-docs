# Vercel Integration

Track Vercel deployments in Versioner and enforce deployment rules before builds start.

!!! warning "Not recommended for Vercel Hobby (Free) without a workaround"
    Vercel's outbound webhook feature — required to record deployment completions — is only available on Pro and Enterprise plans. On the Hobby tier, deployments created by Versioner can never be closed out and will remain permanently in **Started** state. See the [Hobby tier workaround](#hobby-tier-workaround) if you're on a free plan.

## How it works

| Part | Works on | What it does |
|------|----------|--------------|
| Pre-deployment preflight | All tiers | A `vercel-build` script calls the Versioner CLI; if checks fail, the build fails before deployment starts |
| Post-deployment recording | Pro/Enterprise only | Vercel sends a webhook to Versioner when a deployment succeeds, fails, or is canceled |

On Pro/Enterprise, both parts work together: **preflight → deploy → recorded in Versioner**.

## Prerequisites

- A [Versioner API key](../api/authentication.md)
- The [Versioner CLI](../cli/installation.md) available in your build environment

## Step 1: Add the pre-deployment build script (all tiers)

Add a `vercel-build` script to your `package.json` that runs the Versioner preflight check before your actual build:

```json
{
  "scripts": {
    "vercel-build": "versioner track deployment --product my-service --environment $VERCEL_ENV --version $VERCEL_GIT_COMMIT_SHA --status started && npm run build"
  }
}
```

`VERCEL_ENV` and `VERCEL_GIT_COMMIT_SHA` are injected automatically by Vercel in all build environments.

Add your API key as a Vercel environment variable:

1. In Vercel: **Project → Settings → Environment Variables**
2. Add `VERSIONER_API_KEY` with your API key value

When `--status started` is posted, Versioner evaluates your [deployment rules](../concepts/governance/deployment-rules.md). If an enforced rule fails, the CLI exits non-zero and Vercel cancels the build — the deployment never starts.

!!! warning "Hobby tier: deployments stay in \"Started\" state"
    On Hobby (Free), Vercel does not support outbound webhooks. The build script enforces preflight checks and creates a deployment record, but without a completion event the deployment remains permanently in **Started** state in Versioner. See [Hobby tier workaround](#hobby-tier-workaround) if you need full lifecycle tracking.

## Step 2: Configure the outbound webhook (Pro/Enterprise only)

**In Versioner:**

1. Go to **Settings → Integrations → Vercel**
2. Copy your unique **Webhook URL**

**In Vercel:**

1. Go to **Project → Settings → Webhooks** (or **Team → Settings → Webhooks** for team-wide coverage)
2. Click **Add Webhook**
3. Paste your Versioner Webhook URL
4. Select exactly these events:
    - ✅ `deployment.succeeded`
    - ✅ `deployment.error`
    - ✅ `deployment.canceled`
5. Click **Create** — Vercel generates a **Signing Secret**
6. Copy the Signing Secret

!!! warning "Do not select `deployment.created`"
    This event fires when a deployment begins, _after_ Vercel has already started it. Subscribing to it would record deployments as `started` with no way to enforce preflight — bypassing the blocking behavior you set up in Step 1.

**Back in Versioner:**

1. Return to **Settings → Integrations → Vercel**
2. Paste the Signing Secret into the **Vercel Signing Secret** field and click **Save**
3. The status indicator updates to **Connected**

Versioner will now record a deployment event each time Vercel fires one of the subscribed events.

## Hobby tier workaround

If you're on Vercel's Hobby plan and need full lifecycle tracking, use GitHub Actions to orchestrate instead:

1. **Disable** Vercel's automatic Git deployments in **Project → Settings → Git**
2. In your GitHub Actions workflow, use the [Versioner GitHub Action](./github-action.md) to post `status: started` for preflight enforcement
3. Trigger a Vercel build using a [Vercel Deploy Hook](https://vercel.com/docs/deployments/deploy-hooks) (inbound — available on all tiers)
4. After the build completes, post `status: completed` (or `failed`) via the GitHub Action

This gives you full lifecycle visibility without requiring the Pro/Enterprise outbound webhook feature.

## Event mapping

| Vercel event | Versioner status |
|---|---|
| `deployment.succeeded` | `completed` |
| `deployment.error` | `failed` |
| `deployment.canceled` | `canceled` |

## Troubleshooting

See the [Troubleshooting guide](troubleshooting.md) for help with common API errors including 401, 422, 423, and 428 responses.
