# Installation

Get started with the Versioner CLI by downloading the binary for your platform.

## Download Binary

=== "Linux"

    ```bash
    curl -L https://github.com/versioner-io/versioner-cli/releases/latest/download/versioner-linux-amd64 -o versioner
    chmod +x versioner
    sudo mv versioner /usr/local/bin/
    ```

=== "macOS (Apple Silicon)"

    ```bash
    curl -L https://github.com/versioner-io/versioner-cli/releases/latest/download/versioner-darwin-arm64 -o versioner
    chmod +x versioner
    sudo mv versioner /usr/local/bin/
    ```

=== "macOS (Intel)"

    ```bash
    curl -L https://github.com/versioner-io/versioner-cli/releases/latest/download/versioner-darwin-amd64 -o versioner
    chmod +x versioner
    sudo mv versioner /usr/local/bin/
    ```

=== "Windows"

    Download `versioner-windows-amd64.exe` from [GitHub Releases](https://github.com/versioner-io/versioner-cli/releases/latest) and add to your PATH.

## Verify Installation

```bash
versioner version
```

Expected output:
```
Versioner CLI v1.0.0
Commit: abc123
Build Date: 2025-11-06T12:00:00Z
```

## Authentication

The CLI requires a Versioner API key to authenticate requests.

### Get Your API Key

1. Log in to [app.versioner.io](https://app.versioner.io)
2. Navigate to **Settings** → **API Keys**
3. Click **Create API Key**
4. Copy the key (starts with `sk_`)

### Set API Key

**Option 1: Environment Variable (Recommended)**

```bash
export VERSIONER_API_KEY="sk_mycompany_k1_..."
```

Add to your shell profile (`~/.bashrc`, `~/.zshrc`, etc.) to persist:

```bash
echo 'export VERSIONER_API_KEY="sk_mycompany_k1_..."' >> ~/.zshrc
```

**Option 2: Command Line Flag**

```bash
versioner track deployment --api-key sk_mycompany_k1_... ...
```

!!! warning "Security Note"
    Using `--api-key` as a flag exposes it in process lists and shell history. Use environment variables instead.

## Quick Start

Track your first deployment:

```bash
# Set your API key
export VERSIONER_API_KEY="sk_mycompany_k1_..."

# Track a deployment
versioner track deployment \
  --product my-service \
  --version 1.0.0 \
  --environment production \
  --status completed
```

## Next Steps

- [Command Reference](commands.md) - Learn all available commands
- [CI/CD Integration](ci-cd-systems.md) - Auto-detect metadata in CI/CD systems
- [Configuration](configuration.md) - Advanced configuration options
