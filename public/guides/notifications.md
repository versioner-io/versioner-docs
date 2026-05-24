# Notifications

Stay informed about your deployments through Versioner's notification channels. All channels are configured under **Settings → Notifications**.

## Overview

| Channel | Trigger | Best for |
|---------|---------|---------|
| **Slack** | Deployment and build events | Team alerting in Slack |
| **Email** | Deployment and build events | Teams without Slack, or distribution lists |
| **Webhook** | Deployment and build events | DORA dashboards, incident tools, custom automation |
| **DR Approval Emails** | Deployment Request approval flow | Action-oriented approval notifications |

Slack, Email, and Webhook all fire on the same deployment and build event types. DR Approval Emails are a separate system tied to the Deployment Request governance flow.

!!! note "Governance-plane events coming soon"
    DR lifecycle events (`dr.approved`, `dr.activated`, etc.) and rule enforcement events (`rule.blocked`) will be available as webhook events in a future release, enabling downstream automation that hooks into the approval flow.

---

## Slack

Event-based notifications to Slack channels. Multiple channels can be configured, each with its own event subscriptions.

### Setup

1. Go to [api.slack.com/apps](https://api.slack.com/apps) and create or select an app
2. Enable **Incoming Webhooks** and add a webhook to your desired channel
3. Copy the webhook URL
4. In Versioner, go to **Settings → Notifications → Slack** and add a new channel
5. Paste the webhook URL, choose which events to subscribe to, and save

Use the **Test** button to verify delivery before going live.

### Event types

| Event | Description |
|-------|-------------|
| `deployment.pending` | Deployment queued |
| `deployment.started` | Deployment in progress |
| `deployment.completed` | Deployment succeeded |
| `deployment.failed` | Deployment failed |
| `deployment.aborted` | Deployment cancelled |
| `build.pending` | Build queued |
| `build.started` | Build in progress |
| `build.completed` | Build succeeded |
| `build.failed` | Build failed |
| `build.aborted` | Build cancelled |

### Multiple channels

Send different events to different channels — add one channel config per destination:

- **#deployments** → subscribe to `deployment.completed`
- **#alerts** → subscribe to `deployment.failed`

---

## Email

Org-level email notifications for deployment and build events. Configured the same way as Slack — one recipient address (or distribution list) per configuration, under **Settings → Notifications → Email**.

This is intentionally org-level, not user-specific. User-specific notification subscriptions are a separate future effort.

### Setup

1. In Versioner, go to **Settings → Notifications → Email** and add a new channel
2. Enter the recipient email address or distribution list
3. Choose which events to subscribe to and save

Email content includes: product name, environment, status, deployer, timestamp, and a link to the deployment in Versioner.

---

## Webhook

Outbound webhook that fires a JSON `POST` to your endpoint on deployment and build events. Use this to feed DORA dashboards, incident tools, audit systems, or custom workflows.

### Setup

1. Go to **Settings → Notifications → Webhook** and add a new channel
2. Enter the destination URL
3. Optionally enter an HMAC secret for payload verification
4. Choose which events to subscribe to and save

### Request format

Every request includes:

```
Content-Type: application/json
X-Versioner-Event: <event_type>
X-Versioner-Signature: sha256=<hex>   # only if HMAC secret configured
```

### Payload reference

| Field | Type | Nullable | Description |
|-------|------|----------|-------------|
| `id` | string | No | Versioner deployment UUID |
| `deployed_at` | string | No | ISO 8601 timestamp (UTC) |
| `event_type` | string | No | See event types table |
| `environment` | string | No | Target environment name |
| `is_successful` | bool | Yes | See `is_successful` table below |
| `deployer` | string | Yes | Name of deployer |
| `product_name` | string | Yes | Versioner product name |
| `version` | string | Yes | Version string being deployed |
| `repo_name` | string | Yes | `scm_repository` if provided |
| `commit_sha` | string | Yes | `scm_sha` if provided |
| `preflight_status` | string | Yes | `passed`, `failed`, `skipped`, or null |
| `source_url` | string | Yes | Link to deployment in Versioner console |

### `is_successful` by event type

`is_successful` is only set for terminal deployment states. Non-terminal events and all build events receive `null`.

| `event_type` | `is_successful` |
|-------------|----------------|
| `deployment.completed` | `true` |
| `deployment.failed` | `false` |
| `deployment.preflight_failed` | `false` |
| `deployment.pending` | `null` |
| `deployment.started` | `null` |
| `deployment.aborted` | `null` |
| `build.pending` | `null` |
| `build.started` | `null` |
| `build.completed` | `null` |
| `build.failed` | `null` |
| `build.aborted` | `null` |

!!! warning "Filtering for DORA / Jellyfish success and failure"
    If you're filtering webhook events to capture only successful and failed deployments (e.g. for DORA metrics or Jellyfish), filter on `event_type` — not `is_successful` alone.

    `is_successful == false` matches **both** `deployment.failed` and `deployment.preflight_failed`. If you want to exclude preflight failures from your DORA data (since no deployment actually started), filter on `event_type == "deployment.failed"` explicitly.

    Subscribe only to `deployment.completed` and `deployment.failed` events for the cleanest DORA feed.

### Example payload

```json
{
  "id": "ac37da84-0891-48ae-9011-6500665804ee",
  "deployed_at": "2026-05-24T14:06:05.890103+00:00",
  "event_type": "deployment.completed",
  "environment": "production",
  "is_successful": true,
  "deployer": "Phil Austin",
  "product_name": "my-ui",
  "version": "1.2.6",
  "repo_name": "versioner-io/versioner-ui",
  "commit_sha": "a3f9c2d1e4b5...",
  "preflight_status": "passed",
  "source_url": "https://app.versioner.io/manage/deployments?view=ac37da84-0891-48ae-9011-6500665804ee"
}
```

### Retry behavior

On `5xx` or network errors: 3 attempts with exponential backoff (1 s, 2 s). `4xx` responses are treated as terminal — no retry.

### HMAC signature verification

When a secret is configured, Versioner signs the raw compact-JSON body and adds `X-Versioner-Signature: sha256=<hex>`. Verify on receipt before parsing the body.

=== "Python"

    ```python
    import hmac, hashlib

    def verify_signature(secret: str, raw_body: bytes, header: str) -> bool:
        expected = "sha256=" + hmac.new(secret.encode(), raw_body, hashlib.sha256).hexdigest()
        return hmac.compare_digest(expected, header)
    ```

=== "JavaScript"

    ```javascript
    const crypto = require("crypto");

    function verifySignature(secret, rawBody, header) {
      const expected = "sha256=" + crypto.createHmac("sha256", secret).update(rawBody).digest("hex");
      return crypto.timingSafeEqual(Buffer.from(expected), Buffer.from(header));
    }
    ```

!!! warning
    Compute the HMAC over the **raw request body bytes** before any JSON parsing. The body is compact JSON (no spaces).

---

## DR Approval Emails

DR approval emails are automatic — there's nothing to configure here. When a Deployment Request moves to In Progress, Versioner emails users whose role matches an approval slot. See [Deployment Requests](../concepts/governance/deployment-requests.md#approval-workflow) for how the approval flow works.

---

## Related

- [Event Types](../reference/event-types.md) — full event type reference
- [Deployment Requests](../concepts/governance/deployment-requests.md) — how DRs and approval slots work
- [Deployments](../concepts/catalog/deployments.md) — what triggers deployment events
