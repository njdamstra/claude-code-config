# Useful Documentation for Socialaize's AI Features

This index tracks documentation resources for the AI-powered features in Socialaize's social media management platform.

## What we've scraped:

### LlamaIndex TypeScript Documentation
**Location:** `claude-docs/ai/llamaindex-typescript/`
- ✅ **home.md** (6.8KB) - LlamaIndex.TS framework overview, agents, workflows
- ✅ **workflows.md** (2.4KB) - Event-driven workflow architecture and deployment
- ✅ **llms.md** (2.1KB) - LLM integration guide (OpenAI, Azure, local models)
- ✅ **openai-api.md** (7.0KB) - Complete OpenAI class API reference for TypeScript
- ✅ **README.md** (2.1KB) - Index and usage guide

**Total:** 5 documents (20.4KB) covering frontend workflow implementation

### LlamaIndex Python Documentation
**Location:** `claude-docs/ai/llamaindex-python/`

#### Core Workflows & LLMs
- ✅ **workflows-guide.md** (1.0KB) - Workflows overview and versions
- ✅ **durable-workflows.md** (3.2KB) - Persisting workflow state strategies
- ✅ **agent-workflow-example.md** (1.8KB) - Research assistant tutorial with tools
- ✅ **llms-overview.md** (21.3KB) - Comprehensive LLM API reference
- ✅ **llm-examples.md** (3.6KB) - Local LLM tutorial with Ollama
- ✅ **openai-agent-example.md** (1.1KB) - FunctionAgent and ReActAgent examples
- ✅ **chat-engines.md** (2.0KB) - ContextChatEngine with streaming

#### Tools
- ✅ **tools-guide.md** (7.3KB) - Tool abstractions for agentic systems
- ✅ **tools-api-reference.md** (13.8KB) - Complete Tools API with BaseTool classes

#### Evaluation (subfolder: evaluation/)
- ✅ **evaluation-index.md** (4.0KB) - Evaluation module API reference
- ✅ **faithfulness-evaluator.md** (4.1KB) - Faithfulness evaluator for responses

#### Streaming (subfolder: streaming/)
- ✅ **async-patterns.md** (3.3KB) - Async patterns in LlamaIndex
- ✅ **streaming-examples.md** (4.2KB) - Examples for streaming
- ✅ **typescript-streaming.md** (3.1KB) - TypeScript streaming documentation

#### Observability & Vector Stores (Phase 2 Advanced ✅)
- ✅ **mlflow-integration.md** (12KB) - MLflow tracing integration guide
- ✅ **observability-guide.md** (18KB) - 20+ observability platform integrations
- ✅ **indices-overview.md** (15KB) - Complete BaseIndex API reference
- ✅ **vector-stores-examples.md** (20KB) - 40+ vector store integrations with examples

**Total:** 18 documents (123KB) covering backend workflow patterns, tools, observability, and vector stores

### OpenAI Documentation
**Location:** `claude-docs/ai/openai/`

#### Core API & Function Calling
- ✅ **openai-python-readme.md** (21.3KB) - Complete Python SDK documentation
- ✅ **streaming-helpers.md** (21.3KB) - Comprehensive streaming API with 10+ event types
- ✅ **function-calling-streaming.md** (29.5KB) - Function calling with streaming guide
- ✅ **function-calling-parallel.md** (29.5KB) - Parallel function calling documentation
- ✅ **structured-outputs-guide.md** (7.0KB) - JSON Schema and structured outputs

#### Models
- ✅ **models-overview.md** (2.7KB) - All available models catalog
- ✅ **model-gpt-5-nano.md** (2.9KB) - GPT-5 nano specifications
- ✅ **model-gpt-5-mini.md** (2.9KB) - GPT-5 mini specifications

#### Production & Error Handling (Phase 2 ✅)
- ✅ **error-codes.md** (2.6KB) - API error codes and handling
- ✅ **rate-limits-guide.md** (12.9KB) - Rate limits and usage tiers
- ✅ **production-best-practices.md** (14.6KB) - Scaling, optimization, security
- ✅ **error-handling-sdk.md** (9.9KB) - Error handling, retries, and timeouts
- ✅ **safety-best-practices.md** (4.3KB) - Safety best practices for production

#### Advanced Features (Phase 2 Advanced ✅)
- ✅ **embeddings-api.md** (12KB) - Complete embeddings API reference
- ✅ **embeddings-guide.md** (28KB) - Embeddings usage guide with 10+ examples
- ✅ **batch-api-guide.md** (13KB) - Batch API for asynchronous processing
- ✅ **fine-tuning-guide.md** (27KB) - Supervised fine-tuning guide
- ⚠️ **batch-api-reference.md** - Note about protected endpoint.

#### Legacy
- ⚠️ **completions-api-reference.md** (0.9KB) - Note about legacy endpoint

#### Documentation
- ✅ **README.md** (2.8KB) - Scraping status and coverage analysis

**Total:** 19 documents (245KB) covering chat, streaming, function calling, models, production, embeddings, and fine-tuning

### Groq Documentation
**Location:** `claude-docs/ai/groq/`

#### Core
- ✅ **openai-compatibility.md** (3.5KB) - OpenAI client library compatibility
- ✅ **client-libraries.md** (5.5KB) - Python library and community SDKs
- ✅ **rate-limits.md** (4.7KB) - Rate limit types and model-specific limits
- ✅ **tool-use.md** (24KB) - Comprehensive tool use with streaming
- ✅ **text-chat.md** (14KB) - Chat completions and streaming patterns
- ✅ **optimizing-latency.md** (15KB) - Production latency optimization
- ✅ **models-overview.md** - Complete models catalog
- ✅ **api-reference.md** - Full API documentation

#### Advanced (Phase 2 Advanced ✅)
- ✅ **integrations-overview.md** - Overview of Groq integrations
- ✅ **compound-ai-overview.md** (8KB) - Compound AI systems with web search & code execution
- ✅ **agentic-tooling.md** - Groq's Compound systems for agentic tooling.
- ✅ **llamaindex-integration-guide.md** - LlamaIndex integration with Groq.

#### Production
- ✅ **production-checklist.md** - Production-ready checklist for applications on GroqCloud

**Total:** 14 documents covering Groq integration, optimization, and compound AI systems

---

## Phase 1 Scraping Complete ✅

**Total Documentation Scraped:**
- **34 documents**
- **~243KB of documentation**
- **4 major categories covered**

**Coverage:**
- ✅ LlamaIndex TypeScript (5 docs, 20.4KB - CRITICAL for frontend)
- ✅ LlamaIndex Python (14 docs, 58.2KB - backend workflows)
- ✅ OpenAI (10 docs, 112KB - chat, streaming, function calling)
- ✅ Groq (11 docs - compatibility, rate limits, optimization)

---

## Phase 2 Production Readiness Complete ✅

**Additional Documentation Scraped:**
- **5 OpenAI production documents**
- **~44KB of production documentation**

**Phase 2 Coverage:**
- ✅ Error Handling & Recovery (error-codes.md, error-handling-sdk.md)
- ✅ Rate Limiting & Optimization (rate-limits-guide.md)
- ✅ Production Best Practices (production-best-practices.md)
- ✅ Safety & Security (safety-best-practices.md)

---

## Phase 2 Advanced Features Complete ✅

**Additional Documentation Scraped:**
- **9 advanced feature documents**
- **~133KB of advanced documentation**

**Phase 2 Advanced Coverage:**
- ✅ LlamaIndex Observability (MLflow, 20+ integrations)
- ✅ Vector Stores (40+ integrations, hybrid search)
- ✅ Indices API (BaseIndex reference)
- ✅ OpenAI Embeddings (API + guide with 10+ examples)
- ✅ Batch Processing (asynchronous API guide)
- ✅ Fine-tuning (supervised fine-tuning workflows)
- ✅ Groq Compound AI (web search, code execution)
- ⚠️ 3 docs pending (2 Groq + 1 OpenAI oversized)

**Updated Total Across All Phases:**
- **48 documents** successfully scraped
- **~420KB of comprehensive documentation**
- **3 documents pending** (awaiting Firecrawl credits or alternative methods)
- Organized across 4 major technology categories

**Note:** Some OpenAI platform docs (platform.openai.com/docs/*) were inaccessible due to authentication requirements, but we successfully scraped equivalent content from GitHub SDK documentation which provides comprehensive coverage.

---

## Full Mappings

### LlamaIndex Full Mapping

**Total Pages:** 190

**Site:** https://docs.llamaindex.ai/

#### Key Sections:
- **Getting Started** (5 pages)
- **Workflows** (15+ pages including durable workflows)
- **API Reference** (100+ pages):
  - Agents, Chat Engines, Callbacks
  - Embeddings (Aleph Alpha, Google GenAI, TextEmbed)
  - LLMs (20+ providers: OpenAI, AI21, Fireworks, Gaudi, etc.)
  - Tools (Arxiv, Azure, Bing Search, Cassandra, Python File)
  - Readers/Data Connectors (25+ integrations)
  - Vector Stores (BGE M3, Vectara, TiDB, etc.)
  - Evaluation & Instrumentation
- **Examples** (40+ notebooks):
  - Agent examples with workflows
  - Embeddings examples
  - Multi-modal examples
  - Vector store examples
  - Observability (MLflow, DeepEval)
- **Module Guides** (Indexing, LlamaDeploy core components)

**Most Relevant Categories for Socialaize:**
- Workflows (Python implementation patterns)
- LLM integrations (OpenAI specifically)
- Function calling & tools
- Vector stores & embeddings
- Observability & evaluation

---

### OpenAI Full Mapping

**Total Pages:** 734

**Site:** https://platform.openai.com/docs/

#### Major Categories:

**API Reference (212 pages):**
- Chat & Completions (15 pages)
- Realtime API (90+ pages) - server events, client events, sessions
- Responses API (50+ pages) - streaming responses
- Audio & Speech (10 pages)
- Images (Image generation + streaming)
- Embeddings (3 pages)
- Moderation (2 pages)
- Assistants & Threads (30+ pages)
- Fine-tuning (15 pages)
- Batch Processing (7 pages)
- Vector Stores (20+ pages)
- Files & Storage (15+ pages)
- Evaluations (Evals + Graders, 23 pages)

**Models (50+ pages):**
- GPT-5 series (nano, mini, chat-latest, codex)
- GPT-4.1 series
- GPT-4o series (including audio, realtime, search, transcribe variants)
- o-series reasoning models (o1, o3, o4-mini)
- Audio models (Whisper, TTS)
- Image models (DALL-E 2/3)
- Embeddings (text-embedding-3-small/large)

**Guides (100+ pages):**
- Text generation & chat
- Function calling & tools (parallel calling, streaming)
- Structured outputs
- Audio & speech (speech-to-text, text-to-speech)
- Embeddings & retrieval
- Evaluation (evals design, graders)
- Fine-tuning (supervised, DPO, RFT)
- Production best practices
- Rate limits & error codes

**GPT Actions (15 pages)** - Authentication, data retrieval, production

**Prompt Examples (10+ pages)** - Tweet classifier, summarization, code explanation

---

### Groq Full Mapping

**Total Pages:** 145

**Site:** https://console.groq.com/docs/

#### Major Sections:

**Core Documentation (8 pages):**
- Overview, Quickstart
- OpenAI compatibility guide
- Libraries (Python, TypeScript)
- API reference
- Changelog

**Model Documentation (35 pages):**
- Llama models (3.1, 3.2, 3.3, 4 Maverick/Scout, Guard 3/4)
- Llama Prompt Guard (22M, 86M)
- Qwen models (2.5, 2.5 Coder, QwQ, 3)
- Mistral, Gemma, ALLaM, DeepSeek R1
- Whisper (audio transcription)
- PlayAI TTS (text-to-speech)

**API Features (16 pages):**
- Text chat, Tool use
- Speech-to-text, Text-to-speech
- Vision, Reasoning
- Structured outputs, Prefilling
- Prompt caching, Batch API
- Content moderation, LoRA
- MCP (Model Context Protocol)
- Flex processing

**Compound AI Systems (14 pages):**
- Compound overview & systems
- Agentic tooling (Compound Beta)
- Built-in tools: browser automation, search, code execution, web search, Wolfram Alpha

**Integrations (16 pages):**
- Frameworks: Vercel AI SDK, LangChain, LlamaIndex, AutoGen, CrewAI
- Tools: Composio, Toolhouse, Gradio, LiveKit, E2B, MLflow

**Account & Billing (9 pages):**
- Projects, Rate limits, Spend limits
- Data privacy, Deprecations

**Production (3 pages):**
- Production checklist
- Latency optimization
- GCP Private Service Connect

**Legal (12 pages):**
- Services agreement, AI policy
- Data processing, Business associate addendum

---

## Plan: Documentation to Scrape

Based on comprehensive analysis of:
- **Backend AI**: `/functions/AI_API/src/` (Python-based workflows, LlamaIndex, OpenAI)
- **Frontend AI**: `/src/` (TypeScript-based workflows, chat UI, SSR integration)

The following areas are most relevant:

### Priority 1: Core Implementation Needs

**Frontend-Specific Additions:**
- The frontend implements TypeScript-based workflows using `@llamaindex/workflow`, `@llamaindex/openai`, and `@llamaindex/groq`
- Key features: streaming responses, tool execution, actionable message cards, usage tracking
- Integration with Astro SSR API routes (`/api/ai/chat.ts`, `/api/ai/actions.ts`)

**LlamaIndex (High Priority):**
1. **Workflows** - Core workflow patterns
   - https://docs.llamaindex.ai/en/stable/module_guides/workflow/ - Main workflows guide
   - https://docs.llamaindex.ai/en/stable/workflows/durable_workflows - Durable workflows (production patterns)
   - https://docs.llamaindex.ai/en/stable/examples/agent/agent_workflow_research_assistant - Agent workflow example

2. **LLM Integration** - OpenAI LLM usage
   - https://docs.llamaindex.ai/en/stable/api_reference/llms - LLM overview
   - https://docs.llamaindex.ai/en/stable/examples/llm - LLM examples

3. **Function Calling & Tools** - Current codebase uses extensive tool calling
   - https://docs.llamaindex.ai/en/stable/module_guides/deploying/agents/tools/ - Tools guide
   - https://docs.llamaindex.ai/en/stable/examples/agent/openai_agent/ - OpenAI agent with tools
   - https://docs.llamaindex.ai/en/stable/api_reference/tools - Tools API reference

4. **Chat & Messages** - Message handling patterns
   - https://docs.llamaindex.ai/en/stable/api_reference/chat - Chat engines
   - Base LLM types for ChatMessage

5. **TypeScript/JavaScript SDK** - Frontend implementation
   - **CRITICAL**: The frontend uses `@llamaindex/workflow`, `@llamaindex/openai`, `@llamaindex/groq` packages
   - Need TypeScript-specific LlamaIndex documentation
   - https://ts.llamaindex.ai/ - TypeScript LlamaIndex docs
   - https://ts.llamaindex.ai/modules/workflows - TypeScript workflows (different from Python)
   - https://ts.llamaindex.ai/modules/llms - TypeScript LLM integrations

**OpenAI (High Priority):**
1. **Chat Completions** - Primary API used
   - https://platform.openai.com/docs/api-reference/chat - Chat API reference
   - https://platform.openai.com/docs/guides/text - Text generation guide
   - https://platform.openai.com/docs/guides/streaming-responses - Streaming responses

2. **Function Calling** - Extensively used in workflows
   - https://platform.openai.com/docs/guides/function-calling - Function calling guide
   - https://platform.openai.com/docs/guides/function-calling/streaming - Streaming function calls
   - https://platform.openai.com/docs/guides/function-calling/parallel - Parallel function calling

3. **Models** - GPT-5-nano used in codebase
   - https://platform.openai.com/docs/models - Models overview
   - https://platform.openai.com/docs/models/gpt-5-nano - GPT-5 nano docs
   - https://platform.openai.com/docs/models/gpt-5-mini - GPT-5 mini docs

4. **Structured Outputs** - For action responses
   - https://platform.openai.com/docs/guides/structured-outputs - Structured outputs guide

5. **Streaming Responses** - Frontend uses SSE streaming
   - https://platform.openai.com/docs/guides/streaming-responses - Streaming guide
   - https://platform.openai.com/docs/api-reference/chat-streaming - Streaming API reference

6. **Error Handling & Best Practices**
   - https://platform.openai.com/docs/guides/error-codes - Error codes
   - https://platform.openai.com/docs/guides/rate-limits - Rate limits
   - https://platform.openai.com/docs/guides/production-best-practices - Production practices

**Groq (Medium Priority):**
1. **OpenAI Compatibility** - Used for model switching in AiManager
   - https://console.groq.com/docs/openai - OpenAI compatibility
   - https://console.groq.com/docs/libraries - Client libraries (TypeScript/JavaScript)

2. **Rate Limits & Optimization** - Important for production
   - https://console.groq.com/docs/rate-limits - Rate limits
   - https://console.groq.com/docs/production-readiness/optimizing-latency - Latency optimization

3. **Tool Use** - Alternative to OpenAI function calling
   - https://console.groq.com/docs/tool-use - Tool use introduction

4. **Streaming** - Frontend implements streaming
   - https://console.groq.com/docs/text-chat - Text chat with streaming support

### Priority 2: Advanced Features (Future Enhancement)

**LlamaIndex:**
1. **Evaluation & Observability**
   - https://docs.llamaindex.ai/en/stable/api_reference/evaluation - Evaluation index
   - https://docs.llamaindex.ai/en/stable/examples/observability/MLflow - MLflow integration
   - https://docs.llamaindex.ai/en/stable/module_guides/observability - Observability guide

2. **Vector Stores** - For potential RAG features
   - https://docs.llamaindex.ai/en/stable/api_reference/indices - Indices overview
   - https://docs.llamaindex.ai/en/stable/examples/vector_stores - Vector store examples

**OpenAI:**
1. **Embeddings** - For content similarity/search
   - https://platform.openai.com/docs/api-reference/embeddings - Embeddings API
   - https://platform.openai.com/docs/guides/embeddings - Embeddings guide

2. **Batch Processing** - For bulk operations
   - https://platform.openai.com/docs/guides/batch - Batch API
   - https://platform.openai.com/docs/api-reference/batch - Batch API reference

3. **Fine-tuning** - For custom models
   - https://platform.openai.com/docs/guides/supervised-fine-tuning - Supervised fine-tuning

**Groq:**
1. **Compound AI Systems** - For complex workflows
   - https://console.groq.com/docs/compound - Compound overview
   - https://console.groq.com/docs/agentic-tooling - Agentic tooling

2. **Integrations**
   - https://console.groq.com/docs/llama-index - LlamaIndex integration

### Priority 3: Reference Materials (As Needed)

**LlamaIndex:**
- Specific tool implementations (Arxiv, Bing Search, etc.) - scrape on demand
- Reader integrations - scrape when implementing data ingestion
- Advanced workflow patterns - scrape when scaling

**OpenAI:**
- Specific model variants - scrape when switching models
- Audio/Vision APIs - scrape when adding multimedia features
- Assistants API - scrape if implementing persistent agents

**Groq:**
- Specific model documentation - scrape when comparing/switching
- Integration-specific guides - scrape when implementing

---

## Scraping Strategy

### Phase 1: Core Implementation (Immediate)
**Target: ~40-50 pages**
- LlamaIndex Python: Workflows, tools, LLM integration (~15 pages)
- **LlamaIndex TypeScript**: Workflows, LLM packages, chat patterns (~10 pages)
- OpenAI: Chat API, function calling, streaming, models (~15 pages)
- Groq: OpenAI compatibility, rate limits, tool use (~5 pages)

**Key Addition**: TypeScript LlamaIndex docs are CRITICAL as the frontend uses `@llamaindex/*` packages

### Phase 2: Production Readiness (Next Sprint)
**Target: ~20-30 pages**
- Error handling patterns
- Rate limits and billing optimization
- Best practices for streaming
- Evaluation and observability

### Phase 3: Advanced Features (Future)
**Target: ~30-40 pages**
- RAG implementation (when adding content search)
- Embeddings (for content similarity)
- Batch processing (for bulk operations)
- Fine-tuning (for custom models)

**Total Estimated:** ~100-120 high-value pages vs 1,069 total available (~10% focused scraping)

---

## Implementation Notes

### Dual Implementation Architecture
The platform uses a **dual AI architecture**:

1. **Backend (Python)**: `/functions/AI_API/`
   - Uses Python LlamaIndex workflows
   - `llama_index.core.workflow` for workflow patterns
   - `llama_index.llms.openai` for LLM integration
   - Handles complex tool execution and data processing

2. **Frontend (TypeScript)**: `/src/`
   - Uses TypeScript LlamaIndex packages
   - `@llamaindex/workflow` for client-side workflows
   - `@llamaindex/openai` and `@llamaindex/groq` for model switching
   - Implements SSE streaming for real-time responses
   - Astro SSR API routes bridge frontend and backend

### Key Documentation Gaps Identified
1. **TypeScript LlamaIndex** - Not in original plan, but CRITICAL for frontend
2. **Streaming Implementations** - Both OpenAI SSE and LlamaIndex streaming patterns
3. **Groq Integration** - Used alongside OpenAI for model flexibility
4. **Tool Execution** - Frontend ToolExecutor class needs tool definition patterns

### Recommended Scraping Order
1. **First**: LlamaIndex TypeScript (frontend depends on it)
2. **Second**: OpenAI streaming + function calling (core features)
3. **Third**: LlamaIndex Python workflows (backend enhancement)
4. **Fourth**: Groq compatibility (production flexibility)

