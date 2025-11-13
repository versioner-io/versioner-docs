# Deployment Buttons

Trigger deployments directly from Versioner's UI or Slack notifications with one-click deployment buttons.

## Overview

Deployment buttons provide quick access to your deployment tools by generating pre-configured URLs that link to your existing deployment infrastructure (Rundeck, Jenkins, custom tools, etc.).

**Key principle:** Deployment buttons **construct and open URLs** in your browser. They don't execute deployments directly—they provide a convenient shortcut to your deployment tools with the correct parameters already filled in.

## Why Use Deployment Buttons?

### Without Deployment Buttons

```
1. Receive Slack notification: "Build v1.2.3 ready"
2. Open Rundeck in browser
3. Navigate to correct project
4. Find the deployment job
5. Manually enter version: 1.2.3
6. Select environment
7. Click run
```

### With Deployment Buttons

```
1. Receive Slack notification: "Build v1.2.3 ready"
2. Click "Deploy" button
3. Rundeck opens with version 1.2.3 pre-filled
4. Click run
```

**Result:** Faster deployments, fewer errors, better team efficiency.

## Use Cases

### Rundeck Deployments

Navigate directly to a Rundeck job with the version pre-filled:

```
https://rundeck.mycompany.com/project/DevDeployments/job/show/de5587ec?opt.git_ref=1.2.3
```

### Jenkins Deployments

Open a Jenkins job with build parameters ready:

```
https://jenkins.mycompany.com/job/deploy-api/buildWithParameters?VERSION=1.2.3&ENV=production
```

### Custom Deployment Tools

Link to any web-based deployment system:

```
https://deploy.mycompany.com/products/my-api/deploy?version=1.2.3&target=staging
```

### Slack-Driven Workflows

1. CI/CD builds version `1.2.3`
2. Versioner sends Slack notification with "Deploy" button
3. Team member clicks button
4. Deployment tool opens with correct parameters
5. Review and execute deployment

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
  rundeck_base_url = "https://rundeck.mycompany.com"

Product level (user-service):
  rundeck_project = "DevDeployments"
  rundeck_job_id = "de5587ec-3a68-435f-be33-2d6fe99587c1"
```

### 2. Templates

Templates are URL patterns that reference variables using `{variable_name}` syntax.

**Example template:**

```
{rundeck_base_url}/project/{rundeck_project}/job/show/{rundeck_job_id}?opt.git_ref={vi_version}
```

**Rendered URL (for version 1.2.3):**

```
https://rundeck.mycompany.com/project/DevDeployments/job/show/de5587ec?opt.git_ref=1.2.3
```

Notice how:
- `{rundeck_base_url}` → organization variable
- `{rundeck_project}` → product variable
- `{rundeck_job_id}` → product variable
- `{vi_version}` → system variable (automatically provided)

### 3. Environment Association

Each template is associated with one or more environments (dev, staging, production, etc.). This determines where the deployment button appears.

**Example:**
- Template: "Deploy to Rundeck"
- Associated environments: development, staging, production
- Result: Deploy button appears for all three environments

## Setting Up Deployment Buttons

### Step 1: Define Variables

Start by defining the variables you'll need in your templates.

**Organization variables** (Settings → Organization → Variables):

```
rundeck_base_url = "https://rundeck.mycompany.com"
jenkins_base_url = "https://jenkins.mycompany.com"
```

**Product variables** (Manage → Products → [Product] → Variables):

```
rundeck_project = "DevDeployments"
rundeck_job_id = "de5587ec-3a68-435f-be33-2d6fe99587c1"
rundeck_option_name = "git_ref"
```

!!! tip "Start Simple"
    Begin with just the variables you need. You can always add more later.

### Step 2: Create a Template

Navigate to **Manage → Products → [Product] → Deployment Templates**.

1. Click **New Template**
2. Enter a name: `Deploy to Rundeck`
3. Enter the URL template:
   ```
   {rundeck_base_url}/project/{rundeck_project}/job/show/{rundeck_job_id}?opt.{rundeck_option_name}={vi_version}
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

Deployment buttons appear in multiple locations:

**Dashboard:**
```
Recent Versions
┌─────────────────────────────────────────────┐
│ user-service  │ 1.2.3  │ [Deploy ▼]        │
│                                              │
│ Deploy to:                                   │
│   • development                              │
│   • staging                                  │
│   • production                               │
└─────────────────────────────────────────────┘
```

**Versions Page:**
```
Versions
┌─────────────────────────────────────────────┐
│ Version │ SHA     │ Created │ Actions       │
├─────────────────────────────────────────────┤
│ 1.2.3   │ abc123  │ 2h ago  │ [Deploy ▼]    │
└─────────────────────────────────────────────┘
```

**Releases Page:**
```
Release: Q4 Sprint 3
┌─────────────────────────────────────────────┐
│ Product      │ Version │ Status │ Actions   │
├─────────────────────────────────────────────┤
│ user-service │ 1.2.3   │ ✓ Dev  │ [Deploy ▼]│
└─────────────────────────────────────────────┘
```

**Button behavior:**
- **Single environment:** Direct button (no dropdown)
- **Multiple environments:** Dropdown menu
- **Click:** Opens deployment tool in new browser tab

### In Slack

When Versioner sends Slack notifications, deployment buttons are automatically included:

```
🚀 New build ready: user-service v1.2.3

Build: #42
SHA: abc123def
Environment: development

[Deploy]
```

Clicking the button opens your deployment tool with the correct parameters.

!!! info "Notification Setup Required"
    Deployment buttons in Slack require [notification preferences](notifications.md) to be configured.

## Template Examples

### Rundeck

**Basic deployment:**
```
{rundeck_base_url}/project/{rundeck_project}/job/show/{rundeck_job_id}?opt.version={vi_version}
```

**With environment parameter:**
```
{rundeck_base_url}/project/{rundeck_project}/job/show/{rundeck_job_id}?opt.version={vi_version}&opt.environment={vi_environment_name}
```

### Jenkins

**Build with parameters:**
```
{jenkins_base_url}/job/{jenkins_job_name}/buildWithParameters?VERSION={vi_version}&ENV={vi_environment_name}
```

**Parameterized build with SHA:**
```
{jenkins_base_url}/job/{jenkins_job_name}/buildWithParameters?GIT_SHA={vi_sha}&TARGET={vi_environment_name}
```

### Custom Tools

**REST API trigger:**
```
{deploy_tool_url}/api/deploy?product={vi_product_name}&version={vi_version}&env={vi_environment_name}
```

**Dashboard link:**
```
{deploy_dashboard_url}/deployments/new?product_id={vi_product_id}&version={vi_version}
```

## Advanced Configuration

### Multiple Templates per Product

You can create multiple templates for different deployment scenarios:

**Template 1: "Deploy to Rundeck"**
- Environments: development, staging
- URL: `{rundeck_base_url}/job/{rundeck_job_id_nonprod}?version={vi_version}`

**Template 2: "Deploy to Production"**
- Environments: production
- URL: `{rundeck_base_url}/job/{rundeck_job_id_prod}?version={vi_version}`

### Environment-Specific Variables

Use different variables for different environments:

```
Product variables:
  rundeck_job_id_dev = "abc-123"
  rundeck_job_id_staging = "def-456"
  rundeck_job_id_prod = "ghi-789"

Template:
  {rundeck_base_url}/job/{rundeck_job_id_{vi_environment_name}}?version={vi_version}
```

!!! warning "Complex Templates"
    While Versioner supports complex templates, simpler templates are easier to maintain. Consider creating separate templates for different environments instead of complex variable substitution.

### Conditional Parameters

Add optional parameters using URL query strings:

```
{jenkins_base_url}/job/{jenkins_job_name}/buildWithParameters?VERSION={vi_version}&SHA={vi_sha}&BUILD={vi_build_number}
```

## Best Practices

### 1. Test Templates Before Saving

Always use the preview feature to verify your template renders correctly:

1. Enter template URL
2. Select an environment
3. Click **Preview**
4. Verify the rendered URL
5. Click **Test URL** to open it in a new tab

### 2. Start with Organization Variables

Define common values at the organization level:

```
Organization:
  rundeck_base_url = "https://rundeck.mycompany.com"
  jenkins_base_url = "https://jenkins.mycompany.com"
```

This avoids repetition across products.

### 3. Use Descriptive Template Names

Choose names that clearly indicate what the template does:

✅ **Good:**
- "Deploy to Rundeck"
- "Trigger Jenkins Production Pipeline"
- "Open Deployment Dashboard"

❌ **Avoid:**
- "Template 1"
- "Deploy"
- "Button"

### 4. Keep Templates Simple

Simpler templates are easier to maintain and debug:

✅ **Good:**
```
{rundeck_base_url}/job/{rundeck_job_id}?version={vi_version}
```

❌ **Overly complex:**
```
{base_url}/api/v{api_version}/projects/{project_id}/environments/{env_id}/deployments/create?version={vi_version}&sha={vi_sha}&build={vi_build_number}&user={user_id}&timestamp={timestamp}
```

### 5. Document Your Variables

Keep track of what each variable represents, especially for IDs and UUIDs:

```
rundeck_job_id = "de5587ec-3a68-435f-be33-2d6fe99587c1"
# This is the "Deploy User Service to Dev" job in Rundeck
```

## Troubleshooting

### Button Not Appearing

**Problem:** Deployment button doesn't show up in UI or Slack.

**Solution:**
1. Verify template is enabled
2. Check that template is associated with the environment
3. Ensure all variables in template exist
4. Check for rendering errors in template preview

### Wrong URL Generated

**Problem:** Clicking button opens incorrect URL.

**Solution:**
1. Preview the template to see rendered URL
2. Verify variable values are correct
3. Check for typos in variable names
4. Ensure product-level variables aren't unintentionally overriding organization variables

### Missing Variable Error

**Problem:** Template preview shows "Missing variable: variable_name"

**Solution:**
1. Create the missing variable at organization or product level
2. Check for typos in variable name (case-sensitive)
3. Verify you're using correct variable scope

### Button Opens Wrong Tool

**Problem:** Button opens wrong deployment tool or environment.

**Solution:**
1. Check which template is associated with that environment
2. Verify template URL points to correct tool
3. Review variable values for that product

### Multiple Buttons for Same Environment

**Problem:** Multiple deployment buttons appear for the same environment.

**Solution:**
- Each environment can only be associated with one template per product
- If you see multiple buttons, check for templates from different products or misconfiguration

## Security Considerations

### URL Parameters

Deployment buttons construct URLs that may be visible in:
- Browser history
- Server logs
- Network traffic

**Recommendations:**
- Avoid including sensitive data in templates
- Use POST-based deployment tools when possible
- Ensure deployment tools have proper authentication

### Access Control

Deployment buttons provide **navigation**, not **authorization**:
- Users still need proper permissions in the deployment tool
- Buttons simply construct URLs—they don't bypass security
- Ensure your deployment tools have appropriate access controls

## Related Concepts

- **[Variables](variables.md)** - Configuration system powering deployment buttons
- **[Notifications](notifications.md)** - Slack notifications include deployment buttons
- **[Deployments](deployments.md)** - Track deployments triggered via buttons
- **[Environments](environments.md)** - Deployment buttons are scoped to environments

## Next Steps

- Set up [Variables](variables.md) for your deployment tools
- Configure [Notifications](notifications.md) to receive deployment buttons in Slack
- Learn about [Products](products.md) to understand product-level configuration
- Explore the [API Documentation](../api/index.md) for programmatic template management
