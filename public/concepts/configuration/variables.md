# Variables

Variables let you define values once and reference them in [Deployment Button](deployment-buttons.md) URL templates. They keep templates clean and avoid repeating common values like tool base URLs or job IDs across products.

## Scopes

Variables can be defined at two levels:

**Organization** — shared across all products. Use for tool base URLs and other org-wide config.

```
github_org = "mycompany"
jenkins_host = "https://jenkins.mycompany.com"
```

**Product** — specific to one product. Use for product-specific identifiers like repo names or job names.

```
github_repo = "user-service"
jenkins_job_name = "deploy-user-service"
```

When the same key exists at both levels, the product-level value wins.

## System Variables

Versioner automatically injects the following variables at render time. The `vi_*` prefix is reserved — you cannot create variables with it.

| Variable | Description | Example |
|----------|-------------|---------|
| `vi_version` | Version number | `1.2.3` |
| `vi_build_number` | Build number | `42` |
| `vi_product_id` | Product UUID | `550e8400-...` |
| `vi_product_name` | Product name | `user-service` |
| `vi_environment_id` | Environment UUID | `660e8400-...` |
| `vi_environment_name` | Environment name | `production` |
| `vi_sha` | Git commit SHA | `abc123def456` |

## Naming

Variable names must be lowercase letters, numbers, and underscores only — no spaces, hyphens, or dots.

✅ `github_org`, `jenkins_job_name`, `api_endpoint_prod`

❌ `GitHub-Org`, `jenkins job`, `api.endpoint`, `vi_custom_var`

## Managing Variables

**Organization variables:** Settings → Organization → Variables

**Product variables:** Manage → Products → [Product] → Variables

Both support add, edit, and delete. Variables can also be managed via the [API](../../api/index.md).

!!! warning "Sensitive data"
    Variables are stored in plain text. Do not store passwords or API tokens.

!!! danger "Before deleting"
    Check that the variable isn't referenced in any templates — deleting it will cause those templates to fail rendering.

## Troubleshooting

**"Missing variable: variable_name"** — the template references a variable that doesn't exist at the org or product level. Check for typos and verify the variable is defined at the right scope.

**Unexpected value in rendered URL** — a product-level variable is likely overriding an org-level one with the same key. Check both scopes.

**Can't create variable** — name must be lowercase with underscores only, no `vi_*` prefix, and the key must not already exist at that scope.

## Related

- [Deployment Buttons](deployment-buttons.md) — how variables are used in templates
- [Products](../catalog/products.md) — product-level variable scoping
- [Environments](../catalog/environments.md) — system variables include environment context
