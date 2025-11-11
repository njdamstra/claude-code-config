[![Groq](https://console.groq.com/groq-logo.svg)](https://console.groq.com/home)

[Docs](https://console.groq.com/docs/overview) [Login](https://console.groq.com/home)

[Log In](https://console.groq.com/login)

# Supported Models

Explore all available models on GroqCloud.

## [Featured Models and Systems](https://console.groq.com/docs/models\#featured-models-and-systems)

[![Groq Compound icon](https://console.groq.com/_next/image?url=%2Fgroq-circle.png&w=96&q=75)\\
\\
**Groq Compound** \\
\\
Groq Compound is an AI system powered by openly available models that intelligently and selectively uses built-in tools to answer user queries, including web search and code execution.\\
\\
Token Speed\\
\\
~450 tps\\
\\
Modalities\\
\\
Capabilities](https://console.groq.com/docs/compound/systems/compound) [![OpenAI GPT-OSS 120B icon](https://console.groq.com/_next/static/media/openailogo.523c87a0.svg)\\
\\
**OpenAI GPT-OSS 120B** \\
\\
GPT-OSS 120B is OpenAI's flagship open-weight language model with 120 billion parameters, built in browser search and code execution, and reasoning capabilities.\\
\\
Token Speed\\
\\
~500 tps\\
\\
Modalities\\
\\
Capabilities](https://console.groq.com/docs/model/openai/gpt-oss-120b)

## [Production Models](https://console.groq.com/docs/models\#production-models)

**Note:** Production models are intended for use in your production environments. They meet or exceed our high standards for speed, quality, and reliability. Read more [here](https://console.groq.com/docs/deprecations).

| MODEL ID | DEVELOPER | CONTEXT WINDOW<br>(TOKENS) | MAX<br>COMPLETION TOKENS | MAX FILE<br>SIZE | DETAILS |
| --- | --- | --- | --- | --- | --- |
| llama-3.1-8b-instant | Meta | 131,072 | 131,072 | - | [Details](https://console.groq.com/docs/model/llama-3.1-8b-instant) |
| llama-3.3-70b-versatile | Meta | 131,072 | 32,768 | - | [Details](https://console.groq.com/docs/model/llama-3.3-70b-versatile) |
| meta-llama/llama-guard-4-12b | Meta | 131,072 | 1,024 | 20 MB | [Details](https://console.groq.com/docs/model/meta-llama/llama-guard-4-12b) |
| openai/gpt-oss-120b | OpenAI | 131,072 | 65,536 | - | [Details](https://console.groq.com/docs/model/openai/gpt-oss-120b) |
| openai/gpt-oss-20b | OpenAI | 131,072 | 65,536 | - | [Details](https://console.groq.com/docs/model/openai/gpt-oss-20b) |
| whisper-large-v3 | OpenAI | - | - | 100 MB | [Details](https://console.groq.com/docs/model/whisper-large-v3) |
| whisper-large-v3-turbo | OpenAI | - | - | 100 MB | [Details](https://console.groq.com/docs/model/whisper-large-v3-turbo) |

## [Production Systems](https://console.groq.com/docs/models\#production-systems)

Systems are a collection of models and tools that work together to answer a user query.

| MODEL ID | DEVELOPER | CONTEXT WINDOW<br>(TOKENS) | MAX<br>COMPLETION TOKENS | MAX FILE<br>SIZE | DETAILS |
| --- | --- | --- | --- | --- | --- |
| groq/compound | Groq | 131,072 | 8,192 | - | [Details](https://console.groq.com/docs/compound/systems/compound) |
| groq/compound-mini | Groq | 131,072 | 8,192 | - | [Details](https://console.groq.com/docs/compound/systems/compound-mini) |

[Learn More About Agentic Tooling\\
\\
Discover how to build powerful applications with real-time web search and code execution](https://console.groq.com/docs/agentic-tooling)

## [Preview Models](https://console.groq.com/docs/models\#preview-models)

**Note:** Preview models are intended for evaluation purposes only and should not be used in production environments as they may be discontinued at short notice. Read more about deprecations [here](https://console.groq.com/docs/deprecations).

| MODEL ID | DEVELOPER | CONTEXT WINDOW<br>(TOKENS) | MAX<br>COMPLETION TOKENS | MAX FILE<br>SIZE | DETAILS |
| --- | --- | --- | --- | --- | --- |
| meta-llama/llama-4-maverick-17b-128e-instruct | Meta | 131,072 | 8,192 | 20 MB | [Details](https://console.groq.com/docs/model/meta-llama/llama-4-maverick-17b-128e-instruct) |
| meta-llama/llama-4-scout-17b-16e-instruct | Meta | 131,072 | 8,192 | 20 MB | [Details](https://console.groq.com/docs/model/meta-llama/llama-4-scout-17b-16e-instruct) |
| meta-llama/llama-prompt-guard-2-22m | Meta | 512 | 512 | - | [Details](https://console.groq.com/docs/model/meta-llama/llama-prompt-guard-2-22m) |
| meta-llama/llama-prompt-guard-2-86m | Meta | 512 | 512 | - | [Details](https://console.groq.com/docs/model/meta-llama/llama-prompt-guard-2-86m) |
| moonshotai/kimi-k2-instruct-0905 | Moonshot AI | 262,144 | 16,384 | - | [Details](https://console.groq.com/docs/model/moonshotai/kimi-k2-instruct-0905) |
| playai-tts | PlayAI | 8,192 | 8,192 | - | [Details](https://console.groq.com/docs/model/playai-tts) |
| playai-tts-arabic | PlayAI | 8,192 | 8,192 | - | [Details](https://console.groq.com/docs/model/playai-tts-arabic) |
| qwen/qwen3-32b | Alibaba Cloud | 131,072 | 40,960 | - | [Details](https://console.groq.com/docs/model/qwen/qwen3-32b) |

## [Deprecated Models](https://console.groq.com/docs/models\#deprecated-models)

Deprecated models are models that are no longer supported or will no longer be supported in the future. See our deprecation guidelines and deprecated models [here](https://console.groq.com/docs/deprecations).

## [Get All Available Models](https://console.groq.com/docs/models\#get-all-available-models)

Hosted models are directly accessible through the GroqCloud Models API endpoint using the model IDs mentioned above. You can use the `https://api.groq.com/openai/v1/models` endpoint to return a JSON list of all active models:

shell

```
curl -X GET "https://api.groq.com/openai/v1/models" \
     -H "Authorization: Bearer $GROQ_API_KEY" \
     -H "Content-Type: application/json"
```

### Was this page helpful?

YesNoSuggest Edits

#### On this page

- [Featured Models and Systems](https://console.groq.com/docs/models#featured-models-and-systems)
- [Production Models](https://console.groq.com/docs/models#production-models)
- [Production Systems](https://console.groq.com/docs/models#production-systems)
- [Preview Models](https://console.groq.com/docs/models#preview-models)
- [Deprecated Models](https://console.groq.com/docs/models#deprecated-models)
- [Get All Available Models](https://console.groq.com/docs/models#get-all-available-models)

StripeM-Inner
