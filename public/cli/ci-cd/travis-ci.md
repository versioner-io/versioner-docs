# Travis CI

## Auto-Detected Metadata

✅ **Repository** - From `TRAVIS_REPO_SLUG`  
✅ **Git SHA** - From `TRAVIS_COMMIT`  
✅ **Git Branch** - From `TRAVIS_BRANCH` or `TRAVIS_TAG`  
✅ **Build Number** - From `TRAVIS_BUILD_NUMBER`  
✅ **Build URL** - From `TRAVIS_BUILD_WEB_URL`  
❌ **User** - Not available  
✅ **Product Name** - Extracted from repository slug (if not specified)  
✅ **Version** - Uses short SHA as fallback (if not specified)

!!! warning "User Information Not Available"
    Travis CI doesn't expose user information. Specify `--built-by` or `--deployed-by` manually if needed.

## Installation

Add the CLI download to your `before_script`:

```yaml
before_script:
  - curl -L https://github.com/versioner-io/versioner-cli/releases/latest/download/versioner-linux-amd64 -o $HOME/bin/versioner
  - chmod +x $HOME/bin/versioner
  - export PATH=$HOME/bin:$PATH
```

## Track Build

```yaml
language: node_js
node_js:
  - 18

before_script:
  - curl -L https://github.com/versioner-io/versioner-cli/releases/latest/download/versioner-linux-amd64 -o $HOME/bin/versioner
  - chmod +x $HOME/bin/versioner
  - export PATH=$HOME/bin:$PATH

script:
  - make build

after_success:
  - versioner track build --product=my-api --status=completed
```

## Track Deployment

```yaml
language: node_js
node_js:
  - 18

before_script:
  - curl -L https://github.com/versioner-io/versioner-cli/releases/latest/download/versioner-linux-amd64 -o $HOME/bin/versioner
  - chmod +x $HOME/bin/versioner
  - export PATH=$HOME/bin:$PATH

script:
  - make build

deploy:
  provider: script
  script: ./deploy.sh production
  on:
    branch: main

after_deploy:
  - |
    versioner track deployment \
      --product=my-api \
      --environment=production \
      --status=completed
```

## Next Steps

- [CLI Usage Guide](../usage.md)
- [CI/CD Integration Overview](index.md)
