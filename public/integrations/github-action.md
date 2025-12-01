# GitHub Actions Integration

Integrate Versioner into your GitHub Actions workflows to automatically track deployments and builds.


## Installation

Add the Versioner action to your workflow:

```yaml
- uses: versioner-io/versioner-github-action@v1
  with:
    api-key: ${{ secrets.VERSIONER_API_KEY }}
    product: my-service
    version: ${{ github.sha }}
    environment: production
    status: success
```

## Configuration

### Required Inputs

| Input | Description | Example |
|-------|-------------|---------|
| `api-key` | Your Versioner API key | `${{ secrets.VERSIONER_API_KEY }}` |
| `product` | Product/service name | `my-service` |
| `version` | Version being deployed | `${{ github.sha }}` or `1.2.3` |
| `environment` | Target environment | `production`, `staging`, `dev` |

### Optional Inputs

| Input | Description | Default |
|-------|-------------|---------|
| `status` | Deployment status | `success` |
| `deployed-by` | User who triggered deployment | `${{ github.actor }}` |
| `scm-branch` | Git branch | `${{ github.ref_name }}` |
| `scm-sha` | Git commit SHA | `${{ github.sha }}` |
| `build-url` | Link to workflow run | Auto-generated |

## Examples

### Basic Deployment Tracking

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

      - name: Deploy
        run: ./deploy.sh

      - uses: versioner-io/versioner-github-action@v1
        with:
          api-key: ${{ secrets.VERSIONER_API_KEY }}
          product: my-service
          version: ${{ github.sha }}
          environment: production
          status: success
```

### Track Build and Deployment

```yaml
name: Build and Deploy

on:
  push:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      # Track build start
      - uses: versioner-io/versioner-github-action@v1
        with:
          api-key: ${{ secrets.VERSIONER_API_KEY }}
          product: my-service
          version: ${{ github.sha }}
          event-type: build
          status: started

      - name: Build
        run: npm run build

      # Track build completion
      - uses: versioner-io/versioner-github-action@v1
        if: success()
        with:
          api-key: ${{ secrets.VERSIONER_API_KEY }}
          product: my-service
          version: ${{ github.sha }}
          event-type: build
          status: completed

  deploy:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - name: Deploy
        run: ./deploy.sh

      - uses: versioner-io/versioner-github-action@v1
        with:
          api-key: ${{ secrets.VERSIONER_API_KEY }}
          product: my-service
          version: ${{ github.sha }}
          environment: production
          status: success
```

### Handle Failures

```yaml
- name: Deploy
  id: deploy
  run: ./deploy.sh

- uses: versioner-io/versioner-github-action@v1
  if: always()
  with:
    api-key: ${{ secrets.VERSIONER_API_KEY }}
    product: my-service
    version: ${{ github.sha }}
    environment: production
    status: ${{ steps.deploy.outcome }}
```

## Best Practices

### 1. Store API Key as Secret

Never hardcode your API key. Always use GitHub Secrets:

1. Go to `Settings → Secrets and variables → Actions`
2. Click `New repository secret`
3. Name: `VERSIONER_API_KEY`
4. Value: Your API key

### 2. Use Semantic Versioning

For releases, use semantic versions instead of commit SHAs:

```yaml
- name: Get version
  id: version
  run: echo "version=$(cat VERSION)" >> $GITHUB_OUTPUT

- uses: versioner-io/versioner-github-action@v1
  with:
    version: ${{ steps.version.outputs.version }}
```

### 3. Track All Environments

Track deployments to all environments, not just production:

```yaml
# Development
- uses: versioner-io/versioner-github-action@v1
  with:
    environment: dev

# Staging
- uses: versioner-io/versioner-github-action@v1
  with:
    environment: staging

# Production
- uses: versioner-io/versioner-github-action@v1
  with:
    environment: production
```

## Troubleshooting

### Action Fails with "401 Unauthorized"

**Problem:** API key is invalid or not set.

**Solution:**
- Verify `VERSIONER_API_KEY` is set in GitHub Secrets
- Check the secret name matches your workflow
- Ensure the API key is valid

### Action Fails with "422 Validation Error"

**Problem:** Required fields are missing or invalid.

**Solution:**
- Ensure `product`, `version`, and `environment` are provided
- Check field values are valid strings
- Review the [Event Tracking API](../api/event-tracking.md) for validation rules

## Next Steps

- Learn about [Event Types](../api/event-types.md)
- Set up [Notifications](../concepts/notifications.md)
- Explore the [Event Tracking API](../api/event-tracking.md)
