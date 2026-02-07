# Azure DevOps

## Auto-Detected Metadata

✅ **Repository** - From `BUILD_REPOSITORY_NAME`  
✅ **Git SHA** - From `BUILD_SOURCEVERSION`  
✅ **Git Branch** - From `BUILD_SOURCEBRANCHNAME`  
✅ **Build Number** - From `BUILD_BUILDNUMBER`  
✅ **Build URL** - From `BUILD_BUILDURI`  
✅ **User** - From `BUILD_REQUESTEDFOR`  
✅ **User Email** - From `BUILD_REQUESTEDFOREMAIL`  
✅ **Product Name** - Extracted from repository name (if not specified)  
✅ **Version** - Uses build number as fallback (if not specified)

## Installation

Add a step to download the CLI:

```yaml
- script: |
    curl -L https://github.com/versioner-io/versioner-cli/releases/latest/download/versioner-linux-amd64 -o /usr/local/bin/versioner
    chmod +x /usr/local/bin/versioner
  displayName: 'Download Versioner CLI'
```

## Track Build

```yaml
trigger:
  - main

pool:
  vmImage: 'ubuntu-latest'

steps:
  - script: |
      curl -L https://github.com/versioner-io/versioner-cli/releases/latest/download/versioner-linux-amd64 -o /usr/local/bin/versioner
      chmod +x /usr/local/bin/versioner
    displayName: 'Download Versioner CLI'
  
  - script: make build
    displayName: 'Build'
  
  - script: |
      versioner track build \
        --product=my-api \
        --status=completed
    displayName: 'Track Build'
    env:
      VERSIONER_API_KEY: $(VERSIONER_API_KEY)
```

## Track Deployment

```yaml
trigger:
  - main

pool:
  vmImage: 'ubuntu-latest'

steps:
  - script: |
      curl -L https://github.com/versioner-io/versioner-cli/releases/latest/download/versioner-linux-amd64 -o /usr/local/bin/versioner
      chmod +x /usr/local/bin/versioner
    displayName: 'Download Versioner CLI'
  
  - script: ./deploy.sh production
    displayName: 'Deploy'
  
  - script: |
      versioner track deployment \
        --product=my-api \
        --environment=production \
        --status=completed
    displayName: 'Track Deployment'
    env:
      VERSIONER_API_KEY: $(VERSIONER_API_KEY)
```

## Next Steps

- [CLI Usage Guide](../usage.md)
- [CI/CD Integration Overview](index.md)
