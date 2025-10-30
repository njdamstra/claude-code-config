# LlamaIndex TypeScript Documentation

This directory contains scraped documentation for LlamaIndex TypeScript, which is critical for frontend AI integration in the Socialaize project.

## Successfully Scraped Pages

1. **home.md** - LlamaIndex.TS overview and introduction
   - Source: https://ts.llamaindex.ai/
   - Contains: Framework overview, core concepts (agents, workflows, context engineering), use cases, getting started guide

2. **workflows.md** - LlamaIndex Workflows documentation
   - Source: https://ts.llamaindex.ai/docs/workflows
   - Contains: Event-driven programming, workflow architecture, handlers, context, deployment examples

3. **llms.md** - Large Language Models integration guide
   - Source: https://next.ts.llamaindex.ai/docs/llamaindex/modules/models/llms
   - Contains: LLM setup, OpenAI integration, Azure OpenAI, local LLMs (Ollama), available LLM integrations

4. **openai-api.md** - OpenAI class API reference
   - Source: https://next.ts.llamaindex.ai/docs/api/classes/OpenAI
   - Contains: Complete OpenAI class API documentation with properties, methods, constructors

## Notes

- The original requested URLs for workflows and LLM documentation returned 404s
- Corrected URLs were found using the firecrawl map tool
- Groq integration documentation was not found in the TypeScript documentation (may only exist in Python version)
- Rate limits were encountered during scraping, requiring pauses between requests

## Usage

These documentation files provide essential reference material for implementing AI features in the Socialaize frontend using LlamaIndex TypeScript.

## Key Features Documented

- **Workflows**: Event-driven orchestration for complex AI workflows
- **OpenAI Integration**: Full TypeScript API for OpenAI LLMs
- **Settings Configuration**: How to configure LLMs globally via Settings object
- **Tool Calling**: Support for function calling and tool usage
- **Streaming**: Async streaming support for real-time responses
