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
| `event-type` | Event type: `build` or `deployment` | `deployment` |
| `fail-on-api-error` | Fail workflow if Versioner API has connectivity/auth errors | `true` |
| `deployed-by` | User who triggered deployment | `${{ github.actor }}` |
| `scm-branch` | Git branch | `${{ github.ref_name }}` |
| `scm-sha` | Git commit SHA | `${{ github.sha }}` |
| `build-url` | Link to workflow run | Auto-generated |

**Note:** Deployment Rule violations always fail the workflow (exit codes 5, 423, 428). See [Deployment Rules](../concepts/deployment-rules.md) to understand and configure rules. Use report-only mode to test policies before enforcing.

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

### Best-Effort Observability

Allow deployments to proceed even if Versioner API is unavailable:

```yaml
- uses: versioner-io/versioner-github-action@v1
  with:
    api-key: ${{ secrets.VERSIONER_API_KEY }}
    product: my-service
    version: ${{ github.sha }}
    environment: production
    fail-on-api-error: false  # Don't block deployment if Versioner is down
```

**Important:** Deployment Rule violations will still fail the workflow. To test policies before enforcing, use report-only mode in the rule settings. See [Deployment Rules](../concepts/deployment-rules.md) for details.

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
# Staging
- uses: versioner-io/versioner-github-action@v1
  with:
    environment: staging

# Production
- uses: versioner-io/versioner-github-action@v1
  with:
    environment: production
```

or better yet...

```yaml
# Parameterized
- uses: versioner-io/versioner-github-action@v1
  with:
    environment: ${{ inputs.environment }}
```

## Troubleshooting

See the [Troubleshooting guide](troubleshooting.md) for help with common API errors including 401, 422, 423, and 428 responses.
