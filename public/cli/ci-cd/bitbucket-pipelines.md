# Bitbucket Pipelines

## Auto-Detected Metadata

✅ **Repository** - From `BITBUCKET_REPO_FULL_NAME`  
✅ **Git SHA** - From `BITBUCKET_COMMIT`  
✅ **Git Branch** - From `BITBUCKET_BRANCH` or `BITBUCKET_TAG`  
✅ **Build Number** - From `BITBUCKET_BUILD_NUMBER`  
✅ **Build URL** - Constructed from Bitbucket URLs  
❌ **User** - Not available  
✅ **Product Name** - From `BITBUCKET_REPO_SLUG` (if not specified)  
✅ **Version** - Uses short SHA as fallback (if not specified)

!!! warning "User Information Not Available"
    Bitbucket Pipelines doesn't expose user information. Specify `--built-by` or `--deployed-by` manually if needed.

## Installation

Add the CLI download to your script:

```yaml
- curl -L https://github.com/versioner-io/versioner-cli/releases/latest/download/versioner-linux-amd64 -o /usr/local/bin/versioner
- chmod +x /usr/local/bin/versioner
```

## Track Build

```yaml
pipelines:
  default:
    - step:
        name: Build
        script:
          - curl -L https://github.com/versioner-io/versioner-cli/releases/latest/download/versioner-linux-amd64 -o /usr/local/bin/versioner
          - chmod +x /usr/local/bin/versioner
          - make build
          - versioner track build --product=my-api --status=completed
```

## Track Deployment

```yaml
pipelines:
  branches:
    main:
      - step:
          name: Deploy to Production
          deployment: production
          script:
            - curl -L https://github.com/versioner-io/versioner-cli/releases/latest/download/versioner-linux-amd64 -o /usr/local/bin/versioner
            - chmod +x /usr/local/bin/versioner
            - ./deploy.sh production
            - |
              versioner track deployment \
                --product=my-api \
                --environment=production \
                --status=completed
```

## Next Steps

- [CLI Usage Guide](../usage.md)
- [CI/CD Integration Overview](index.md)
