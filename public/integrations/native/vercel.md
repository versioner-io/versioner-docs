# Vercel Integration

Track Vercel deployments in Versioner and enforce deployment rules before builds start.

!!! warning "Vercel Hobby (Free) plan: limited without pipeline changes"
    Vercel's outbound webhook feature — required to record deployment completions — is only available on Pro and Enterprise plans. On the Hobby tier, deployments remain permanently in **Started** state unless you control builds from your CI/CD pipeline. See [CI/CD-controlled deployments](#recommended-cicd-controlled-deployments) for the workaround — it applies to Hobby lifecycle tracking and to full DR approval workflows on any tier.

## How it works

| Part | Works on | What it does |
|------|----------|--------------|
| Pre-deployment preflight | All tiers | A `vercel-build` script calls the Versioner CLI; if checks fail, the build fails before deployment starts |
| Post-deployment recording | Pro/Enterprise only | Vercel sends a webhook to Versioner when a deployment succeeds, fails, or is canceled |

On Pro/Enterprise, both parts work together: **preflight → deploy → recorded in Versioner**.

## Prerequisites

- A [Versioner API key](../../api/authentication.md)
- The [Versioner CLI](../../cli/installation.md) available in your build environment

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

When `--status started` is posted, Versioner evaluates your [deployment rules](../../concepts/governance/deployment-rules.md). If an enforced rule fails, the CLI exits non-zero and Vercel cancels the build — the deployment never starts.

!!! warning "Hobby tier: deployments stay in "Started" state"
    On Hobby (Free), Vercel does not support outbound webhooks. The build script enforces preflight checks and creates a deployment record, but without a completion event the deployment remains permanently in **Started** state in Versioner. See [CI/CD-controlled deployments](#recommended-cicd-controlled-deployments) for the workaround.

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

## DR Governance on Vercel

Versioner supports two levels of deployment governance on Vercel, depending on how much control you need.

### What works with the default git-native setup

The `vercel-build` script approach gives you real pre-deployment rule enforcement. Deployment Rules — schedule restrictions, blackout windows, concurrent deployment limits — are all evaluated before the build starts. If a rule fails, the CLI exits non-zero and Vercel cancels the build.

Post-deployment recording via Vercel's outbound webhooks (Pro/Enterprise) works accurately.

### The pre-authorization problem

When you merge a PR, the merge creates a new commit SHA at that instant, and the same event immediately triggers Vercel's build. There's no window between "the version now exists" and "the build is already in flight" to create a DR referencing the correct version, collect approvals, and then proceed. The deployment is already in motion before the version identifier exists.

This is a structural consequence of the merge-to-deploy (GitOps) model, not a Versioner limitation.

### Workarounds: using a known version identifier

The root problem is that `VERCEL_GIT_COMMIT_SHA` doesn't exist until the merge happens. The workaround is to use a version identifier you define *before* the merge.

**Option 1: Git tags**

Tag the branch before merging and use the tag as your version identifier:

```bash
# On your PR branch, before merging
git tag v1.2.3
git push origin v1.2.3
```

Create the DR referencing `v1.2.3`, get approval, then merge. Your `vercel-build` script reads the tag rather than `$VERCEL_GIT_COMMIT_SHA`. This requires discipline — the tag must be pushed and the DR approved before the merge triggers the build. Even a few seconds of latency between merge and Vercel picking it up can close the window.

**Option 2: Squash-merge with a deterministic identifier**

If your team uses squash merges, you can derive a stable version name from the PR number or branch name (e.g., `release/1.2.3`) and inject it as a Vercel build environment variable. This is more complex to configure and depends on your branching conventions, but avoids adding tags to every release.

### Recommended: CI/CD-controlled deployments

!!! tip "Recommended for pre-authorized DRs and for Hobby-tier lifecycle tracking"
    These are different problems with the same solution. If you need full DR approval workflows *or* you're on Vercel's Hobby plan (which lacks outbound webhooks for post-deployment recording), disable Vercel's automatic Git deploys and control builds from your CI/CD pipeline instead.

Switch from Vercel's automatic Git integration to a CI/CD-controlled model:

1. **Disable** Vercel's automatic Git deployment: **Project → Settings → Git → Auto-deploy on push**
2. In your CI/CD pipeline, on merge to `main` your pipeline registers the version with Versioner
3. Create a Deployment Request and attach the version
4. Once approved, trigger the Vercel build via [Deploy Hook](https://vercel.com/docs/deployments/deploy-hooks) (available on all Vercel tiers, including Hobby) from another pipeline
    - After the build completes, Vercel posts `status: completed` or `status: failed` via the Versioner webhook

The Vercel build still runs on Vercel's infrastructure — you're just controlling *when* it fires, giving Versioner the approval window it needs before the deployment starts.

The `vercel-build` preflight script remains valid and recommended for teams that want rule enforcement without changing their pipeline. Switch to CI/CD-controlled deploys when you need the full approval-before-deploy workflow or need post-deployment recording on Hobby.

## Event mapping

| Vercel event | Versioner status |
|---|---|
| `deployment.succeeded` | `completed` |
| `deployment.error` | `failed` |
| `deployment.canceled` | `canceled` |

## Troubleshooting

See the [Troubleshooting guide](../troubleshooting.md) for help with common API errors including 401, 422, 423, and 428 responses.
