# LlamaIndex TypeScript Streaming

## LlamaIndex Workflows

LlamaIndex Workflows are a library for event-driven programming in JavaScript and TypeScript.
It provides a simple and lightweight orchestration solution for building complex workflows with minimal boilerplate.

It combines [event-driven](https://developers.llamaindex.ai/docs/workflows/api-reference/type-aliases/WorkflowEvent) programming, [async context](https://developers.llamaindex.ai/docs/workflows/api-reference/type-aliases/WorkflowContext) and [streaming](https://developers.llamaindex.ai/docs/workflows/api-reference/classes/WorkflowStream) to create a flexible and efficient way to handle data processing tasks.

The essential concepts of Workflows are:

- **Events**: are the core building blocks of Workflows. They represent data that flows through the system.
- **Handlers**: are functions that process events and can produce new events.
- **Context**: is the environment in which events are processed. It provides access to the event stream and allows sending new events.
- **Workflow**: is the collection of events, handlers, and context that define the processing logic.

## Getting Started

```bash
npm install @llamaindex/workflow-core
```

## First Example

With [workflowEvent](https://developers.llamaindex.ai/docs/workflows/api-reference/type-aliases/WorkflowEvent) and [createWorkflow](https://developers.llamaindex.ai/docs/workflows/api-reference/functions/createWorkflow), you can create a simple workflow that processes events.

For example, imagine you want to create a workflow that uses OpenAI to generate a response to a user's message.

```typescript
import { createWorkflow, workflowEvent } from "@llamaindex/workflow-core";
import { OpenAI } from "@llamaindex/openai";

const startEvent = workflowEvent<string>();
const stopEvent = workflowEvent<string>();

const workflow = createWorkflow();

workflow.handle([startEvent], async (context, start) => {
  const { sendEvent } = context;
  const llm = new OpenAI({ model: "gpt-4" });

  const response = await llm.chat({
    messages: [{ role: "user", content: start.data }]
  });

  return stopEvent.with(response.message.content);
});

// Run the workflow
const { stream, sendEvent } = workflow.createContext();
sendEvent(startEvent.with("Tell me a joke"));

for await (const event of stream) {
  if (stopEvent.include(event)) {
    console.log(event.data);
    break;
  }
}
```

## Streaming in TypeScript Workflows

The streaming capabilities make it perfect for:
- Building real-time applications
- Handling large datasets incrementally
- Creating responsive UIs that update as data arrives
- Processing events asynchronously

### Event-Driven Streaming

Workflows are built around streams of events. Each handler can:
- Receive events from the stream
- Process them asynchronously
- Emit new events back to the stream

### Stream Methods

```typescript
const { stream, sendEvent } = workflow.createContext();

// Filter events
const filtered = stream.filter(stopEvent);

// Take until condition
const limited = stream.until(stopEvent);

// Convert to array
const allEvents = await stream.toArray();

// Iterate over events
for await (const event of stream) {
  // Process event
}
```

## Architecture

Workflows are built around components like events, steps/handlers, context, and more. Learn more about these components [here](https://developers.llamaindex.ai/docs/workflows/api-reference/).

## Deployment

Workflows are designed to be run anywhere. Deploy in a server, a lambda function, an edge runtime, or a cloudflare function!

- [Hono Server](https://github.com/run-llama/workflows-ts/tree/main/demo/hono)
- [Express (Client + Server)](https://developers.llamaindex.ai/typescript/workflows/tutorials/express_agent/)
- [CloudFlare Function](https://github.com/run-llama/workflows-ts/tree/main/demo/cloudflare)

## Key Features

- **async-first** - workflows are built around python's async functionality
- **event-driven** - workflows consist of steps and events
- **state management** - each run of a workflow is self-contained
- **observability** - workflows are automatically instrumented for observability

## Related Resources

- [GitHub - run-llama/workflows-ts](https://github.com/run-llama/workflows-ts)
- [TypeScript Workflows Documentation](https://developers.llamaindex.ai/typescript/workflows/)
- [Python Workflows](https://github.com/run-llama/workflows-py)
