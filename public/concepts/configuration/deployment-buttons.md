# Deployment Buttons

Trigger deployments directly from Versioner's UI or Slack notifications with one-click shortcuts to your deployment tools.

## Overview

Deployment buttons provide quick access to your deployment tools by generating pre-configured URLs that link to your existing deployment infrastructure (Jenkins, GitLab CI, custom tools, etc.).

**Important:** Versioner requires no access to your CI/CD system. Buttons simply navigate to your tools—your deployment system retains full control.

### Pre-fill vs. Navigate-Only

Not all CI/CD systems support URL-based parameter pre-filling, and it matters for how your team experiences deployment buttons:

| Behavior | Examples | What happens |
|----------|----------|--------------|
| **Pre-fill** | Jenkins, GitLab CI, custom tools | Button opens the tool with version and environment already populated. User clicks Run. |
| **Navigate-only** | GitHub Actions | Button opens the workflow page. User still clicks "Run workflow" and fills in parameters manually. |

For GitHub Actions, the button takes you directly to the right workflow, which still saves navigation time—but expect one extra manual step compared to tools that support pre-fill.

## Why Use Deployment Buttons?

### Without Deployment Buttons

```
1. Receive Slack notification: "Build v1.2.3 ready"
2. Open Jenkins in browser
3. Navigate to correct job
4. Click "Build with Parameters"
5. Manually enter version: 1.2.3
6. Select environment
7. Click run
```

### With Deployment Buttons

```
1. Receive Slack notification: "Build v1.2.3 ready"
2. Click "Deploy" button
3. Jenkins opens with version 1.2.3 pre-filled
4. Click run
```

**Result:** Faster deployments, fewer errors, better team efficiency.

## How It Works

Deployment buttons use three components:

1. **[Variables](variables.md)** - Configuration values (URLs, IDs, etc.)
2. **Templates** - URL patterns with variable placeholders
3. **Environments** - Where the deployment buttons appear

### 1. Variables

Variables store reusable configuration values. See the [Variables](variables.md) guide for full details.

**Example variables:**

```
Organization level:
  jenkins_base_url = "https://jenkins.mycompany.com"

Product level (user-service):
  jenkins_job_name = "deploy-user-service"
```

### 2. Templates

Templates are URL patterns that reference variables using `{variable_name}` syntax.

**Example template:**

```
{jenkins_base_url}/job/{jenkins_job_name}/buildWithParameters?VERSION={vi_version}&ENV={vi_environment_name}
```

**Rendered URL (for version 1.2.3, staging):**

```
https://jenkins.mycompany.com/job/deploy-user-service/buildWithParameters?VERSION=1.2.3&ENV=staging
```

Notice how:
- `{jenkins_base_url}` → organization variable
- `{jenkins_job_name}` → product variable
- `{vi_version}` and `{vi_environment_name}` → system variables (automatically provided)

### 3. Environment Association

Each template is associated with one or more environments (dev, staging, production, etc.). This determines where the deployment button appears.

**Example:**

- Template: "Deploy to Jenkins"
- Associated environments: development, staging, production
- Result: Deploy button appears for all three environments

## Setting Up Deployment Buttons

### Step 1: Define Variables

**Organization variables** (Settings → Organization → Variables):

```
jenkins_base_url = "https://jenkins.mycompany.com"
```

**Product variables** (Manage → Products → [Product] → Variables):

```
jenkins_job_name = "deploy-user-service"
```

!!! tip "Start Simple"
    Begin with just the variables you need. You can always add more later.

### Step 2: Create a Template

Navigate to **Manage → Products → [Product] → Deployment Templates**.

1. Click **New Template**
2. Enter a name: `Deploy to Jenkins`
3. Enter the URL template:
   ```
   {jenkins_base_url}/job/{jenkins_job_name}/buildWithParameters?VERSION={vi_version}&ENV={vi_environment_name}
   ```
4. Select environments: development, staging, production
5. Preview the template to verify it renders correctly
6. Save

### Step 3: Test the Button

1. Go to **Manage → Versions**
2. Find a version
3. Click the **Deploy** button
4. Select an environment
5. Verify the deployment tool opens with correct parameters

## Using Deployment Buttons

### In the UI

**Button behavior:**

- **Single environment:** Direct button (no dropdown)
- **Multiple environments:** Dropdown menu
- **Click:** Opens deployment tool in new browser tab

### In Slack

When Versioner sends Slack notifications, deployment buttons are automatically included. Clicking the button opens your deployment tool with the correct parameters.

!!! info "Notification Setup Required"
    Deployment buttons in Slack require [notification preferences](notifications.md) to be configured.

## Examples by CI/CD System

### Jenkins

Supports pre-fill. Jenkins accepts build parameters in the URL via `buildWithParameters`:

```
{jenkins_base_url}/job/{jenkins_job_name}/buildWithParameters?VERSION={vi_version}&ENV={vi_environment_name}
```

With SHA:
```
{jenkins_base_url}/job/{jenkins_job_name}/buildWithParameters?GIT_SHA={vi_sha}&TARGET={vi_environment_name}
```

### GitLab CI

Supports pre-fill. GitLab's new pipeline page accepts variables via URL query params:

```
https://gitlab.com/{gitlab_group}/{gitlab_project}/-/pipelines/new?var[VERSION]={vi_version}&var[ENV]={vi_environment_name}
```

### GitHub Actions

Navigate-only. The URL opens the workflow dispatch page; users click "Run workflow" and fill in parameters manually.

```
https://github.com/{org}/{repo}/actions/workflows/deploy.yml
```

!!! note "GitHub Actions is navigate-only"
    GitHub Actions doesn't support pre-filling parameters via URL. The button navigates directly to the right workflow, saving navigation time—but the user still enters parameters manually.

### Custom Tools

Any web-based deployment system that accepts URL parameters:

```
{deploy_tool_url}/api/deploy?product={vi_product_name}&version={vi_version}&env={vi_environment_name}
```

## Advanced Configuration

### Multiple Templates per Product

Create separate templates for different scenarios:

**Template 1: "Deploy to Staging"**
- Environments: development, staging
- URL: `{jenkins_base_url}/job/{jenkins_job_name_nonprod}/buildWithParameters?VERSION={vi_version}`

**Template 2: "Deploy to Production"**
- Environments: production
- URL: `{jenkins_base_url}/job/{jenkins_job_name_prod}/buildWithParameters?VERSION={vi_version}`

### Conditional Parameters

Add optional parameters using URL query strings:

```
{jenkins_base_url}/job/{jenkins_job_name}/buildWithParameters?VERSION={vi_version}&SHA={vi_sha}&BUILD={vi_build_number}
```

## Best Practices

### Test Templates Before Saving

Always use the preview feature to verify your template renders correctly:

1. Enter template URL
2. Select an environment
3. Click **Preview**
4. Verify the rendered URL
5. Click **Test URL** to open it in a new tab

### Start with Organization Variables

Define common values at the organization level to avoid repetition across products:

```
Organization:
  jenkins_base_url = "https://jenkins.mycompany.com"
```

### Use Descriptive Template Names

✅ Good: "Deploy to Jenkins Staging", "Trigger Production Pipeline"

❌ Avoid: "Template 1", "Deploy", "Button"

### Keep Templates Simple

✅ Good:
```
{jenkins_base_url}/job/{jenkins_job_name}/buildWithParameters?VERSION={vi_version}
```

❌ Overly complex:
```
{base_url}/api/v{api_version}/projects/{project_id}/environments/{env_id}/deployments/create?version={vi_version}&sha={vi_sha}&build={vi_build_number}&user={user_id}&timestamp={timestamp}
```

## Troubleshooting

### Button Not Appearing

Verify the template is enabled and associated with the environment. Check that all variables used in the template exist and the template preview shows no rendering errors.

### Wrong URL Generated

Use the template preview to see the rendered URL. Verify variable values are correct and check for typos in variable names.

### Missing Variable Error

Create the missing variable at organization or product level. Variable names are case-sensitive.

### Multiple Buttons for Same Environment

Each environment can only be associated with one template per product. If you see multiple buttons, check for misconfigured templates.

## Security Considerations

Deployment buttons construct URLs that may be visible in browser history, server logs, and network traffic.

- Avoid including sensitive data in templates
- Use POST-based deployment tools when possible
- Ensure deployment tools have proper authentication

Deployment buttons provide **navigation**, not **authorization**. Users still need proper permissions in the deployment tool—buttons simply construct URLs and don't bypass security. Versioner requires no credentials or code access.

## Related Concepts

- **[Variables](variables.md)** - Configuration system powering deployment buttons
- **[Notifications](notifications.md)** - Slack notifications include deployment buttons
- **[Deployments](../catalog/deployments.md)** - Track deployments triggered via buttons
- **[Environments](../catalog/environments.md)** - Deployment buttons are scoped to environments
