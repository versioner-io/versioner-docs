# Getting Started with Versioner

This guide will help you get up and running with Versioner in just a few minutes.

## Prerequisites

Before you begin, you'll need:

- Access to your CI/CD system (GitHub Actions, Jenkins, GitLab CI, etc.)
- Basic familiarity with REST APIs or command-line tools

## Step 1: Create an Account and Get Your API Key

Visit [app.versioner.io](https://app.versioner.io) to create an account. New accounts get 30 days of full Enforce-level access to try all features.

Once logged in, go to Settings → API Keys and create your first key.

Your API key will look like this:
```
sk_mycompany_k1_abc123def456...
```

!!! warning "Keep Your API Key Secret"
    Never commit your API key to version control. Store it as a secret in your CI/CD system.

## Step 2: Choose Your Integration

Versioner offers three ways to integrate with your deployment workflow:

### Native Integrations

Platform-specific plugins that integrate directly with your CI/CD system. Currently supports GitHub Actions with more platforms coming soon.

[:octicons-arrow-right-24: View Native Integrations Guide](integrations/index.md)

### CLI

A universal command-line tool that works with any CI/CD system or deployment environment. Perfect for custom scripts and workflows.

[:octicons-arrow-right-24: View CLI Documentation](cli/index.md)

### REST API

Direct API access for maximum trust, flexibility and custom integrations. Use any HTTP client or programming language.

[:octicons-arrow-right-24: View API Documentation](api/index.md)

## Step 3: Set Up Notifications (Optional)

Before you submit your first event, connect a Slack channel so you can see deployment activity in real time as it comes in.

Generate a webhook in your Slack administration settings and then go to **Settings → Integrations** and add your Slack webhook URL. Choose the events you want to receive notifications for and Versioner will post to that channel whenever a matching deployment event is received.

!!! note "Slack required"
    Versioner currently supports Slack for deployment notifications. If your team doesn't use Slack, [let us know](mailto:support@versioner.io) — other notification options are on the roadmap.

## Step 4: Submit Your First Event

Follow the setup instructions in your chosen integration guide to submit your first deployment event. Each guide includes step-by-step instructions and examples.

Once you've submitted an event, you'll receive a JSON response confirming the deployment was tracked successfully.

## Step 5: View Your Deployments

Visit your [dashboard](https://app.versioner.io/dashboard) to see all your environments and deployments in one place.

!!! success "You're all set!"
    You've successfully integrated Versioner and tracked your first deployment. Explore the features below to get even more value from Versioner.

## What's Next?

### Progressive Adoption: Three Levels

Versioner works in three levels. Start with visibility, then add control, then governance.

#### Level 1: Observe
- You now have visibility into what's deployed where.
- **Next**: Explore the [Environment State Matrix](concepts/environment-state-matrix.md) to see your deployments organized by product and environment.

#### Level 2: Protect
- Add governed workflows for shipping code.
- **Next**: Learn about [Deployment Requests](concepts/deployment-requests.md) to create approval gates and track compliance for individual deployment activities.

#### Level 3: Enforce
- Add automated policies that enforce organizational standards.
- **Next**: Explore [Deployment Rules](concepts/deployment-rules.md) to define no-deploy windows, required sequences, and approval requirements.

### Learning Path

**1. Get familiar with the basics:**

- [Environment State Matrix](concepts/environment-state-matrix.md) - What's running where
- [Deployments](concepts/deployments.md) - How tracking works
- [Products, Versions, Environments](concepts/products.md) - Core data model

**2. Set up notifications:**

- [Notifications](concepts/notifications.md) - Slack alerts and approval emails

**3. Add governance (if on Protect+):**

- [Deployment Requests](concepts/deployment-requests.md) - Create approval workflows
- [User Roles](concepts/user-roles.md) - Define who can approve what

**4. Enforce policy (if on Enforce):**

- [Deployment Rules](concepts/deployment-rules.md) - Automated policy enforcement
- [Deployment Buttons](concepts/deployment-buttons.md) - Quick deployment shortcuts


### Need Help?
- Check the [Interactive API Docs](api/interactive-docs.md) for detailed endpoint documentation
- Review [Response Codes](api/response-codes.md) for error troubleshooting
- Contact: support@versioner.io
