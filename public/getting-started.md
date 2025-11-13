# Getting Started with Versioner

This guide will help you get up and running with Versioner in just a few minutes.

## Prerequisites

Before you begin, you'll need:

- Access to your CI/CD system (GitHub Actions, Jenkins, GitLab CI, etc.)
- Basic familiarity with REST APIs or command-line tools

## Step 1: Create an Account and Get Your API Key

Visit [app.versioner.io](https://app.versioner.io) to create an account. Once logged in, go to the Settings page and create your first API key.

Your API key will look like this:
```
sk_mycompany_k1_abc123def456...
```

!!! warning "Keep Your API Key Secret"
    Never commit your API key to version control. Store it as a secret in your CI/CD system.

## Step 2: Choose Your Integration

Versioner offers three ways to integrate:

### Option A: Native Integrations

Versioner supports native integrations for multiple CI/CD systems such as GitHub Actions and other systems.

**GitHub Actions example:**

```yaml
name: Deploy to Production

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      # Your deployment steps here
      - name: Deploy
        run: ./deploy.sh

      # Track deployment in Versioner
      - uses: versioner-io/versioner-github-action@v1
        with:
          api-key: ${{ secrets.VERSIONER_API_KEY }}
          product: my-service
          version: ${{ github.sha }} # or any other version identifier
          environment: production
          status: success
```

See the [Native Integrations](integrations/index.md) page for more details and examples on supported systems.

### Option B: CLI

The Versioner CLI can work with any CI/CD system or custom script.

**Example:**

```bash
# Set your API key
export VERSIONER_API_KEY="sk_mycompany_k1_..."

# Submit a deployment event
versioner deploy \
  --product my-service \
  --version 1.2.3 \
  --environment production \
  --status success
```

See the [CLI Documentation](cli/index.md) for more details and examples.

### Option C: Direct API

For maximum flexibility, you can use the REST API directly.

**Example with curl:**

```bash
curl -X POST https://api.versioner.io/deployment-events/ \
  -H "Authorization: Bearer sk_mycompany_k1_..." \
  -H "Content-Type: application/json" \
  -d '{
    "product_name": "my-service",
    "version": "1.2.3",
    "environment_name": "production",
    "status": "success",
    "deployed_by": "john.doe"
  }'
```

See the [API Documentation](api/index.md) for more details and examples.

## Step 3: Submit Your First Event

Let's submit a test deployment event to verify everything is working.

=== "GitHub Action"

    ```yaml
    - uses: versioner-io/versioner-github-action@v1
      with:
        api-key: ${{ secrets.VERSIONER_API_KEY }}
        product: test-service
        version: 1.0.0
        environment: dev
        status: success
    ```

=== "CLI"

    ```bash
    versioner deploy \
      --product test-service \
      --version 1.0.0 \
      --environment dev \
      --status success
    ```

=== "API"

    ```bash
    curl -X POST https://api.versioner.io/deployment-events/ \
      -H "Authorization: Bearer $VERSIONER_API_KEY" \
      -H "Content-Type: application/json" \
      -d '{
        "product_name": "test-service",
        "version": "1.0.0",
        "environment_name": "dev",
        "status": "success"
      }'
    ```

**Expected Response:**

```json
{
    "id": "a892e167-7ef0-414f-a675-640116d66472",
    "status": "completed",
    "source_system": "github",
    "completed_at": "2025-11-07T14:20:24.881217Z",
    "version_id": "6d952834-80cf-496e-b4c1-d1674efa99b1",
    "version": "1.0.0",
    "product_id": "282f0207-6cd6-45eb-b03a-87cc0c451558",
    "product_name": "test-service",
    "environment_id": "89d76264-be52-4750-aa9e-d98c0c613e8a",
    "environment_name": "dev",
    "deployed_by": "a127c4e3-9bb4-44b4-ab26-412a2636c741",
    "deployed_at": "2025-11-07T14:20:20.861927Z",
    "deployed_by_name": "John Doe",
    "deployed_by_email": "john.doe@mycompany.com",
    "extra_metadata": null,
}
```

!!! success "Success!"
    If you see a response like above, you've successfully submitted your first deployment event!

## Step 4: View Your Deployments

Visit your [dashboard](https://app.versioner.io/dashboard) to see all your environments and deployments in one place.

## Step 5: Set Up Notifications

Get real-time Slack notifications for deployments and build events

**1. Create an Incoming Webhook in Your Slack Workspace:**

- Go to [api.slack.com/apps](https://api.slack.com/apps)
- Create a new app
- Enable Incoming Webhooks
- Add webhook to your channel
- Copy the webhook URL

**2. Configure Versioner:**

Go to your [organization settings](https://app.versioner.io/settings/organization) page and add your Slack webhook URL.

Choose what events you want to subscribe to.

See the [Notifications Guide](concepts/notifications.md) for more details.

## Step 6: Add Deployment Buttons (Optional)

Streamline your deployment workflow with one-click deployment buttons that link directly to your deployment tools.

**What are deployment buttons?**

Deployment buttons create pre-configured URLs to your deployment tools (Rundeck, Jenkins, etc.) with the correct version and parameters already filled in. They appear in the Versioner UI and Slack notifications.

**Quick example:**

Instead of manually navigating to Rundeck and entering version numbers, click "Deploy" and Rundeck opens with everything pre-filled.

**Setup:**

1. Define [variables](concepts/variables.md) for your deployment tool URLs and configuration
2. Create [deployment templates](concepts/deployment-buttons.md) that use those variables
3. Click "Deploy" buttons in the UI or Slack notifications

See the [Deployment Buttons Guide](concepts/deployment-buttons.md) for detailed setup instructions.

## Next Steps

Now that you're up and running, explore more features:

### Learn Core Concepts
- [Products](concepts/products.md) - Understanding the product concept
- [Environments](concepts/environments.md) - Defining deployment targets
- [Versions](concepts/versions.md) - Managing build versions
- [Deployments](concepts/deployments.md) - Understanding deployment tracking
- [Notifications](concepts/notifications.md) - Setting up notifications
- [Releases](concepts/releases.md) - Group deployments into releases
- [Variables](concepts/variables.md) - Reusable configuration values
- [Deployment Buttons](concepts/deployment-buttons.md) - One-click deployment shortcuts

### Features Coming Soon
- **Pre-flight Checks** - Validate deployments before they happen
- **Approval Workflows** - Require approvals for production

### Integration Guides
- [Native Integrations](integrations/index.md) - Native integrations in various CICD systems
- [CLI Documentation](cli/index.md) - Universal CLI tool
- [API Documentation](api/index.md) - Direct API integration

## Troubleshooting

### "401 Unauthorized" Error

**Problem:** Your API key is invalid or missing.

**Solution:**
- Verify your API key is correct
- Ensure it's properly set in your environment or CI/CD secrets
- Check that you're using the `Bearer` authentication scheme

### "404 Not Found" Error

**Problem:** The endpoint URL is incorrect.

**Solution:**
- Verify you're using the correct base URL: `https://api.versioner.io`
- Check the endpoint path matches the documentation

### "422 Validation Error"

**Problem:** Your request body is missing required fields or has invalid data.

**Solution:**
- Check the [Event Tracking API](api/event-tracking.md) for required fields
- Ensure field types match (strings, numbers, etc.)
- Validate your JSON syntax

### Need More Help?

- Check the [Interactive API Docs](api/interactive-docs.md) for detailed endpoint documentation
- Review [Response Codes](api/response-codes.md) for specific error messages
- Contact: support@versioner.io
