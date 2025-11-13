# Variables

Variables are reusable configuration values that can be referenced throughout Versioner to create dynamic templates and integrations.

## Overview

Variables allow you to define values once and reuse them across multiple features. They're particularly useful for:

- Creating deployment button URLs with dynamic parameters
- Configuring integrations with external tools
- Avoiding repetition of common values (URLs, tokens, identifiers)

Variables are designed to be **generic and reusable** - while they're currently used for deployment buttons, they can power future features like email templates, webhooks, and custom integrations.

## Variable Scopes

Variables can be defined at two levels:

### Organization-Level Variables

**Shared across all products** in your organization.

**Use for:**
- Base URLs for shared tools (Rundeck, Jenkins, etc.)
- Organization-wide configuration
- Common identifiers

**Example:**
```
rundeck_base_url = "https://rundeck.mycompany.com"
jenkins_host = "https://jenkins.mycompany.com"
```

### Product-Level Variables

**Specific to a single product.**

**Use for:**
- Product-specific identifiers (job IDs, project names)
- Product-specific configuration
- Values that differ per product

**Example (for product "user-service"):**
```
rundeck_job_id = "de5587ec-3a68-435f-be33-2d6fe99587c1"
jenkins_job_name = "deploy-user-service"
```

## Variable Precedence

When a variable exists at both levels, **product-level variables override organization-level variables**.

**Example:**

```
Organization level:
  api_timeout = "30"

Product level (user-service):
  api_timeout = "60"

Result for user-service: api_timeout = "60"
Result for other products: api_timeout = "30"
```

This allows you to set sensible defaults at the organization level and override them for specific products when needed.

## Naming Conventions

Variable names must follow these rules:

- **Lowercase letters, numbers, and underscores only**
- **No spaces or special characters**
- **Descriptive and readable**

✅ **Good names:**
```
rundeck_base_url
jenkins_job_id
deployment_timeout
api_endpoint_prod
```

❌ **Invalid names:**
```
Rundeck-URL          # No uppercase or hyphens
jenkins job          # No spaces
api.endpoint         # No dots
vi_custom_var        # vi_* prefix is reserved
```

## System Variables

Versioner automatically provides **system variables** that are injected at runtime. These variables are **reserved** and use the `vi_*` prefix.

### Available System Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `vi_version` | Version number | `1.2.3` |
| `vi_build_number` | Build number | `42` |
| `vi_product_id` | Product UUID | `550e8400-e29b-41d4-a716-446655440000` |
| `vi_product_name` | Product name | `user-service` |
| `vi_environment_id` | Environment UUID | `660e8400-e29b-41d4-a716-446655440001` |
| `vi_environment_name` | Environment name | `production` |
| `vi_sha` | Git commit SHA | `abc123def456` |

**You cannot create variables with the `vi_*` prefix** - these are automatically provided by Versioner based on the context.

### Using System Variables

System variables are particularly useful in templates where you need dynamic values:

```
{rundeck_base_url}/job/{rundeck_job_id}?version={vi_version}
```

When this template is rendered for version `1.2.3`, it becomes:
```
https://rundeck.mycompany.com/job/abc-123?version=1.2.3
```

## Managing Variables

### Creating Variables

Variables can be created through the Versioner UI:

**Organization Variables:**
1. Go to **Settings → Organization → Variables**
2. Click **Add Variable**
3. Enter key and value
4. Save

**Product Variables:**
1. Go to **Manage → Products → [Your Product] → Variables**
2. Click **Add Variable**
3. Enter key and value
4. Save

!!! tip "API Access"
    Variables can also be managed via the API. See the [API Documentation](../api/index.md) for details.

### Editing Variables

1. Navigate to the variables page (organization or product level)
2. Click **Edit** next to the variable
3. Update the value
4. Save

!!! warning "Impact of Changes"
    Changing a variable value will affect all templates and features that reference it. Test changes in non-production environments first.

### Deleting Variables

1. Navigate to the variables page
2. Click **Delete** next to the variable
3. Confirm deletion

!!! danger "Check Usage First"
    Before deleting a variable, verify it's not being used in any templates. Deleting a variable that's in use will cause those templates to fail rendering.

## Common Patterns

### Shared Tool Configuration

Define tool base URLs at the organization level:

```
Organization variables:
  rundeck_base_url = "https://rundeck.mycompany.com"
  jenkins_base_url = "https://jenkins.mycompany.com"
  datadog_base_url = "https://app.datadoghq.com"
```

Then reference them in product-specific templates without repeating the URLs.

### Environment-Specific Configuration

Use product variables to define environment-specific values:

```
Product variables (user-service):
  rundeck_job_id_dev = "abc-123"
  rundeck_job_id_staging = "def-456"
  rundeck_job_id_prod = "ghi-789"
```

### Multi-Stage Pipelines

Define pipeline stages and their configurations:

```
Organization variables:
  pipeline_base_url = "https://pipeline.mycompany.com"

Product variables (user-service):
  pipeline_id = "user-service-deploy"
  pipeline_stage_dev = "development"
  pipeline_stage_prod = "production"
```

## Best Practices

### 1. Use Descriptive Names

Choose names that clearly indicate what the variable contains:

✅ **Good:**
```
rundeck_job_id
jenkins_deploy_url
slack_webhook_deployments
```

❌ **Avoid:**
```
url1
id
config
```

### 2. Organize by Tool or Purpose

Group related variables with consistent prefixes:

```
rundeck_base_url
rundeck_project_name
rundeck_job_id

jenkins_base_url
jenkins_job_name
jenkins_token
```

### 3. Set Defaults at Organization Level

Define common values at the organization level and only override when necessary:

```
Organization:
  deployment_timeout = "300"

Product (critical-service):
  deployment_timeout = "600"  # Override for critical service
```

### 4. Document Complex Values

For non-obvious values, consider adding context in your internal documentation:

```
# rundeck_job_id = "de5587ec-3a68-435f-be33-2d6fe99587c1"
# This is the UUID for the "Deploy User Service" job in Rundeck
```

### 5. Avoid Sensitive Data

!!! warning "Security"
    Variables are currently stored in plain text. Avoid storing sensitive data like passwords or API tokens. Support for secure variables is planned for a future release.

## Troubleshooting

### Variable Not Found

**Problem:** Template rendering fails with "Missing variable: variable_name"

**Solution:**
1. Verify the variable exists at the organization or product level
2. Check for typos in the variable name
3. Ensure you're looking at the correct product's variables

### Wrong Value Being Used

**Problem:** Variable has unexpected value in rendered output

**Solution:**
1. Check if a product-level variable is overriding an organization-level variable
2. Verify you're viewing the correct scope (organization vs product)
3. Clear browser cache if viewing in UI

### Cannot Create Variable

**Problem:** Error when creating a variable

**Solution:**
1. Verify the variable name follows naming conventions (lowercase, underscores only)
2. Check that you're not using the reserved `vi_*` prefix
3. Ensure a variable with the same name doesn't already exist at that scope

## Use Cases

Variables are currently used by:

- **[Deployment Buttons](deployment-buttons.md)** - Create dynamic URLs to deployment tools

Future features that will use variables:

- **Email Templates** - Personalize notification emails
- **Webhooks** - Configure custom webhook URLs and payloads
- **Custom Integrations** - Connect to third-party tools

## Related Concepts

- **[Deployment Buttons](deployment-buttons.md)** - Use variables to create deployment URLs
- **[Products](products.md)** - Product-level variables are scoped to products
- **[Environments](environments.md)** - System variables include environment information

## Next Steps

- Learn how to use variables in [Deployment Buttons](deployment-buttons.md)
- Explore [Products](products.md) to understand product-level scoping
- Check the [API Documentation](../api/index.md) for programmatic variable management
