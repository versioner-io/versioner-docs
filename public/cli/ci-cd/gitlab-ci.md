# GitLab CI

## Auto-Detected Metadata

✅ **Repository** - From `CI_PROJECT_PATH` (e.g., `group/project`)  
✅ **Git SHA** - From `CI_COMMIT_SHA`  
✅ **Git Branch** - From `CI_COMMIT_REF_NAME`  
✅ **Build Number** - From `CI_PIPELINE_IID`  
✅ **Build URL** - From `CI_PIPELINE_URL`  
✅ **User** - From `GITLAB_USER_LOGIN`  
✅ **User Email** - From `GITLAB_USER_EMAIL`  
✅ **User Name** - From `GITLAB_USER_NAME`  
✅ **Product Name** - Extracted from project path (if not specified)  
✅ **Version** - Uses short SHA as fallback (if not specified)

## Installation

Add this to your `before_script`:

```yaml
before_script:
  - curl -L https://github.com/versioner-io/versioner-cli/releases/latest/download/versioner-linux-amd64 -o /usr/local/bin/versioner
  - chmod +x /usr/local/bin/versioner
```

## Track Build

```yaml
build:
  stage: build
  before_script:
    - curl -L https://github.com/versioner-io/versioner-cli/releases/latest/download/versioner-linux-amd64 -o /usr/local/bin/versioner
    - chmod +x /usr/local/bin/versioner
  script:
    - make build
  after_script:
    - versioner track build --product=my-api --status=completed
```

## Track Deployment

```yaml
deploy:
  stage: deploy
  before_script:
    - curl -L https://github.com/versioner-io/versioner-cli/releases/latest/download/versioner-linux-amd64 -o /usr/local/bin/versioner
    - chmod +x /usr/local/bin/versioner
  script:
    - ./deploy.sh
  after_script:
    - |
      versioner track deployment \
        --product=my-api \
        --environment=$CI_ENVIRONMENT_NAME \
        --status=completed
  environment:
    name: production
```

!!! tip "GitLab Environment Integration"
    Use `$CI_ENVIRONMENT_NAME` to automatically use the GitLab environment name.

## Next Steps

- [CLI Usage Guide](../usage.md)
- [CI/CD Integration Overview](index.md)
