[Skip to content](https://developers.llamaindex.ai/python/examples/agent/agent_workflow_research_assistant#_top)

# Agent Workflow + Research Assistant using AgentQL

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/run-llama/llama_index/blob/main/docs/examples/agent/agent_workflow_research_assistant.ipynb)

In this tutorial, we will use an `AgentWorkflow` to build a research assistant OpenAI agent using tools including AgentQL's browser tools, Playwright's tools, and the DuckDuckGoSearch tool. This agent performs a web search to find relevant resources for a research topic, interacts with them, and extracts key metadata (e.g., title, author, publication details, and abstract) from those resources.

## Initial Setup

[Section titled "Initial Setup"](https://developers.llamaindex.ai/python/examples/agent/agent_workflow_research_assistant#initial-setup)

The main things we need to get started are:

- [OpenAI's API key](https://platform.openai.com/api-keys)
- [AgentQL's API key](https://dev.agentql.com/api-keys)

If you're opening this Notebook on colab, you will probably need to install LlamaIndex 🦙 and Playwright.

```

```

Store your `OPENAI_API_KEY` and `AGENTQL_API_KEY` keys in [Google Colab's secrets](https://medium.com/@parthdasawant/how-to-use-secrets-in-google-colab-450c38e3ec75).

```

```

Let's start by enabling async for the notebook since an online environment like Google Colab only supports an asynchronous version of AgentQL.

```

```

Create an `async_browser` instance and select the [Playwright tools](https://docs.llamaindex.ai/en/latest/api_reference/tools/playwright/) you want to use.

```

```

Import the [AgentQL browser tools](https://docs.llamaindex.ai/en/latest/api_reference/tools/agentql/) and [DuckDuckGo full search tool](https://docs.llamaindex.ai/en/latest/api_reference/tools/duckduckgo/).

```

```

We can now create an `AgentWorkFlow` that uses the tools that we have imported.

```

```

`AgentWorkflow` also supports streaming, which works by using the handler that is returned from the workflow. To stream the LLM output, you can use the `AgentStream` events.

```

```

```

```

Ask AI
