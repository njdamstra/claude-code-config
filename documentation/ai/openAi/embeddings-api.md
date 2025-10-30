# OpenAI Embeddings API Reference

The OpenAI Embeddings API allows you to convert text into numerical vectors (embeddings) that can be used for semantic search, clustering, recommendations, and other natural language processing tasks.

**Note**: The complete API reference is very large (296,000 tokens). This document provides a summary of the most important endpoints and parameters. For the complete reference, visit: https://platform.openai.com/docs/api-reference/embeddings

## Base Endpoint

```
POST https://api.openai.com/v1/embeddings
```

## Authentication

All API requests require authentication using an API key:

```bash
Authorization: Bearer $OPENAI_API_KEY
```

## Create Embeddings

### Request

**POST** `/v1/embeddings`

Creates an embedding vector representing the input text.

**Request Body (JSON):**

```json
{
  "input": "Your text string goes here",
  "model": "text-embedding-3-small",
  "encoding_format": "float",
  "dimensions": 1536,
  "user": "user-identifier"
}
```

### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `input` | string or array | Yes | Input text to embed. Can be a single string or array of strings. Max 8192 tokens per string. |
| `model` | string | Yes | ID of the model to use. Options: `text-embedding-3-small`, `text-embedding-3-large`, `text-embedding-ada-002` |
| `encoding_format` | string | No | Format for the embeddings. Options: `float` (default), `base64` |
| `dimensions` | integer | No | Number of dimensions for the output embeddings. Only supported in `text-embedding-3` and later models. |
| `user` | string | No | Unique identifier representing your end-user for abuse monitoring. |

### Response

```json
{
  "object": "list",
  "data": [
    {
      "object": "embedding",
      "index": 0,
      "embedding": [
        -0.006929283495992422,
        -0.005336422007530928,
        ...
      ]
    }
  ],
  "model": "text-embedding-3-small",
  "usage": {
    "prompt_tokens": 5,
    "total_tokens": 5
  }
}
```

### Response Fields

| Field | Type | Description |
|-------|------|-------------|
| `object` | string | Always "list" |
| `data` | array | Array of embedding objects |
| `data[].object` | string | Always "embedding" |
| `data[].index` | integer | Index of the embedding in the input array |
| `data[].embedding` | array | The embedding vector (array of floats) |
| `model` | string | The model used for embeddings |
| `usage` | object | Token usage information |
| `usage.prompt_tokens` | integer | Number of tokens in the input |
| `usage.total_tokens` | integer | Total tokens used |

## Available Models

### text-embedding-3-small
- **Dimensions**: 1536 (default)
- **Max Input**: 8192 tokens
- **Performance**: 62.3% on MTEB benchmark
- **Cost**: ~62,500 pages per dollar
- **Best for**: Most use cases, balance of performance and cost

### text-embedding-3-large
- **Dimensions**: 3072 (default)
- **Max Input**: 8192 tokens
- **Performance**: 64.6% on MTEB benchmark
- **Cost**: ~9,615 pages per dollar
- **Best for**: Highest quality embeddings, critical applications

### text-embedding-ada-002 (Legacy)
- **Dimensions**: 1536
- **Max Input**: 8192 tokens
- **Performance**: 61.0% on MTEB benchmark
- **Cost**: ~12,500 pages per dollar
- **Status**: Superseded by text-embedding-3 models

## Usage Examples

### Python

```python
from openai import OpenAI

client = OpenAI(api_key="your-api-key")

# Single text embedding
response = client.embeddings.create(
    input="The quick brown fox jumps over the lazy dog",
    model="text-embedding-3-small"
)

embedding = response.data[0].embedding
print(f"Embedding dimension: {len(embedding)}")
```

### Python - Batch Embeddings

```python
# Multiple texts
texts = [
    "First document text",
    "Second document text",
    "Third document text"
]

response = client.embeddings.create(
    input=texts,
    model="text-embedding-3-small"
)

for i, data in enumerate(response.data):
    print(f"Text {i}: {len(data.embedding)} dimensions")
```

### Python - Custom Dimensions

```python
# Use smaller dimension for cost savings
response = client.embeddings.create(
    input="Sample text",
    model="text-embedding-3-small",
    dimensions=512  # Reduce from 1536 to 512
)

print(f"Dimension: {len(response.data[0].embedding)}")
```

### JavaScript

```javascript
import OpenAI from 'openai';

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY
});

async function getEmbedding() {
  const response = await openai.embeddings.create({
    model: "text-embedding-3-small",
    input: "Your text string goes here",
    encoding_format: "float"
  });

  console.log(response.data[0].embedding);
}

getEmbedding();
```

### cURL

```bash
curl https://api.openai.com/v1/embeddings \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -d '{
    "input": "Your text string goes here",
    "model": "text-embedding-3-small",
    "encoding_format": "float"
  }'
```

## Advanced Features

### Reducing Dimensions

You can reduce embedding dimensions for cost and storage savings:

```python
response = client.embeddings.create(
    input="Sample text",
    model="text-embedding-3-large",
    dimensions=1024  # Reduce from 3072 to 1024
)
```

**Benefits**:
- Reduced storage costs
- Faster similarity computations
- Lower memory usage

**Trade-offs**:
- Slight decrease in accuracy
- Still maintains semantic meaning

### Base64 Encoding

For binary transfer efficiency:

```python
response = client.embeddings.create(
    input="Sample text",
    model="text-embedding-3-small",
    encoding_format="base64"
)

# Embedding is now base64 encoded
base64_embedding = response.data[0].embedding
```

### User Tracking

For monitoring and abuse prevention:

```python
response = client.embeddings.create(
    input="Sample text",
    model="text-embedding-3-small",
    user="user-123456"
)
```

## Error Codes

| Status Code | Description |
|-------------|-------------|
| 200 | Success |
| 400 | Bad Request - Invalid parameters |
| 401 | Unauthorized - Invalid API key |
| 429 | Rate Limit Exceeded |
| 500 | Internal Server Error |
| 503 | Service Unavailable |

### Error Response Format

```json
{
  "error": {
    "message": "Error message here",
    "type": "invalid_request_error",
    "param": "model",
    "code": "model_not_found"
  }
}
```

## Rate Limits

Rate limits vary by organization and usage tier. Check your limits at:
https://platform.openai.com/account/rate-limits

**Typical Limits**:
- Requests per minute (RPM)
- Tokens per minute (TPM)
- Tokens per day (TPD)

## Best Practices

1. **Batch Requests**: Embed multiple texts in a single request when possible
2. **Use Appropriate Dimensions**: Balance quality vs. cost with the `dimensions` parameter
3. **Cache Results**: Store embeddings to avoid redundant API calls
4. **Normalize Vectors**: OpenAI embeddings are pre-normalized to length 1
5. **Handle Errors**: Implement retry logic with exponential backoff
6. **Monitor Usage**: Track token consumption for cost management

## Pricing

Pricing is based on the number of tokens processed. Visit the pricing page for current rates:
https://openai.com/api/pricing/

**Approximate costs** (subject to change):
- text-embedding-3-small: Most cost-effective
- text-embedding-3-large: Premium pricing
- text-embedding-ada-002: Legacy pricing

## Additional Resources

- [Embeddings Guide](https://platform.openai.com/docs/guides/embeddings)
- [API Reference](https://platform.openai.com/docs/api-reference/embeddings)
- [Token Counter](https://platform.openai.com/tokenizer)
- [Cookbook Examples](https://cookbook.openai.com/examples)
- [Rate Limits](https://platform.openai.com/account/rate-limits)
- [Pricing](https://openai.com/api/pricing/)

## Support

For API support and questions:
- [Help Center](https://help.openai.com/)
- [Community Forum](https://community.openai.com/)
- [Developer Forum](https://community.openai.com/c/api)
