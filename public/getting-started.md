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

Versioner offers three ways to integrate with your deployment workflow:

### Native Integrations

Platform-specific plugins that integrate directly with your CI/CD system. Currently supports GitHub Actions with more platforms coming soon.

[:octicons-arrow-right-24: View Native Integrations Guide](integrations/index.md)

### CLI

A universal command-line tool that works with any CI/CD system or deployment environment. Perfect for custom scripts and workflows.

[:octicons-arrow-right-24: View CLI Documentation](cli/index.md)

### REST API

Direct API access for maximum flexibility and custom integrations. Use any HTTP client or programming language.

[:octicons-arrow-right-24: View API Documentation](api/index.md)

## Step 3: Submit Your First Event

Follow the setup instructions in your chosen integration guide to submit your first deployment event. Each guide includes step-by-step instructions and examples.

Once you've submitted an event, you'll receive a JSON response confirming the deployment was tracked successfully.

## Step 4: View Your Deployments

Visit your [dashboard](https://app.versioner.io/dashboard) to see all your environments and deployments in one place.

!!! success "You're all set!"
    You've successfully integrated Versioner and tracked your first deployment. Explore the features below to get even more value from Versioner.

## Next Steps

Now that you're up and running, explore more features:

### Enhance Your Workflow
- **[Notifications](concepts/notifications.md)** - Get real-time Slack notifications for deployments and build events
- **[Deployment Buttons](concepts/deployment-buttons.md)** - Add one-click deployment shortcuts to your workflow
- **[Releases](concepts/releases.md)** - Group multiple product deployments into coordinated releases

### Learn Core Concepts
- [Products](concepts/products.md) - Understanding the product concept
- [Environments](concepts/environments.md) - Defining deployment targets
- [Versions](concepts/versions.md) - Managing build versions
- [Deployments](concepts/deployments.md) - Understanding deployment tracking
- [Variables](concepts/variables.md) - Reusable configuration values

### Integration Guides
- [Native Integrations](integrations/index.md) - Native integrations in various CICD systems
- [CLI Documentation](cli/index.md) - Universal CLI tool
- [API Documentation](api/index.md) - Direct API integration

### Need Help?
- Check the [Interactive API Docs](api/interactive-docs.md) for detailed endpoint documentation
- Review [Response Codes](api/response-codes.md) for specific error messages
- Contact: support@versioner.io
