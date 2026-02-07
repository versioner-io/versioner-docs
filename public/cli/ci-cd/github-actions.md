# GitHub Actions

!!! info "Native integration available"
    For a more streamlined experience, use the [Versioner GitHub Action](../../integrations/github-action.md) instead of the CLI.

## Auto-Detected Metadata

✅ **Repository** - From `GITHUB_REPOSITORY` (e.g., `owner/repo`)  
✅ **Git SHA** - From `GITHUB_SHA`  
✅ **Git Branch** - From `GITHUB_REF_NAME`  
✅ **Build Number** - From `GITHUB_RUN_NUMBER`  
✅ **Build URL** - Constructed from GitHub URLs  
✅ **User** - From `GITHUB_ACTOR`  
✅ **Product Name** - Extracted from repository name (if not specified)  
✅ **Version** - Uses short SHA as fallback (if not specified)

## Installation

Add this step to download the CLI:

```yaml
- name: Download Versioner CLI
  run: |
    curl -L https://github.com/versioner-io/versioner-cli/releases/latest/download/versioner-linux-amd64 -o /usr/local/bin/versioner
    chmod +x /usr/local/bin/versioner
```

## Track Build

```yaml
name: Build

on: [push]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Download Versioner CLI
        run: |
          curl -L https://github.com/versioner-io/versioner-cli/releases/latest/download/versioner-linux-amd64 -o /usr/local/bin/versioner
          chmod +x /usr/local/bin/versioner
      
      - name: Build
        run: make build
      
      - name: Track Build
        run: |
          versioner track build \
            --product=my-api \
            --status=completed
        env:
          VERSIONER_API_KEY: ${{ secrets.VERSIONER_API_KEY }}
```

## Track Deployment

```yaml
name: Deploy

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Download Versioner CLI
        run: |
          curl -L https://github.com/versioner-io/versioner-cli/releases/latest/download/versioner-linux-amd64 -o /usr/local/bin/versioner
          chmod +x /usr/local/bin/versioner
      
      - name: Deploy to Production
        run: ./deploy.sh production
      
      - name: Track Deployment
        run: |
          versioner track deployment \
            --product=my-api \
            --environment=production \
            --version=${{ github.sha }} \
            --status=completed
        env:
          VERSIONER_API_KEY: ${{ secrets.VERSIONER_API_KEY }}
```

## What You Need to Specify

- `--product` (required)
- `--environment` (for deployments)
- Everything else is auto-detected!

## Next Steps

- [CLI Usage Guide](../usage.md)
- [CI/CD Integration Overview](index.md)
