# Notifications

Stay informed about your deployments through two distinct notification systems: **Slack webhooks** for event-based alerts and **email notifications** for Deployment Request approvals.

## Overview

Versioner provides two notification systems:

1. **Slack Webhooks** — Event-based alerting to Slack channels about deployment and build events
2. **DR Approval Emails** — Action-oriented emails when a Deployment Request requires your approval

## Part 1: Slack Webhooks

Event-based notifications to Slack channels. Configure different events to go to different channels.

### Notification Channels

A **notification channel** represents a destination for notifications (Slack webhooks).

### Creating a Channel

!!! info "CLI Coming Soon"
    Channel management via CLI is planned. For now, use the API directly.

```bash
POST /notification-channels/
{
  "name": "Engineering Slack",
  "channel_type": "slack_webhook",
  "config": {
    "webhook_url": "https://hooks.slack.com/services/..."
  }
}
```

### Slack Webhook Setup

1. Go to [api.slack.com/apps](https://api.slack.com/apps)
2. Create a new app or select existing
3. Enable "Incoming Webhooks"
4. Add webhook to your desired channel
5. Copy the webhook URL
6. Add to Versioner as a notification channel

## Notification Preferences

**Preferences** define which events trigger notifications to which channels.

### Configure Preferences

```bash
POST /notification-preferences/
{
  "channel_id": "550e8400-e29b-41d4-a716-446655440000",
  "event_type": "deployment.completed",
  "filters": {
    "environments": ["production"],
    "products": ["my-service"]
  }
}
```

### Event Types

| Event Type | Description |
|------------|-------------|
| `deployment.pending` | Deployment queued/scheduled |
| `deployment.started` | Deployment begins |
| `deployment.completed` | Deployment succeeds |
| `deployment.failed` | Deployment fails |
| `deployment.aborted` | Deployment cancelled |
| `version.started` | Build begins |
| `version.completed` | Build succeeds |
| `version.failed` | Build fails |
| `version.aborted` | Build cancelled |

See [Event Types](../../api/event-types.md) for details.

### Filters

Narrow down which events trigger notifications:

**By Environment:**
```json
{
  "filters": {
    "environments": ["production", "staging"]
  }
}
```

**By Product:**
```json
{
  "filters": {
    "products": ["my-service", "other-service"]
  }
}
```

**By Status:**
```json
{
  "filters": {
    "statuses": ["failed", "aborted"]
  }
}
```

**Combined:**
```json
{
  "filters": {
    "environments": ["production"],
    "statuses": ["failed"]
  }
}
```

## Slack Message Format

Versioner sends rich, formatted messages using Slack's Block Kit:

### Deployment Success

```
✅ Deployment Success

Product: my-service
Version: 1.2.3
Environment: production
Deployed by: John Doe

🟢 Success • Completed 30 seconds ago
```

### Deployment Failed

```
❌ Deployment Failed

Product: my-service
Version: 1.2.3
Environment: production
Deployed by: John Doe

Error:
```
Lambda timeout after 30s
```

🔴 Failed • 1 minute ago
```

### Build Completed

```
✅ Build Completed

Product: my-service
Version: 1.2.3
Built by: github-actions
Branch: main

Commit: abc123d - Fix authentication bug

🟢 Success • Completed 45 seconds ago
```

## Common Configurations

### Production Deployments Only

Get notified about all production deployments:

```json
{
  "event_type": "deployment.completed",
  "filters": {
    "environments": ["production"]
  }
}
```

### Failures Everywhere

Get notified about failures in any environment:

```json
{
  "event_type": "deployment.failed",
  "filters": {}
}
```

### Specific Product

Get notified about a specific product:

```json
{
  "event_type": "deployment.completed",
  "filters": {
    "products": ["critical-service"]
  }
}
```

### Multiple Channels

Send different events to different channels:

**#deployments channel** - All successful deployments:
```json
{
  "channel_id": "channel-1",
  "event_type": "deployment.completed"
}
```

**#alerts channel** - Only failures:
```json
{
  "channel_id": "channel-2",
  "event_type": "deployment.failed"
}
```

## Notification History

All notifications are tracked in the notification history:

```bash
GET /notification-history/
```

This helps with:

- Debugging notification issues
- Auditing what was sent
- Verifying delivery

## Best Practices

### 1. Use Separate Channels

Create different Slack channels for different notification types:

- **#deployments** - All deployments
- **#deployment-failures** - Only failures
- **#production-deployments** - Production only

### 2. Filter Aggressively

Avoid notification fatigue by filtering:

✅ **Good:**
- Production failures only
- Critical services only
- Specific environments

❌ **Avoid:**
- All events to one channel
- No filters (too noisy)

### 3. Test Notifications

Test your notification setup:

```bash
# Deploy to dev to test notifications
versioner deploy \
  --product test-service \
  --version 1.0.0 \
  --environment dev \
  --status success
```

## Troubleshooting

### Not Receiving Notifications

**Check:**

1. Webhook URL is correct
2. Slack app has permission to post
3. Notification preference is configured
4. Event matches your filters
5. Check notification history for errors

### Duplicate Notifications

**Problem:** Receiving multiple notifications for same event.

**Solution:** Check for duplicate notification preferences with same filters.

### Wrong Channel

**Problem:** Notifications going to wrong Slack channel.

**Solution:** Verify webhook URL points to correct channel.

## Part 2: DR Approval Emails

When a Deployment Request is created and moves to **In Progress**, users whose role matches an approval slot receive an **action-oriented approval email**.

!!! info "Protect tier"
    DR Approval Emails are part of Deployment Requests, available on Protect tier and above.

### How It Works

1. **DR Created and Submitted** — A Deployment Request is created with approval slots by role (e.g., "product", "security")
2. **Approvers Notified** — Users whose role matches an approval slot receive an email
3. **Email Contains:**
   - Summary of what needs approval (product, version, environment)
   - Link directly to the DR in Versioner
   - Clear call-to-action: "Approve" or "Reject"
4. **User Reviews and Acts** — User clicks link, reviews in Versioner UI, approves or rejects
5. **Creator Notified** — When the user approves or rejects, the DR creator receives an email with the outcome

### Example Email Flow

**Scenario:** Create a DR for payment-api v2.0.0 to production, requiring product + security approval.

**Step 1: DR Created**
```
Product: payment-api
Version: 2.0.0
Environment: production
Required Approvals: product, security
```

**Step 2: Approvers Get Emails**

Product team receives:
```
Subject: Approval Requested: payment-api v2.0.0 → production
Body:
  Product team approval required for payment-api v2.0.0
  deployment to production.
  
  [View & Approve] button → links to DR
```

Security team receives similar email.

**Step 3: Approval Actions**

Product reviewer clicks "View & Approve", reviews in Versioner, approves.
→ Approval slot marked complete
→ DR creator gets email: "payment-api DR: Product approval granted by jane@company.com"

Security reviewer is still reviewing...
→ DR remains in "In Progress"

**Step 4: All Approvals Complete**

Security reviewer approves.
→ All approval slots complete
→ DR transitions to "Approved"
→ DR creator gets final email: "payment-api DR: Ready to deploy"

### Email Customization

DR approval emails are **not individually configurable** (they're part of the DR lifecycle), but you can:

- **Set optional approvals** — Some approval slots can be marked optional
- **Create DR templates** — Pre-configure approval slots for common workflows
- **Use role permissions** — Control who has approval permissions via user roles

See [Deployment Requests](../governance/deployment-requests.md) and [User Roles](user-roles.md) for details.

### No Email Fatigue

Unlike Slack webhooks (which can be noisy), DR approval emails are **selective**:

- Only sent when your role matches an approval slot
- One email per DR requiring your approval
- Clear action required (approve/reject)
- No configuration needed—automatically integrated with DRs

## Related Concepts

- **[Deployments](../catalog/deployments.md)** - What triggers notifications
- **[Event Types](../../api/event-types.md)** - All available event types

## Next Steps

- Set up notification channels via the [dashboard](https://app.versioner.io/settings)
- Configure notification preferences in your account settings
- Learn about [Event Types](../../api/event-types.md)
