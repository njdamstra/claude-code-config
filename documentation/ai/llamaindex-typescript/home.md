[Skip to content](https://developers.llamaindex.ai/typescript/framework#_top)

# Welcome to LlamaIndex.TS

LlamaIndex.TS is a **framework for utilizing context engineering to build generative AI applications** with large language models. From rapid-prototyping RAG chatbots to deploying multi-agent workflows in production, LlamaIndex gives you everything you need — all in idiomatic TypeScript.

Built for modern JavaScript runtimes like Node.js **Node.js**, Deno **Deno**, Bun **Bun**, Cloudflare Workers **Cloudflare Workers**, and more.

[**Introduction** \\
Context engineering, agents & workflows — what do they mean?](https://developers.llamaindex.ai/typescript/framework#introduction) [**Use cases** \\
See what you can build with LlamaIndex.TS.](https://developers.llamaindex.ai/typescript/framework#use-cases) [**Getting started** \\
Your first app in 5 lines of code.](https://developers.llamaindex.ai/typescript/framework#getting-started) [**LlamaCloud** \\
Managed parsing, extraction & retrieval pipelines.](https://docs.cloud.llamaindex.ai/) [**Community** \\
Join thousands of builders on Discord, Twitter, and more.](https://developers.llamaindex.ai/typescript/framework#community) [**Related projects** \\
Connectors, demos & starter kits.](https://developers.llamaindex.ai/typescript/framework#related-projects)

## Introduction

[Section titled "Introduction"](https://developers.llamaindex.ai/typescript/framework#introduction)

### What are agents?

[Section titled "What are agents?"](https://developers.llamaindex.ai/typescript/framework#what-are-agents)

[Agents](https://developers.llamaindex.ai/typescript/framework/tutorials/agents/1_setup) are LLM-powered assistants that can reason, use external tools, and take actions to accomplish tasks such as research, data extraction, and automation.
LlamaIndex.TS provides foundational building blocks for creating and orchestrating these agents.

### What are workflows?

[Section titled "What are workflows?"](https://developers.llamaindex.ai/typescript/framework#what-are-workflows)

[Workflows](https://developers.llamaindex.ai/typescript/framework/tutorials/workflows) are multi-step, event-driven processes that combine agents, data connectors, and other tools to solve complex problems.
With LlamaIndex.TS you can chain together retrieval, generation, and tool-calling steps and then deploy the entire pipeline as a microservice.

### What is context engineering?

[Section titled "What is context engineering?"](https://developers.llamaindex.ai/typescript/framework#what-is-context-engineering)

LLMs come pre-trained on vast public corpora, but not on **your** private or domain-specific data.
Context engineering bridges that gap by injecting the right pieces of your data into the LLM prompt at the right time.
The most popular example is [Retrieval-Augmented Generation (RAG)](https://developers.llamaindex.ai/typescript/framework/getting_started/concepts), but the same idea powers agent memory, evaluation, extraction, summarisation, and more.

LlamaIndex.TS gives you:

- **Data connectors** to ingest from APIs, files, SQL, and dozens more sources.
- **Indexes & retrievers** to store and retrieve your data for LLM consumption.
- **Agents and Engines** to query and use chat+reasoning interfaces over your data.
- **Workflows** for fine-grained orchestration of your data and LLM-powered agents.
- **Observability** integrations so you can iterate with confidence.

You can learn more about these concepts in our [concepts guide](https://developers.llamaindex.ai/typescript/framework/getting_started/concepts).

## Use cases

[Section titled "Use cases"](https://developers.llamaindex.ai/typescript/framework#use-cases)

Popular scenarios include:

- [LLM-Powered Agents](https://developers.llamaindex.ai/typescript/framework/tutorials/agents/1_setup)
- [Indexing and Retrieval](https://developers.llamaindex.ai/typescript/framework/tutorials/rag)
- [Extracting Structured Data](https://developers.llamaindex.ai/typescript/framework/tutorials/structured_data_extraction)
- [Custom Orchestration with Workflows](https://developers.llamaindex.ai/typescript/framework/tutorials/workflows)

## Getting started

[Section titled "Getting started"](https://developers.llamaindex.ai/typescript/framework#getting-started)

The fastest way to get started is in StackBlitz below — no local setup required:

Llamaindexts Examples Example - StackBlitz

Project

Search

Ports in use

Settings

README.md

More Actions…

1

2

3

# LlamaIndexTS Examples

This package contains several

Enter to Rename, Shift+Enter to Preview

Terminal\_1

#### Terminal\_1

[Astro Basics\\
\\
Node.js](https://stackblitz.com/fork/github/withastro/astro/tree/latest/examples/basics?file=README.md&title=Astro%20Starter%20Kit:%20Basics) [Next.js\\
\\
Node.js](https://stackblitz.com/fork/github/stackblitz/starters/tree/main/nextjs?title=Next.js%20Starter&description=The%20React%20framework%20for%20production) [Nuxt\\
\\
Node.js](https://stackblitz.com/fork/github/nuxt/starter/tree/v3-stackblitz) [React\\
\\
TypeScript](https://stackblitz.com/fork/github/vitejs/vite/tree/main/packages/create-vite/template-react-ts?file=index.html&terminal=dev) [Vanilla\\
\\
JavaScript](https://stackblitz.com/fork/github/vitejs/vite/tree/main/packages/create-vite/template-vanilla?file=index.html&terminal=dev) [Vanilla\\
\\
TypeScript](https://stackblitz.com/fork/github/vitejs/vite/tree/main/packages/create-vite/template-vanilla-ts?file=index.html&terminal=dev) [Static\\
\\
HTML/JS/CSS](https://stackblitz.com/fork/github/stackblitz/starters/tree/main/static?title=Static%20Starter&description=HTML/CSS/JS%20Starter&file=script.js,styles.css,index.html&terminalHeight=10) [Node.js\\
\\
Blank project](https://stackblitz.com/fork/github/stackblitz/starters/tree/main/node?title=node.new%20Starter&description=Starter%20project%20for%20Node.js%2C%20a%20JavaScript%20runtime%20built%20on%20Chrome%27s%20V8%20JavaScript%20engine) [Angular\\
\\
TypeScript](https://stackblitz.com/fork/github/stackblitz/starters/tree/main/angular?template=node&title=Angular%20Starter&description=An%20angular-cli%20project%20based%20on%20%40angular%2Fanimations%2C%20%40angular%2Fcommon%2C%20%40angular%2Fcompiler%2C%20%40angular%2Fcore%2C%20%40angular%2Fforms%2C%20%40angular%2Fplatform-browser%2C%20%40angular%2Fplatform-browser-dynamic%2C%20%40angular%2Frouter%2C%20core-js%2C%20rxjs%2C%20tslib%20and%20zone.js) [Vue\\
\\
JavaScript](https://stackblitz.com/fork/github/vitejs/vite/tree/main/packages/create-vite/template-vue?file=index.html&terminal=dev) [WebContainer API\\
\\
Node.js](https://stackblitz.com/fork/github/stackblitz/webcontainer-api-starter)

# Publish a package

Are you trying to publish ``?

CancelConfirm

# Allow access to localhost resource

Request to:

More information

```
Method: undefined
Headers:
```

Warning

Allowing access to your localhost resources can lead to security issues such as unwanted request access or data leaks through your localhost.

Do not ask me again

BlockAllow

# Out of memory error

This browser tab is running out of memory. Free up memory by closing other StackBlitz tabs and then refresh the page.

OK [Learn more](https://developer.stackblitz.com/codeflow/working-in-codeflow-ide#out-of-memory-error)

Want to learn more? We have several tutorials to get you started:

- [Installation + Runtime Guide](https://developers.llamaindex.ai/typescript/framework/getting_started/installation)
- [Create your first agent](https://developers.llamaindex.ai/typescript/framework/tutorials/agents/1_setup)
- [Learn how to index data and chat with it](https://developers.llamaindex.ai/typescript/framework/tutorials/rag)
- [Learn how to write your own workflows and agents](https://developers.llamaindex.ai/typescript/framework/tutorials/workflows)

* * *

## LlamaCloud

[Section titled "LlamaCloud"](https://developers.llamaindex.ai/typescript/framework#llamacloud)

Need an end-to-end managed pipeline? Check out **[LlamaCloud](https://cloud.llamaindex.ai/)**: best-in-class document parsing (LlamaParse), extraction (LlamaExtract), and indexing services with generous free tiers.

* * *

## Community

[Section titled "Community"](https://developers.llamaindex.ai/typescript/framework#community)

- [Twitter](https://twitter.com/llama_index)
- [Discord](https://discord.gg/dGcwcsnxhU)
- [LinkedIn](https://www.linkedin.com/company/llamaindex/)

We 💜 contributors! View our [contributing guide](https://github.com/run-llama/LlamaIndexTS/blob/main/CONTRIBUTING.md) to get started.

## Related projects

[Section titled "Related projects"](https://developers.llamaindex.ai/typescript/framework#related-projects)

- [Python framework GitHub](https://github.com/run-llama/llama_index)
- [Python docs](https://docs.llamaindex.ai/)
- [create-llama](https://www.npmjs.com/package/create-llama) — scaffold a new project in seconds!
- [UI Components](https://ui.llamaindex.ai/) — build chat applications with our Next.js components.

Ask AI
