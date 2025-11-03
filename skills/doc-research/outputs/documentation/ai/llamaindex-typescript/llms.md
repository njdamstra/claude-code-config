Modules/Models

# Large Language Models (LLMs)

The LLM is responsible for reading text and generating natural language responses to queries. By default, LlamaIndex.TS uses `gpt-4o`.

The LLM can be explicitly updated through `Settings`.

## Installation

npmpnpmyarnbun

```
npm i llamaindex @llamaindex/openai
```

```
pnpm add llamaindex @llamaindex/openai
```

```
yarn add llamaindex @llamaindex/openai
```

```
bun add llamaindex @llamaindex/openai
```

```
import { OpenAI } from "@llamaindex/openai";
import { Settings } from "llamaindex";

Settings.llm = new OpenAI({ model: "gpt-3.5-turbo", temperature: 0 });
```

## Azure OpenAI

To use Azure OpenAI, you only need to set a few environment variables.

For example:

```
export AZURE_OPENAI_KEY="<YOUR KEY HERE>"
export AZURE_OPENAI_ENDPOINT="<YOUR ENDPOINT, see https://learn.microsoft.com/en-us/azure/ai-services/openai/quickstart?tabs=command-line%2Cpython&pivots=rest-api>"
export AZURE_OPENAI_DEPLOYMENT="gpt-4" # or some other deployment name
```

## Local LLM

For local LLMs, currently we recommend the use of [Ollama](https://next.ts.llamaindex.ai/docs/llamaindex/modules/models/llms/ollama) LLM.

## Available LLMs

Most available LLMs are listed in the sidebar on the left. Additionally the following integrations exist without separate documentation:

- [HuggingFaceLLM](https://next.ts.llamaindex.ai/docs/api/classes/HuggingFaceLLM) and [HuggingFaceInferenceAPI](https://next.ts.llamaindex.ai/docs/api/classes/HuggingFaceInferenceAPI).
- [ReplicateLLM](https://next.ts.llamaindex.ai/docs/api/classes/ReplicateLLM) see [replicate.com](https://replicate.com/)

Check the [LlamaIndexTS Github](https://github.com/run-llama/LlamaIndexTS) for the most up to date overview of integrations.

## API Reference

- [OpenAI](https://next.ts.llamaindex.ai/docs/api/classes/OpenAI)

[Edit on GitHub](https://github.com/run-llama/LlamaIndexTS/blob/main/apps/next/src/content/docs/llamaindex/modules/models/llms/index.mdx)

Last updated on 9/10/2025

[VoyageAI\\
\\
Previous Page](https://next.ts.llamaindex.ai/docs/llamaindex/modules/models/embeddings/voyageai) [Anthropic\\
\\
Next Page](https://next.ts.llamaindex.ai/docs/llamaindex/modules/models/llms/anthropic)

### On this page

[Installation](https://next.ts.llamaindex.ai/docs/llamaindex/modules/models/llms#installation) [Azure OpenAI](https://next.ts.llamaindex.ai/docs/llamaindex/modules/models/llms#azure-openai) [Local LLM](https://next.ts.llamaindex.ai/docs/llamaindex/modules/models/llms#local-llm) [Available LLMs](https://next.ts.llamaindex.ai/docs/llamaindex/modules/models/llms#available-llms) [API Reference](https://next.ts.llamaindex.ai/docs/llamaindex/modules/models/llms#api-reference)
