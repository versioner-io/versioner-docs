# Authentication

Versioner uses **dual authentication** depending on the endpoint:

- **API Keys** - For event tracking from CI/CD systems
- **JWT Tokens** - For dashboard and resource management

## Authentication Methods

### API Keys (For CI/CD Integration)

API keys are used for **event tracking endpoints** that receive data from CI/CD systems:

- `POST /build-events/` - Track builds
- `POST /deployment-events/` - Track deployments

API keys follow this format:

```
sk_{account_id}_{key_id}_{random}
```

**Example:**
```
sk_mycompany_k1_abc123def456ghi789jkl012mno345pqr678
```

### Parts

- **`sk`** - Prefix indicating this is a secret key
- **`mycompany`** - Your account identifier
- **`k1`** - Key identifier (allows multiple keys per account)
- **`abc123...`** - Random secure string (32+ characters)

### JWT Tokens (For Dashboard/CRUD)

JWT tokens are used for **all other endpoints** including:

- Product management (`/products/`)
- Environment management (`/environments/`)
- Version queries (`/versions/`)
- Deployment queries (`/deployments/`)
- Release management (`/releases/`)
- Notification configuration (`/notification-channels/`, `/notification-preferences/`)
- API key management (`/api-keys/`)

JWT tokens are obtained by logging into the Versioner web application via Clerk authentication.

## Using API Keys

**For event tracking endpoints only.**

Include your API key in the `Authorization` header using the `Bearer` scheme:

```http
Authorization: Bearer sk_mycompany_k1_abc123def456...
```

### Examples

=== "curl"

    ```bash
    # Event tracking (API key)
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

    # Event tracking (API key)
    headers = {
        "Authorization": "Bearer sk_mycompany_k1_abc123def456...",
        "Content-Type": "application/json"
    }

    data = {
        "product_name": "my-service",
        "version": "1.2.3",
        "environment_name": "production",
        "status": "success"
    }

    response = requests.post(
        "https://api.versioner.io/deployment-events/",
        headers=headers,
        json=data
    )
    ```

=== "JavaScript"

    ```javascript
    // Event tracking (API key)
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

## Using JWT Tokens

**For dashboard and CRUD endpoints.**

JWT tokens are automatically included when using the Versioner web application. For programmatic access:

### Getting a JWT Token

1. Log in to [app.versioner.io](https://app.versioner.io)
2. Open browser developer tools (F12)
3. Go to Application → Cookies
4. Find the `__session` cookie
5. Copy the JWT token value

### Examples

=== "curl"

    ```bash
    # Query deployments (JWT)
    curl https://api.versioner.io/deployments/ \
      -H "Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9..."
    ```

=== "Python"

    ```python
    import requests

    # CRUD operations (JWT)
    headers = {
        "Authorization": "Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...",
        "Content-Type": "application/json"
    }

    response = requests.get(
        "https://api.versioner.io/deployments/",
        headers=headers
    )
    ```

!!! warning "JWT Tokens for Automation"
    JWT tokens are **not recommended** for CI/CD automation because they:
    
    - Expire after a short time (hours/days)
    - Are tied to user sessions
    - Require manual extraction from browser
    
    Use API keys for CI/CD integration instead.

## Managing API Keys

### Creating Keys

Create API keys from the Versioner web application:

1. Log in to [app.versioner.io](https://app.versioner.io)
2. Go to **Settings** → **Organization** tab
3. Scroll to **API Keys** section
4. Click **Create API Key**
5. Enter a name and description
6. Copy the key (shown only once!)
7. Store securely in your CI/CD secrets

### Multiple Keys

You can have multiple API keys per account:

- **`sk_mycompany_k1_...`** - Primary key
- **`sk_mycompany_k2_...`** - Secondary key
- **`sk_mycompany_k3_...`** - CI/CD key

This allows:

- Key rotation without downtime
- Different keys for different systems
- Revocation of compromised keys

### Rotating Keys

To rotate keys:

1. Create a new key (k2)
2. Update systems to use new key
3. Verify new key works
4. Revoke old key (k1)

## Security Best Practices

### 1. Never Commit Keys

❌ **Never do this:**
```yaml
# .github/workflows/deploy.yml
env:
  VERSIONER_API_KEY: sk_mycompany_k1_abc123...  # WRONG!
```

✅ **Do this instead:**
```yaml
# .github/workflows/deploy.yml
env:
  VERSIONER_API_KEY: ${{ secrets.VERSIONER_API_KEY }}
```

### 2. Use Environment Variables

Store keys in environment variables:

```bash
export VERSIONER_API_KEY="sk_mycompany_k1_..."
```

### 3. Restrict Key Access

- Only give keys to systems that need them
- Use different keys for different environments
- Revoke keys when no longer needed

### 4. Monitor Key Usage

Check the `last_used_at` field to detect:

- Unused keys (can be revoked)
- Unexpected usage (potential compromise)

## Authentication Errors

### 401 Unauthorized

**Cause:** API key is invalid, missing, or revoked.

**Response:**
```json
{
  "detail": "Invalid authentication credentials"
}
```

**Solutions:**
- Verify API key is correct
- Check key hasn't been revoked
- Ensure `Authorization` header is present
- Verify `Bearer` scheme is used

### 403 Forbidden

**Cause:** API key is valid but doesn't have permission.

**Response:**
```json
{
  "detail": "You do not have permission to perform this action"
}
```

**Solutions:**
- Verify you're accessing resources in your account
- Check key has necessary permissions

## Rate Limiting

!!! info "Coming Soon"
    Rate limiting is planned but not yet implemented.

Future rate limits will be:

- **1000 requests per minute** per API key
- **10,000 requests per hour** per account

Rate limit headers will be included in responses:

```http
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 999
X-RateLimit-Reset: 1698765432
```

## Which Authentication to Use?

### Use API Keys For:

✅ **CI/CD event tracking**
- GitHub Actions, Jenkins, GitLab CI, etc.
- Build and deployment notifications
- Automated workflows

**Endpoints:**
- `POST /build-events/`
- `POST /deployment-events/`

### Use JWT Tokens For:

✅ **Dashboard and resource management**
- Web application (automatic)
- Querying deployment history
- Managing products, environments, releases
- Configuring notifications

**Endpoints:**
- All `/products/`, `/environments/`, `/versions/`, `/deployments/`, `/releases/` endpoints
- All `/notification-channels/`, `/notification-preferences/` endpoints
- All `/api-keys/` endpoints

### No Authentication Required:

- `GET /health` - Health check
- `GET /docs` - Interactive API documentation
- `GET /redoc` - Alternative API documentation
- `GET /openapi.json` - OpenAPI specification

## Next Steps

- Learn about [Event Tracking API](event-tracking.md)
- Explore [Event Types](event-types.md)
- See [Response Codes](response-codes.md)
