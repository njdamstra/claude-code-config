[Skip to content](https://developers.llamaindex.ai/python/framework/getting_started/starter_example_local/#_top)

# Starter Tutorial (Using Local LLMs)

This tutorial will show you how to get started building agents with LlamaIndex. We'll start with a basic example and then show how to add RAG (Retrieval-Augmented Generation) capabilities.

We will use [`BAAI/bge-base-en-v1.5`](https://huggingface.co/BAAI/bge-base-en-v1.5) as our embedding model and `llama3.1 8B` served through `Ollama`.

## Setup

[Section titled "Setup"](https://developers.llamaindex.ai/python/framework/getting_started/starter_example_local/#setup)

Ollama is a tool to help you get set up with LLMs locally with minimal setup.

Follow the [README](https://github.com/jmorganca/ollama) to learn how to install it.

To download the Llama3 model just do `ollama pull llama3.1`.

**NOTE**: You will need a machine with at least ~32GB of RAM.

As explained in our [installation guide](https://developers.llamaindex.ai/python/framework/getting_started/installation), `llama-index` is actually a collection of packages. To run Ollama and Huggingface, we will need to install those integrations:

```

```

The package names spell out the imports, which is very helpful for remembering how to import them or install them!

```

```

More integrations are all listed on [https://llamahub.ai](https://llamahub.ai/).

## Basic Agent Example

[Section titled "Basic Agent Example"](https://developers.llamaindex.ai/python/framework/getting_started/starter_example_local/#basic-agent-example)

Let's start with a simple example using an agent that can perform basic multiplication by calling a tool. Create a file called `starter.py`:

```

```

This will output something like: `The answer to 1234 * 4567 is: 5,618,916.`

What happened is:

- The agent was given a question: `What is 1234 * 4567?`
- Under the hood, this question, plus the schema of the tools (name, docstring, and arguments) were passed to the LLM
- The agent selected the `multiply` tool and wrote the arguments to the tool
- The agent received the result from the tool and interpolated it into the final response

## Adding Chat History

[Section titled "Adding Chat History"](https://developers.llamaindex.ai/python/framework/getting_started/starter_example_local/#adding-chat-history)

The `AgentWorkflow` is also able to remember previous messages. This is contained inside the `Context` of the `AgentWorkflow`.

If the `Context` is passed in, the agent will use it to continue the conversation.

```

```

## Adding RAG Capabilities

[Section titled "Adding RAG Capabilities"](https://developers.llamaindex.ai/python/framework/getting_started/starter_example_local/#adding-rag-capabilities)

Now let's enhance our agent by adding the ability to search through documents. First, let's get some example data using our terminal:

```

```

Your directory structure should look like this now:

```
├── starter.py └── data    └── paul_graham_essay.txt
```

Now we can create a tool for searching through documents using LlamaIndex. By default, our `VectorStoreIndex` will use a `text-embedding-ada-002` embeddings from OpenAI to embed and retrieve the text.

Our modified `starter.py` should look like this:

```

```

The agent can now seamlessly switch between using the calculator and searching through documents to answer questions.

## Storing the RAG Index

[Section titled "Storing the RAG Index"](https://developers.llamaindex.ai/python/framework/getting_started/starter_example_local/#storing-the-rag-index)

To avoid reprocessing documents every time, you can persist the index to disk:

```

```

```

```

## What's Next?

[Section titled "What's Next?"](https://developers.llamaindex.ai/python/framework/getting_started/starter_example_local/#whats-next)

This is just the beginning of what you can do with LlamaIndex agents! You can:

- Add more tools to your agent
- Use different LLMs
- Customize the agent's behavior using system prompts
- Add streaming capabilities
- Implement human-in-the-loop workflows
- Use multiple agents to collaborate on tasks

Some helpful next links:

- See more advanced agent examples in our [Agent documentation](https://developers.llamaindex.ai/python/framework/understanding/agent)
- Learn more about [high-level concepts](https://developers.llamaindex.ai/python/framework/getting_started/concepts)
- Explore how to [customize things](https://developers.llamaindex.ai/python/framework/getting_started/faq)
- Check out the [component guides](https://developers.llamaindex.ai/python/framework/module_guides)

Ask AI
