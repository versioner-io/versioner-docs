# Rundeck

## Auto-Detected Metadata

✅ **Build Number** - From `RD_JOB_EXECID`  
✅ **Build URL** - Constructed from `RD_JOB_SERVERURL`, `RD_JOB_PROJECT`, and `RD_JOB_EXECID`  
✅ **User** - From `RD_JOB_USERNAME` or `RD_JOB_USER_NAME`  
✅ **Product Name** - From `RD_JOB_NAME` (if not specified)  
✅ **Version** - Uses execution ID as fallback (if not specified)  
❌ **Git Repository** - Not available  
❌ **Git SHA** - Not available  
❌ **Git Branch** - Not available

## What You Need to Provide

Since Rundeck doesn't provide Git/SCM information by default, you should pass these as **job options**:

- `--scm-sha` - Git commit SHA
- `--scm-repository` - Repository name
- `--scm-branch` - Git branch
- `--version` - Semantic version (if not using execution ID)

## Installation

Add this to your job script to download the CLI if not already installed:

```bash
if [ ! -f /usr/local/bin/versioner ]; then
  curl -L https://github.com/versioner-io/versioner-cli/releases/latest/download/versioner-linux-amd64 -o /usr/local/bin/versioner
  chmod +x /usr/local/bin/versioner
fi
```

## Track Build with Git Info

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

## Track Deployment

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
  --status=completed
```

## Minimal Integration

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
  --status=completed
```

!!! tip "Rundeck Job Options"
    Use Rundeck's job options to pass Git information:
    
    1. Create options: `git_sha`, `git_branch`, `version`
    2. Pass them to the CLI via `${option.name}` syntax
    3. Mark `versioner_api_key` as a **secure** option

!!! warning "Git Information Recommended"
    Without Git SHA and version, Versioner will use the Rundeck execution ID as the version. This works but doesn't link to your source code. For best results, pass Git info via job options.

## Next Steps

- [CLI Usage Guide](../usage.md)
- [CI/CD Integration Overview](index.md)
