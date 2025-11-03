[Skip to content](https://developers.llamaindex.ai/typescript/workflows/#_top)

# LlamaIndex Workflows

LlamaIndex Workflows are a library for event-driven programming in JavaScript and TypeScript.
It provides a simple and lightweight orchestration solution for building complex workflows with minimal boilerplate.

It combines [event-driven](https://developers.llamaindex.ai/docs/workflows/api-reference/type-aliases/WorkflowEvent) programming, [async context](https://developers.llamaindex.ai/docs/workflows/api-reference/type-aliases/WorkflowContext) and [streaming](https://developers.llamaindex.ai/docs/workflows/api-reference/classes/WorkflowStream) to create a flexible and efficient way to handle data processing tasks.

The essential concepts of Workflows are:

- **Events**: are the core building blocks of Workflows. They represent data that flows through the system.
- **Handlers**: are functions that process events and can produce new events.
- **Context**: is the environment in which events are processed. It provides access to the event stream and allows sending new events.
- **Workflow**: is the collection of events, handlers, and context that define the processing logic.

## Getting Started

[Section titled "Getting Started"](https://developers.llamaindex.ai/typescript/workflows/#getting-started)

```

```

## First Example

[Section titled "First Example"](https://developers.llamaindex.ai/typescript/workflows/#first-example)

With [workflowEvent](https://developers.llamaindex.ai/docs/workflows/api-reference/type-aliases/WorkflowEvent) and [createWorkflow](https://developers.llamaindex.ai/docs/workflows/api-reference/functions/createWorkflow), you can create a simple workflow that processes events.

For example, imagine you want to create a workflow that uses OpenAI to generate a response to a user's message.

```

```

From here, the sky is the limit. You can implement [branching](https://developers.llamaindex.ai/docs/workflows/common_patterns/branching.mdx), [looping](https://developers.llamaindex.ai/docs/workflows/common_patterns/loops.mdx), [human-in-the-loop](https://developers.llamaindex.ai/docs/workflows/common_patterns/human_in_the_loop.mdx), [map-reduce](https://developers.llamaindex.ai/docs/workflows/common_patterns/map_reduce.mdx), and more!

## Architecture

[Section titled "Architecture"](https://developers.llamaindex.ai/typescript/workflows/#architecture)

Workflows are built around components like events, steps/handlers, context, and more. Learn more about these components [here](https://developers.llamaindex.ai/docs/workflows/api-reference/).

## Deployment

[Section titled "Deployment"](https://developers.llamaindex.ai/typescript/workflows/#deployment)

Workflows are designed to be run anywhere. Deploy in a server, a lambda function, an edge runtime, or a cloudflare function!

- [Hono Server](https://github.com/run-llama/workflows-ts/tree/main/demo/hono)
- [Express (Client + Server)](https://developers.llamaindex.ai/typescript/workflows/tutorials/express_agent/)
- [CloudFlare Function](https://github.com/run-llama/workflows-ts/tree/main/demo/cloudflare)

## Community

[Section titled "Community"](https://developers.llamaindex.ai/typescript/workflows/#community)

- [Discord](https://discord.gg/dGcwcsnxhU)
- [X (formerly Twitter)](https://x.com/llama_index)

Ask AI
