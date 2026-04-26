# Environment State Matrix

The **Environment State Matrix** is Versioner's core visibility feature. It shows you at a glance what version of each product is running in each environment.

!!! note "Free tier"
    The Environment State Matrix is included in all accounts, including during your 30-day trial.

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

The matrix automatically highlights rows where versions differ across your visible environments. If all visible cells in a row match, the row is not highlighted. If any differ, the row is highlighted — signaling that product is out of sync.

In the example above, `user-service`, `payment-api`, and `notification-service` would all be highlighted because they have different versions across environments. `web-frontend` would not be highlighted because staging and production both show `3.1.5` (development differs, but if development isn't a visible column, no highlight).

## Filtering and Navigation

The matrix is filterable by product and environment — useful when you have many services or only want to focus on a subset. Your filter state is preserved across sessions.

## Product Details

Click on any product name to open its detail page, where you can:

- View deployment and build history across all environments
- Configure deployment templates and variables for that product
- See which deployment rules are associated with it

## Related Concepts

- **[Products](../catalog/products.md)** - Deployable services shown as rows
- **[Environments](../catalog/environments.md)** - Deployment targets shown as columns
- **[Versions](../catalog/versions.md)** - Version numbers displayed in cells
- **[Deployments](../catalog/deployments.md)** - Deployment events populate the matrix
- **[Notifications](../configuration/notifications.md)** - Get alerted when matrix changes
