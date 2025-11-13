# CLI Integration with CI/CD Systems

The Versioner CLI automatically detects your CI/CD environment and extracts relevant metadata, reducing the number of flags you need to specify.

## Supported Systems

The CLI supports auto-detection for 8 CI/CD systems:

- [GitHub Actions](#github-actions)
- [GitLab CI](#gitlab-ci)
- [Jenkins](#jenkins)
- [CircleCI](#circleci)
- [Bitbucket Pipelines](#bitbucket-pipelines)
- [Azure DevOps](#azure-devops)
- [Travis CI](#travis-ci)
- [Rundeck](#rundeck)

## How Auto-Detection Works

When you run the CLI in a supported CI/CD system:

1. **System Detection** - CLI checks environment variables to identify the system
2. **Metadata Extraction** - Automatically populates fields like repository, SHA, build number, user
3. **Override Support** - You can always override auto-detected values with flags

!!! tip "Installing the CLI"
    All examples below include CLI download steps. The CLI is a single binary with no dependencies:
    
    **Latest version:**
    ```bash
    curl -L https://github.com/versioner-io/versioner-cli/releases/latest/download/versioner-linux-amd64 -o /usr/local/bin/versioner
    chmod +x /usr/local/bin/versioner
    ```
    
    **Specific version (recommended for production):**
    ```bash
    VERSION=v1.0.3
    curl -L https://github.com/versioner-io/versioner-cli/releases/download/${VERSION}/versioner-linux-amd64 -o /usr/local/bin/versioner
    chmod +x /usr/local/bin/versioner
    ```
    
    See [CLI Installation](index.md#installation) for all platforms and installation methods.

!!! tip "Verbose Mode"
    Use `--verbose` to see which values were auto-detected:
    ```bash
    versioner track build --product=api --status=completed --verbose
    ```

---

## GitHub Actions

!!! info "Custom Action available"
    Use the [versioner-github-action](https://github.com/versioner-io/versioner-github-action) for a more streamlined experience.

### What's Auto-Detected

✅ **Repository** - From `GITHUB_REPOSITORY` (e.g., `owner/repo`)  
✅ **Git SHA** - From `GITHUB_SHA`  
✅ **Git Branch** - From `GITHUB_REF_NAME`  
✅ **Build Number** - From `GITHUB_RUN_NUMBER`  
✅ **Build URL** - Constructed from GitHub URLs  
✅ **User** - From `GITHUB_ACTOR`  
✅ **Product Name** - Extracted from repository name (if not specified)  
✅ **Version** - Uses short SHA as fallback (if not specified)

### Example: Track Build

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

### Example: Track Deployment

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
            --status=success
        env:
          VERSIONER_API_KEY: ${{ secrets.VERSIONER_API_KEY }}
```

!!! note "What You Need to Specify"
    - `--product` (required)
    - `--environment` (for deployments)
    - Everything else is auto-detected!

---

## GitLab CI

### What's Auto-Detected

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

### Example: Track Build

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

### Example: Track Deployment

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
        --status=success
  environment:
    name: production
```

!!! tip "GitLab Environment Integration"
    Use `$CI_ENVIRONMENT_NAME` to automatically use the GitLab environment name.

---

## Jenkins

### What's Auto-Detected

✅ **Repository** - From `GIT_URL` (normalized)  
✅ **Git SHA** - From `GIT_COMMIT`  
✅ **Git Branch** - From `GIT_BRANCH`  
✅ **Build Number** - From `BUILD_NUMBER`  
✅ **Build URL** - From `BUILD_URL`  
⚠️ **User** - From `BUILD_USER` (requires [Build User Vars Plugin](https://plugins.jenkins.io/build-user-vars-plugin/))  
⚠️ **User Email** - From `BUILD_USER_EMAIL` (requires plugin)  
✅ **Product Name** - Extracted from repository URL (if not specified)  
✅ **Version** - Uses build number as fallback (if not specified)

### Example: Track Build

```groovy
pipeline {
    agent any
    
    stages {
        stage('Setup') {
            steps {
                sh '''
                    curl -L https://github.com/versioner-io/versioner-cli/releases/latest/download/versioner-linux-amd64 -o /usr/local/bin/versioner
                    chmod +x /usr/local/bin/versioner
                '''
            }
        }
        
        stage('Build') {
            steps {
                sh 'make build'
                sh '''
                    versioner track build \
                      --product=my-api \
                      --status=completed
                '''
            }
        }
    }
}
```

### Example: Track Deployment

```groovy
pipeline {
    agent any
    
    stages {
        stage('Setup') {
            steps {
                sh '''
                    curl -L https://github.com/versioner-io/versioner-cli/releases/latest/download/versioner-linux-amd64 -o /usr/local/bin/versioner
                    chmod +x /usr/local/bin/versioner
                '''
            }
        }
        
        stage('Deploy') {
            steps {
                sh './deploy.sh production'
                sh '''
                    versioner track deployment \
                      --product=my-api \
                      --environment=production \
                      --version=${BUILD_NUMBER} \
                      --status=success
                '''
            }
        }
    }
    
    post {
        failure {
            sh '''
                versioner track deployment \
                  --product=my-api \
                  --environment=production \
                  --version=${BUILD_NUMBER} \
                  --status=failed
            '''
        }
    }
}
```

!!! warning "User Information Requires Plugin"
    To auto-detect the user who triggered the build, install the [Build User Vars Plugin](https://plugins.jenkins.io/build-user-vars-plugin/). Without it, you'll need to specify `--built-by` or `--deployed-by` manually.

---

## CircleCI

### What's Auto-Detected

✅ **Repository** - From `CIRCLE_PROJECT_USERNAME` and `CIRCLE_PROJECT_REPONAME`  
✅ **Git SHA** - From `CIRCLE_SHA1`  
✅ **Git Branch** - From `CIRCLE_BRANCH` or `CIRCLE_TAG`  
✅ **Build Number** - From `CIRCLE_BUILD_NUM`  
✅ **Build URL** - From `CIRCLE_BUILD_URL`  
✅ **User** - From `CIRCLE_USERNAME`  
✅ **Product Name** - Extracted from repository name (if not specified)  
✅ **Version** - Uses short SHA as fallback (if not specified)

### Example: Track Build

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

### Example: Track Deployment

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
              --status=success
```

---

## Bitbucket Pipelines

### What's Auto-Detected

✅ **Repository** - From `BITBUCKET_REPO_FULL_NAME`  
✅ **Git SHA** - From `BITBUCKET_COMMIT`  
✅ **Git Branch** - From `BITBUCKET_BRANCH` or `BITBUCKET_TAG`  
✅ **Build Number** - From `BITBUCKET_BUILD_NUMBER`  
✅ **Build URL** - Constructed from Bitbucket URLs  
❌ **User** - Not available  
✅ **Product Name** - From `BITBUCKET_REPO_SLUG` (if not specified)  
✅ **Version** - Uses short SHA as fallback (if not specified)

### Example: Track Build

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

### Example: Track Deployment

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
                --status=success
```

!!! warning "User Information Not Available"
    Bitbucket Pipelines doesn't expose user information. Specify `--built-by` or `--deployed-by` manually if needed.

---

## Azure DevOps

### What's Auto-Detected

✅ **Repository** - From `BUILD_REPOSITORY_NAME`  
✅ **Git SHA** - From `BUILD_SOURCEVERSION`  
✅ **Git Branch** - From `BUILD_SOURCEBRANCHNAME`  
✅ **Build Number** - From `BUILD_BUILDNUMBER`  
✅ **Build URL** - From `BUILD_BUILDURI`  
✅ **User** - From `BUILD_REQUESTEDFOR`  
✅ **User Email** - From `BUILD_REQUESTEDFOREMAIL`  
✅ **Product Name** - Extracted from repository name (if not specified)  
✅ **Version** - Uses build number as fallback (if not specified)

### Example: Track Build

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

### Example: Track Deployment

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
        --status=success
    displayName: 'Track Deployment'
    env:
      VERSIONER_API_KEY: $(VERSIONER_API_KEY)
```

---

## Travis CI

### What's Auto-Detected

✅ **Repository** - From `TRAVIS_REPO_SLUG`  
✅ **Git SHA** - From `TRAVIS_COMMIT`  
✅ **Git Branch** - From `TRAVIS_BRANCH` or `TRAVIS_TAG`  
✅ **Build Number** - From `TRAVIS_BUILD_NUMBER`  
✅ **Build URL** - From `TRAVIS_BUILD_WEB_URL`  
❌ **User** - Not available  
✅ **Product Name** - Extracted from repository slug (if not specified)  
✅ **Version** - Uses short SHA as fallback (if not specified)

### Example: Track Build

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

### Example: Track Deployment

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
      --status=success
```

!!! warning "User Information Not Available"
    Travis CI doesn't expose user information. Specify `--built-by` or `--deployed-by` manually if needed.

---

## Rundeck

### What's Auto-Detected

✅ **Build Number** - From `RD_JOB_EXECID`  
✅ **Build URL** - Constructed from `RD_JOB_SERVERURL`, `RD_JOB_PROJECT`, and `RD_JOB_EXECID`  
✅ **User** - From `RD_JOB_USERNAME` or `RD_JOB_USER_NAME`  
✅ **Product Name** - From `RD_JOB_NAME` (if not specified)  
✅ **Version** - Uses execution ID as fallback (if not specified)  
❌ **Git Repository** - Not available  
❌ **Git SHA** - Not available  
❌ **Git Branch** - Not available

### What You Need to Provide

Since Rundeck doesn't provide Git/SCM information by default, you should pass these as **job options** or **flags**:

- `--scm-sha` - Git commit SHA
- `--scm-repository` - Repository name
- `--scm-branch` - Git branch
- `--version` - Semantic version (if not using execution ID)

### Example: Track Build with Git Info

Create a Rundeck job with these options:
- `git_sha` - Git commit SHA
- `version` - Version being built
- `versioner_api_key` - API key (secure option)

```bash
#!/bin/bash
# Rundeck job step (inline script)

# Download Versioner CLI (if not already installed)
if [ ! -f /usr/local/bin/versioner ]; then
  curl -L https://github.com/versioner-io/versioner-cli/releases/latest/download/versioner-linux-amd64 -o /usr/local/bin/versioner
  chmod +x /usr/local/bin/versioner
fi

# Export API key from secure job option
export VERSIONER_API_KEY=${option.versioner_api_key}

# Track build with Git info passed via job options
versioner track build \
  --product=my-api \
  --version=${option.version} \
  --scm-sha=${option.git_sha} \
  --status=completed
```

### Example: Track Deployment

Create a Rundeck deployment job with these options:
- `environment` - Target environment (production, staging, etc.)
- `version` - Version being deployed
- `git_sha` - Git commit SHA
- `versioner_api_key` - API key (secure option)

```bash
#!/bin/bash
# Rundeck deployment job step

# Download Versioner CLI (if not already installed)
if [ ! -f /usr/local/bin/versioner ]; then
  curl -L https://github.com/versioner-io/versioner-cli/releases/latest/download/versioner-linux-amd64 -o /usr/local/bin/versioner
  chmod +x /usr/local/bin/versioner
fi

export VERSIONER_API_KEY=${option.versioner_api_key}

# Run deployment
./deploy.sh ${option.environment}

# Track deployment with full context
versioner track deployment \
  --product=my-api \
  --environment=${option.environment} \
  --version=${option.version} \
  --scm-sha=${option.git_sha} \
  --status=success
```

### Example: Minimal Rundeck Integration

If you don't have Git info available, you can still track deployments:

```bash
#!/bin/bash
# Minimal Rundeck integration - uses auto-detected values

# Download Versioner CLI (if not already installed)
if [ ! -f /usr/local/bin/versioner ]; then
  curl -L https://github.com/versioner-io/versioner-cli/releases/latest/download/versioner-linux-amd64 -o /usr/local/bin/versioner
  chmod +x /usr/local/bin/versioner
fi

export VERSIONER_API_KEY=${option.versioner_api_key}

./deploy.sh ${option.environment}

# CLI auto-detects: job name, execution ID, user, build URL
versioner track deployment \
  --environment=${option.environment} \
  --status=success
```

!!! tip "Rundeck Job Options"
    Use Rundeck's job options to pass Git information:
    
    1. Create options: `git_sha`, `git_branch`, `version`
    2. Pass them to the CLI via `${option.name}` syntax
    3. Mark `versioner_api_key` as a **secure** option

!!! warning "Git Information Required for Full Tracking"
    Without Git SHA and version, Versioner will use the Rundeck execution ID as the version. This works but doesn't link to your source code. For best results, pass Git info via job options.

---

## Configuration Priority

When the CLI determines field values, it uses this priority order:

1. **CLI Flags** (highest priority) - `--version=1.2.3`
2. **Environment Variables** - `VERSIONER_VERSION=1.2.3`
3. **CI/CD Auto-Detection** - Extracted from CI system
4. **Defaults** (lowest priority)

### Example: Override Auto-Detection

```bash
# Auto-detected SHA is abc123, but you want to use a different version
versioner track build \
  --product=my-api \
  --version=1.2.3 \
  --status=completed
# Uses version "1.2.3" instead of auto-detected SHA
```

---

## Next Steps

- [Command Reference](commands.md) - Complete command reference
- [Configuration](configuration.md) - Advanced configuration options
- [GitHub Action](../integrations/github-action.md) - Use the GitHub Action instead of CLI
- [API Documentation](../api/index.md) - Direct API integration
