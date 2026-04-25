# Troubleshooting

Common errors returned by the Versioner API, regardless of how you're integrating — Native integration, CLI, or direct API calls.

## Authentication Errors

### 401 Unauthorized

API key is invalid, expired, or not set.

- Verify your API key is correct in [Settings → API Keys](https://app.versioner.io/settings/api-keys)
- Check the key is stored correctly in your CI/CD secrets (no extra whitespace)
- Ensure the secret name in your workflow matches the one you configured

## Validation Errors

### 422 Unprocessable Entity

Required fields are missing or contain invalid values.

- Ensure `product`, `version`, and `environment` are all provided
- Check that values are non-empty strings
- See [Event Tracking](../api/event-tracking.md) for field requirements and valid values

## Deployment Rule Violations

These errors are returned when a [Deployment Rule](../concepts/deployment-rules.md) blocks a deployment. They always fail the workflow — `fail-on-api-error: false` does **not** suppress them.

### 423 Locked — No-Deploy Window Active

A scheduled no-deploy window is currently in effect.

- Check the error message for when the window ends
- For emergencies, an admin can temporarily set the rule to **Report Only** in the Versioner UI, then re-enable it after

### 428 Precondition Failed

The deployment doesn't meet one or more policy requirements. The error message will indicate which rule failed:

| Cause | Resolution |
|-------|-----------|
| **Flow violation** | Deploy to required environments first (e.g., staging before production) |
| **Insufficient soak time** | Wait for the required soak period to elapse |
| **Missing approval** | Obtain the required approval via the Versioner UI |

For emergencies, an admin can temporarily set the blocking rule to **Report Only**.

## Testing Policies Before Enforcing

Before enabling a new Deployment Rule in enforcing mode, set it to **Report Only**. Violations will be logged and visible in the dashboard but won't block deployments. Switch to **Enabled** once you're confident the policy is correct.

See [Deployment Rules](../concepts/deployment-rules.md) for details.

## Still stuck?

Contact [support@versioner.io](mailto:support@versioner.io).
