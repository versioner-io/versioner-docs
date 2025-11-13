# Response Codes

HTTP status codes and error responses used by the Versioner API.

## Success Codes

| Code | Description | When Used |
|------|-------------|-----------|
| `200 OK` | Request succeeded | GET, POST, PATCH requests |
| `201 Created` | Resource created | POST requests creating new resources |
| `204 No Content` | Request succeeded, no content | DELETE requests |

## Client Response Codes

### 400 Bad Request

**Cause:** Request body is malformed or invalid.

**Example Response:**

```json
{
  "detail": "Invalid JSON in request body"
}
```

**Solutions:**
- Check JSON syntax
- Verify Content-Type header is `application/json`
- Ensure all required fields are present

### 401 Unauthorized

**Cause:** Missing or invalid API key.

**Example Response:**

```json
{
  "detail": "Invalid authentication credentials"
}
```

**Solutions:**
- Verify API key is correct
- Check Authorization header format: `Bearer sk_...`
- Ensure API key hasn't been revoked

See [Authentication](authentication.md) for details.

### 403 Forbidden

**Cause:** Valid API key but insufficient permissions.

**Example Response:**

```json
{
  "detail": "You do not have permission to perform this action"
}
```

**Solutions:**
- Verify you're accessing resources in your account
- Check API key has necessary permissions

### 404 Not Found

**Cause:** Resource doesn't exist.

**Example Response:**

```json
{
  "detail": "Not found"
}
```

**Solutions:**
- Verify resource ID is correct
- Check resource exists in your account
- Ensure URL path is correct

### 409 Conflict

**Cause:** Another deployment is already in progress.

!!! info "Pre-flight Checks"
    This status code is used by pre-flight checks (coming soon).

**Example Response:**

```json
{
  "error": "deployment_blocked",
  "message": "Another deployment to production is already in progress",
  "code": "CONCURRENT_DEPLOYMENT",
  "details": {
    "conflicting_deployment_id": "550e8400-e29b-41d4-a716-446655440000",
    "conflicting_deployment_status": "in_progress",
    "conflicting_deployment_started": "2025-10-28T15:00:00Z"
  }
}
```

**Solutions:**
- Wait for current deployment to complete
- Abort current deployment if safe to do so

### 422 Unprocessable Entity

**Cause:** Request body has validation errors.

**Example Response:**

```json
{
  "detail": [
    {
      "loc": ["body", "product_name"],
      "msg": "field required",
      "type": "value_error.missing"
    },
    {
      "loc": ["body", "version"],
      "msg": "field required",
      "type": "value_error.missing"
    }
  ]
}
```

**Solutions:**
- Check all required fields are provided
- Verify field types match schema
- Review field validation rules

### 423 Locked

**Cause:** No-deploy window is active.

!!! info "Pre-flight Checks"
    This status code is used by pre-flight checks (coming soon).

**Example Response:**

```json
{
  "error": "deployment_blocked",
  "message": "No deployments allowed on Fridays after 3pm PST",
  "code": "NO_DEPLOY_WINDOW",
  "retry_after": "2025-10-28T00:00:00Z",
  "details": {
    "window_name": "friday_freeze",
    "window_start": "2025-10-25T15:00:00-07:00",
    "window_end": "2025-10-28T00:00:00-07:00",
    "reason": "Weekly deployment freeze"
  }
}
```

**Solutions:**
- Wait until no-deploy window ends
- Check `retry_after` field for when to retry
- Request emergency override if critical

### 428 Precondition Required

**Cause:** Required approvals or checks are missing.

!!! info "Pre-flight Checks"
    This status code is used by pre-flight checks (coming soon).

**Example Response:**

```json
{
  "error": "deployment_blocked",
  "message": "Production deployment requires approval from 2 team leads",
  "code": "APPROVAL_REQUIRED",
  "details": {
    "required_approvals": 2,
    "current_approvals": 0,
    "approver_roles": ["team-lead", "manager"]
  }
}
```

**Solutions:**
- Request required approvals
- Wait for approvals to be granted
- Check approval requirements for environment

### 429 Too Many Requests

**Cause:** Rate limit exceeded.

!!! info "Coming Soon"
    Rate limiting is planned but not yet implemented.

**Example Response:**

```json
{
  "detail": "Rate limit exceeded. Try again in 60 seconds."
}
```

**Headers:**

```http
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 0
X-RateLimit-Reset: 1698765432
Retry-After: 60
```

**Solutions:**
- Wait for rate limit to reset
- Check `Retry-After` header
- Reduce request frequency

## Server Response Codes

### 500 Internal Server Error

**Cause:** Unexpected server error.

**Example Response:**

```json
{
  "detail": "Internal server error"
}
```

**Solutions:**
- Retry the request
- Check API status page
- Contact support if persists

### 502 Bad Gateway

**Cause:** Gateway error (usually temporary).

**Solutions:**
- Retry the request
- Wait a few seconds and try again

### 503 Service Unavailable

**Cause:** Service is temporarily unavailable (maintenance, overload).

**Example Response:**

```json
{
  "detail": "Service temporarily unavailable"
}
```

**Solutions:**
- Retry with exponential backoff
- Check API status page

## Error Response Format

All error responses follow this structure:

### Simple Errors

```json
{
  "detail": "Error message"
}
```

### Validation Errors (422)

```json
{
  "detail": [
    {
      "loc": ["body", "field_name"],
      "msg": "Error message",
      "type": "error_type"
    }
  ]
}
```

### Pre-flight Check Errors (409, 423, 428)

```json
{
  "error": "deployment_blocked",
  "message": "Human-readable message",
  "code": "ERROR_CODE",
  "retry_after": "ISO 8601 timestamp (optional)",
  "details": {
    "additional": "context"
  }
}
```

## Handling Errors

### Retry Logic

Implement exponential backoff for retryable errors:

```python
import time
import requests

def make_request_with_retry(url, max_retries=3):
    for attempt in range(max_retries):
        try:
            response = requests.post(url, ...)
            response.raise_for_status()
            return response.json()
        except requests.exceptions.HTTPError as e:
            if e.response.status_code in [500, 502, 503]:
                # Retryable error
                wait_time = 2 ** attempt  # Exponential backoff
                time.sleep(wait_time)
                continue
            else:
                # Non-retryable error
                raise
    raise Exception("Max retries exceeded")
```

### Error Logging

Log errors with context:

```python
try:
    response = requests.post(url, json=data)
    response.raise_for_status()
except requests.exceptions.HTTPError as e:
    logger.error(
        "API request failed",
        status_code=e.response.status_code,
        response_body=e.response.text,
        request_data=data
    )
    raise
```

## Common Issues

### "field required" Validation Error

**Problem:** Missing required field in request.

**Solution:** Check API documentation for required fields.

### "Invalid authentication credentials"

**Problem:** API key is wrong or missing.

**Solution:** Verify API key and Authorization header format.

### "Not found"

**Problem:** Resource doesn't exist or wrong URL.

**Solution:** Check resource ID and URL path.

## Next Steps

- Review [Authentication](authentication.md)
- Explore [Event Tracking API](event-tracking.md)
- Learn about [Event Types](event-types.md)
