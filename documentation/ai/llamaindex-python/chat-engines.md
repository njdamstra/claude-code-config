[Skip to content](https://developers.llamaindex.ai/python/examples/chat_engine/chat_engine_context/#_top)

# Chat Engine - Context Mode

ContextChatEngine is a simple chat mode built on top of a retriever over your data.

For each chat interaction:

- first retrieve text from the index using the user message
- set the retrieved text as context in the system prompt
- return an answer to the user message

This approach is simple, and works for questions directly related to the knowledge base and general interactions.

If you're opening this Notebook on colab, you will probably need to install LlamaIndex 🦙.

```

```

```

```

## Download Data

[Section titled "Download Data"](https://developers.llamaindex.ai/python/examples/chat_engine/chat_engine_context/#download-data)

```

```

## Get started in 5 lines of code

[Section titled "Get started in 5 lines of code"](https://developers.llamaindex.ai/python/examples/chat_engine/chat_engine_context/#get-started-in-5-lines-of-code)

Load data and build index

```

```

```

```

Configure chat engine

Since the context retrieved can take up a large amount of the available LLM context, let's ensure we configure a smaller limit to the chat history!

```

```

Chat with your data

```

```

```

```

```

```

Ask a follow up question

```

```

```

```

```

```

```

```

```

```

```

```

Reset conversation state

```

```

```

```

```

```

```

```

## Streaming Support

[Section titled "Streaming Support"](https://developers.llamaindex.ai/python/examples/chat_engine/chat_engine_context/#streaming-support)

```

```

```

```

```

```

```

```

Ask AI
