# CircleCI

## Auto-Detected Metadata

✅ **Repository** - From `CIRCLE_PROJECT_USERNAME` and `CIRCLE_PROJECT_REPONAME`  
✅ **Git SHA** - From `CIRCLE_SHA1`  
✅ **Git Branch** - From `CIRCLE_BRANCH` or `CIRCLE_TAG`  
✅ **Build Number** - From `CIRCLE_BUILD_NUM`  
✅ **Build URL** - From `CIRCLE_BUILD_URL`  
✅ **User** - From `CIRCLE_USERNAME`  
✅ **Product Name** - Extracted from repository name (if not specified)  
✅ **Version** - Uses short SHA as fallback (if not specified)

## Installation

Add a step to download the CLI:

```yaml
- run:
    name: Download Versioner CLI
    command: |
      curl -L https://github.com/versioner-io/versioner-cli/releases/latest/download/versioner-linux-amd64 -o ~/bin/versioner
      chmod +x ~/bin/versioner
```

## Track Build

```yaml
version: 2.1

jobs:
  build:
    docker:
      - image: cimg/base:stable
    steps:
      - checkout
      - run:
          name: Download Versioner CLI
          command: |
            curl -L https://github.com/versioner-io/versioner-cli/releases/latest/download/versioner-linux-amd64 -o ~/bin/versioner
            chmod +x ~/bin/versioner
      - run:
          name: Build
          command: make build
      - run:
          name: Track Build
          command: |
            ~/bin/versioner track build \
              --product=my-api \
              --status=completed
```

## Track Deployment

```yaml
version: 2.1

jobs:
  deploy:
    docker:
      - image: cimg/base:stable
    steps:
      - checkout
      - run:
          name: Download Versioner CLI
          command: |
            curl -L https://github.com/versioner-io/versioner-cli/releases/latest/download/versioner-linux-amd64 -o ~/bin/versioner
            chmod +x ~/bin/versioner
      - run:
          name: Deploy
          command: ./deploy.sh production
      - run:
          name: Track Deployment
          command: |
            ~/bin/versioner track deployment \
              --product=my-api \
              --environment=production \
              --status=completed
```

## Next Steps

- [CLI Usage Guide](../usage.md)
- [CI/CD Integration Overview](index.md)
