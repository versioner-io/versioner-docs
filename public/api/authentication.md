# Authentication

Versioner uses two authentication methods depending on your use case:

| Method | Format | Use for |
|--------|--------|---------|
| **API Keys** | `sk_{account}_{id}_{random}` | CI/CD event tracking |
| **Personal Access Tokens** | `pat_{...}` | Programmatic read access, agent integrations |

The web application uses session tokens internally — these aren't intended for direct API use.

---

## API Keys

API keys authenticate **event tracking** from CI/CD systems:

- `POST /build-events/` — track builds
- `POST /deployment-events/` — track deployments

Create and manage API keys under **Settings → Organization → API Keys** in the Versioner app.

### Usage

Include the key as a Bearer token:

```http
Authorization: Bearer sk_mycompany_k1_abc123def456...
```

=== "curl"

    ```bash
    curl -X POST https://api.versioner.io/deployment-events/ \
      -H "Authorization: Bearer sk_mycompany_k1_abc123def456..." \
      -H "Content-Type: application/json" \
      -d '{
        "product_name": "my-service",
        "version": "1.2.3",
        "environment_name": "production",
        "status": "success"
      }'
    ```

=== "Python"

    ```python
    import requests

    response = requests.post(
        "https://api.versioner.io/deployment-events/",
        headers={
            "Authorization": "Bearer sk_mycompany_k1_abc123def456...",
            "Content-Type": "application/json"
        },
        json={
            "product_name": "my-service",
            "version": "1.2.3",
            "environment_name": "production",
            "status": "success"
        }
    )
    ```

=== "JavaScript"

    ```javascript
    const response = await fetch('https://api.versioner.io/deployment-events/', {
      method: 'POST',
      headers: {
        'Authorization': 'Bearer sk_mycompany_k1_abc123def456...',
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        product_name: 'my-service',
        version: '1.2.3',
        environment_name: 'production',
        status: 'success'
      })
    });
    ```

### Multiple Keys

You can create multiple API keys per account — useful for key rotation, separating systems, or revoking a compromised key without disrupting others.

### Rotating Keys

1. Create a new key
2. Update your systems to use it
3. Verify it works
4. Revoke the old key

---

## Personal Access Tokens (PATs)

PATs are for programmatic access. They're user-scoped and designed for agents, scripts, and integrations that work with Versioner data. The [MCP server](../agents/mcp.md) uses PATs for this purpose.

!!! info "Expanding scope"
    PAT support currently covers read operations. Write access via PATs is planned — check the [interactive docs](interactive-docs.md) for the current endpoint list.

Create and manage PATs under **Settings → Developer** in the Versioner app.

### Usage

Same Bearer token format as API keys:

```http
Authorization: Bearer pat_...
```

=== "curl"

    ```bash
    curl https://api.versioner.io/deployments/ \
      -H "Authorization: Bearer pat_..."
    ```

=== "Python"

    ```python
    import requests

    response = requests.get(
        "https://api.versioner.io/deployments/",
        headers={"Authorization": "Bearer pat_..."}
    )
    ```

---

## Managing Keys

### Security Best Practices

**Never commit keys to source control:**

```yaml
# ❌ Wrong
env:
  VERSIONER_API_KEY: sk_mycompany_k1_abc123...

# ✅ Right
env:
  VERSIONER_API_KEY: ${{ secrets.VERSIONER_API_KEY }}
```

**Use environment variables:**

```bash
export VERSIONER_API_KEY="sk_mycompany_k1_..."
```

**Limit access:** give keys only to systems that need them, use separate keys per environment, revoke promptly when no longer needed.

**Monitor usage:** the `last_used_at` field on each key helps identify unused keys (candidates for revocation) and unexpected usage (potential compromise).

---

## Authentication Errors

### 401 Unauthorized

Key is missing, invalid, or revoked.

```json
{"detail": "Invalid authentication credentials"}
```

- Verify the key is correct and hasn't been revoked
- Confirm the `Authorization: Bearer` header is present

### 403 Forbidden

Key is valid but lacks permission for the requested resource.

```json
{"detail": "You do not have permission to perform this action"}
```

- Verify you're accessing resources within your account
- For write operations, ensure you're using a JWT session (web app) or wait for PAT write support

---

## No Authentication Required

- `GET /health`
- `GET /docs`, `GET /redoc`, `GET /openapi.json`

---

## Next Steps

- [Event Tracking](event-tracking.md) — submit deployment and build events
- [Event Types](event-types.md) — status values and payload details
- [Response Codes](response-codes.md) — error handling
- [Interactive Docs](interactive-docs.md) — explore all endpoints with current auth requirements
