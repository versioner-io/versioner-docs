# Environment State Matrix

The **Environment State Matrix** is Versioner's core visibility feature. It shows you at a glance what version of each product is running in each environment, detects drift, and provides the foundation for all other Versioner capabilities.

!!! note "Free tier"
    The Environment State Matrix is the primary Free tier feature. It's included in all accounts, including during your 30-day trial.

## What It Shows

The Environment State Matrix is a grid:

- **Rows** = Your products (user-service, payment-api, web-frontend, etc.)
- **Columns** = Your environments (development, staging, production, etc.)
- **Cells** = Current version of that product in that environment

**Example:**

```
Product              │ Development │ Staging   │ Production
─────────────────────┼─────────────┼───────────┼───────────
user-service         │ 2.1.0       │ 2.0.3     │ 2.0.2
payment-api          │ 1.5.2       │ 1.5.2     │ 1.5.1
web-frontend         │ 3.2.0       │ 3.1.5     │ 3.1.5
notification-service │ 1.0.1       │ 1.0.0     │ 1.0.0
```

## Version Drift Detection

The matrix automatically highlights **drift**—when environments should have the same version but don't.

**Example with drift:**

```
Product        │ Staging   │ Production │ Status
───────────────┼───────────┼────────────┼────────────────────
user-service   │ 2.1.0     │ 2.0.2      │ ⚠️ DRIFT (staging ahead)
payment-api    │ 1.5.2     │ 1.5.2      │ ✓ In sync
web-frontend   │ 3.1.5     │ 3.1.5      │ ✓ In sync
```

**Common drift scenarios:**

1. **Ahead** - Staging has a newer version than production (expected during deployments)
2. **Behind** - Production has a newer version than staging (possible rollback or skipped environment)
3. **Critical drift** - Development out of sync by more than 5 versions (possible issues with CI/CD)

## Data Flow

The Environment State Matrix is populated by deployment events:

```
CI/CD System (GitHub Actions, Jenkins, etc.)
    ↓
Versioner API / CLI / GitHub Action
    ↓
Deployment Event: "user-service v2.1.0 deployed to staging"
    ↓
Versioner processes event and updates matrix
    ↓
Dashboard shows: staging cell = 2.1.0
```

### How to Send Deployment Events

**GitHub Actions:**

```yaml
- uses: versioner-io/versioner-github-action@v1
  with:
    api-key: ${{ secrets.VERSIONER_API_KEY }}
    product: user-service
    version: 2.1.0
    environment: staging
    status: success
```

**CLI:**

```bash
versioner track deployment \
  --product user-service \
  --environment staging \
  --version 2.1.0 \
  --status completed
```

**Direct API:**

```bash
curl -X POST https://api.versioner.io/deployments \
  -H "Authorization: Bearer sk_..." \
  -d '{
    "product": "user-service",
    "version": "2.1.0",
    "environment": "staging",
    "status": "completed"
  }'
```

## Understanding Version Metadata

The matrix shows the current version, but you can click to see full metadata:

```json
{
  "product": "user-service",
  "version": "2.1.0",
  "environment": "production",
  "deployed_at": "2024-11-07T14:32:00Z",
  "deployed_by": "github-actions",
  "status": "success",
  "git_sha": "abc123def456",
  "build_number": "542",
  "build_url": "https://github.com/myorg/user-service/actions/runs/542"
}
```

Click on any cell to see:

- Version details (build number, commit SHA)
- Who deployed it and when
- Deployment status
- Links to CI/CD builds
- Deployment history for that product/environment pair

## Filtering and Navigation

### Filter by Product

View only the products you care about:

```
Filter: user-service, payment-api
```

Useful when you have many products and only need to monitor a subset.

### Filter by Environment

View only specific environments:

```
Filter: production, staging
```

Useful for focusing on critical environments or a deployment flow.

### Search

Search by product name:

```
Search: "payment"
```

Displays all products matching the search (payment-api, payment-service, etc.).

## Multi-Environment Flows

The matrix helps you track deployment progression:

```
Deployment Flow: dev → test → staging → production

user-service:
  Dev:        2.2.0 ✓ (deployed 2 hours ago)
  Test:       2.2.0 ✓ (passed all tests)
  Staging:    2.1.5   (still on previous version)
  Production: 2.1.0

Status: Version 2.2.0 is progressing through environments. Ready to promote to staging.
```

Use this to answer questions like:

- "Is 2.2.0 stable in staging?"
- "What version is running in production?"
- "How long has staging been on this version?"
- "What was the previous production version?"

## Auto-Creation of Products and Environments

You don't need to pre-configure products and environments. They're automatically created when you submit your first deployment event.

**First deployment to a new product/environment:**

```bash
versioner track deployment \
  --product my-new-service \
  --environment qa \
  --version 1.0.0
```

**Result:**
- Product `my-new-service` is created automatically
- Environment `qa` is created automatically
- Matrix now includes this product/environment pair
- Future deployments update the same cell

No pre-setup needed—just start tracking deployments.

## Common Use Cases

### Daily Standup

Start your day by checking the matrix:

```
"What version is each service running in production?"
→ Check production column
→ See all current versions at a glance
```

### Deployment Progress Tracking

During a release, monitor progression across environments:

```
"Is the new version stable in staging?"
→ Check staging column
→ See how long it's been running
→ Click for deployment details
```

### Incident Investigation

When something breaks in production:

```
"What changed recently?"
→ Check production column
→ Look at deployment history
→ See what version is currently running
→ Compare to previous versions
```

### Release Coordination

For multi-service releases:

```
"Is all services deployed to production?"
→ Check production column
→ Verify all services at target version
→ Confirm deployment audit trail
```

## Deployment History

Click on any cell to see the deployment history for that product/environment:

```
user-service deployments to production:

1. 2.1.0  | Deployed 1 hour ago by github-actions | Success
2. 2.0.2  | Deployed 2 days ago by github-actions | Success
3. 2.0.1  | Deployed 5 days ago by github-actions | Success
4. 2.0.0  | Deployed 1 week ago by github-actions | Success
```

Each entry shows:

- Version deployed
- When it was deployed
- Who deployed it
- Status (success, failed, etc.)
- Links to CI/CD build

## Real-Time Updates

The matrix updates in real-time as deployment events arrive:

1. CI/CD system completes deployment
2. Sends event to Versioner (via GitHub Action, CLI, or API)
3. Matrix is updated immediately
4. Viewers see new version within seconds

No refresh needed—matrix updates live as events arrive.

## Scalability

The matrix scales to hundreds of products and environments:

- **Free-tier limit:** Up to 50 products × 50 environments tracked
- **Paid tiers:** Scales further (contact sales for limits)

Use filtering and search to manage large matrices effectively.

## Integration Points

The Environment State Matrix is foundational to other Versioner features:

- **[Deployment Requests](deployment-requests.md)** — Create DRs to deploy versions shown in the matrix
- **[Deployment Rules](deployment-rules.md)** — Rules evaluate versions in the matrix
- **[Notifications](notifications.md)** — Get alerted when matrix state changes
- **[Deployment Buttons](../concepts/deployment-buttons.md)** — Trigger deployments from versions in the matrix

## Best Practices

### Consistent Versioning

Use consistent version schemes across products:

✅ **Good:**
- All services use semantic versioning (2.1.0, 2.1.1, etc.)
- Predictable and easy to compare

❌ **Inconsistent:**
- Some services use SHAs, some use dates, some use numbers
- Hard to understand at a glance

### Regular Deployments

Deploy regularly to keep the matrix up-to-date:

- Matrix is only as fresh as your last deployment event
- If a service hasn't been deployed in 6 months, it will still show old version
- Regular updates ensure accurate visibility

### Monitoring Drift

Set up alerts for unexpected drift:

- If staging unexpectedly falls behind production, something may be wrong
- Large version gaps may indicate CI/CD issues
- Regular review of drift helps catch problems early

## Troubleshooting

### Matrix Shows Old Version

**Problem:** Matrix shows version that was deployed days ago, but you deployed a new version.

**Solution:**
1. Check that your CI/CD is sending deployment events
2. Verify API key is correct
3. Verify product and environment names match exactly (case-sensitive)
4. Check API response codes for errors

### Unexpected Drift

**Problem:** Staging is showing ahead of production unexpectedly.

**Solution:**
1. Check deployment history (click on cells)
2. Verify which version should be where
3. Check if a failed deployment was marked as success
4. Review deployment order in CI/CD

### Missing Product/Environment

**Problem:** A product or environment isn't showing in the matrix.

**Solution:**
1. Confirm you've sent at least one deployment event for it
2. Check product and environment names (case-sensitive, hyphens vs underscores)
3. Verify API key has access to the account
4. Try sending a test event

## Related Concepts

- **[Products](products.md)** - Deployable services shown as rows
- **[Environments](environments.md)** - Deployment targets shown as columns
- **[Versions](versions.md)** - Version numbers displayed in cells
- **[Deployments](deployments.md)** - Deployment events populate the matrix
- **[Notifications](notifications.md)** - Get alerted when matrix changes

## Next Steps

- Set up your first deployment event using [Getting Started](../getting-started.md)
- Configure notifications to stay informed with [Notifications](notifications.md)
- Learn about [Deployment Requests](deployment-requests.md) for governed deployments
