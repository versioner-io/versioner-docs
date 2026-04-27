# Notifications

Stay informed about your deployments through two distinct notification systems: **Slack webhooks** for event-based alerts and **email notifications** for Deployment Request approvals.

## Overview

Versioner provides two notification systems:

1. **Slack Webhooks** — Event-based alerting to Slack channels about deployment and build events
2. **DR Approval Emails** — Action-oriented emails when a Deployment Request requires your approval

## Part 1: Slack Webhooks

Event-based notifications to Slack channels. Configure different events to go to different channels.

### Slack Webhook Setup

1. Go to [api.slack.com/apps](https://api.slack.com/apps)
2. Create a new app or select existing
3. Enable "Incoming Webhooks"
4. Add webhook to your desired channel
5. Copy the webhook URL
6. In Versioner, go to Settings > Integrations and add the webhook
7. Choose which events you want to send messages for and click save

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

## Common Configurations

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

All notifications are tracked in the notification history audit log.

This helps with:

- Debugging notification issues
- Auditing what was sent
- Verifying delivery

## Best Practices

### 1. Use Separate Channels

Create different Slack channels for different notification types:

- **#deployments** - All deployments
- **#deployment-failures** - Only failures

### 2. Test Notifications

Test your Slack notification by hitting the Test button in the UI.


## Troubleshooting

### Not Receiving Notifications

**Check:**

1. Webhook URL is correct
2. Slack app has permission to post

### Duplicate Notifications

**Problem:** Receiving multiple notifications for same event.

**Solution:** Check for duplicate Slack webhooks with same events configured.


## Part 2: DR Approval Emails

When a Deployment Request is created and moves to **In Progress**, users whose role matches an approval slot receive an **action-oriented approval email**.

!!! info "Protect tier"
    DR Approval Emails are part of Deployment Requests, available on Protect tier and above.

### How It Works

1. **DR Created and Submitted** — A Deployment Request is created with approval slots by role (e.g., "product", "security")
2. **DR moves to In Progress** - The trigger for approval notifications is when the DR is put into In Progress state
3. **Approvers Notified** — Users whose role matches an approval slot receive an email
4. **Email Contains:**
   - Summary of what needs approval (product, version, environment)
   - Link directly to the DR in Versioner
5. **User Reviews and Acts** — User clicks link, reviews in Versioner UI, approves or rejects
6. **Creator Notified** — When the user approves or rejects, the DR creator receives an email with the outcome

### No Email Fatigue

Unlike Slack webhooks (which can be noisy), DR approval emails are **selective**:

- Only sent when your role matches an approval slot
- One email per DR requiring your approval
- Clear action required (approve/reject)
- No configuration needed—automatically integrated with DRs

## Related Concepts

- **[Deployments](../catalog/deployments.md)** - What triggers notifications
- **[Event Types](../../api/event-types.md)** - All available event types
