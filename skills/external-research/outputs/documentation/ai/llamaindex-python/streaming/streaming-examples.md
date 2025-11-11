# LlamaIndex Python Streaming Examples

## Query Engine Streaming

[Skip to content](https://developers.llamaindex.ai/python/framework/module_guides/deploying/query_engine/streaming/#_top)

# Streaming

LlamaIndex supports streaming the response as it's being generated.
This allows you to start printing or processing the beginning of the response before the full response is finished.
This can drastically reduce the perceived latency of queries.

### Setup

[Section titled "Setup"](https://developers.llamaindex.ai/python/framework/module_guides/deploying/query_engine/streaming/#setup)

To enable streaming, you need to use an LLM that supports streaming.
Right now, streaming is supported by `OpenAI`, `HuggingFaceLLM`, and most LangChain LLMs (via `LangChainLLM`).

> Note: if streaming is not supported by the LLM you choose a `NotImplementedError` will be raised.

To configure query engine to use streaming using the high-level API, set `streaming=True` when building a query engine.

```python
query_engine = index.as_query_engine(streaming=True)
```

If you are using the low-level API to compose the query engine,
pass `streaming=True` when constructing the `Response Synthesizer`:

```python
synth = ResponseSynthesizer.from_args(streaming=True)
query_engine = RetrieverQueryEngine(retriever, response_synthesizer=synth)
```

### Streaming Response

[Section titled "Streaming Response"](https://developers.llamaindex.ai/python/framework/module_guides/deploying/query_engine/streaming/#streaming-response)

After properly configuring both the LLM and the query engine,
calling `query` now returns a `StreamingResponse` object.

```python
streaming_response = query_engine.query("What did the author do growing up?")
```

The response is returned immediately when the LLM call _starts_, without having to wait for the full completion.

> Note: In the case where the query engine makes multiple LLM calls, only the last LLM call will be streamed and the response is returned when the last LLM call starts.

You can obtain a `Generator` from the streaming response and iterate over the tokens as they arrive:

```python
for text in streaming_response.response_gen:
    print(text, end="")
```

Alternatively, if you just want to print the text as they arrive:

```python
streaming_response.print_response_stream()
```

See an [end-to-end example](https://developers.llamaindex.ai/python/examples/customization/streaming/simpleindexdemo-streaming)

---

## Agent Streaming

[Skip to content](https://developers.llamaindex.ai/python/framework/understanding/agent/streaming/#_top)

# Streaming output and events

In real-world use, agents can take a long time to run. Providing feedback to the user about the progress of the agent is critical, and streaming allows you to do that.

`AgentWorkflow` provides a set of pre-built events that you can use to stream output to the user. Let's take a look at how that's done.

First, we're going to introduce a new tool that takes some time to execute. In this case we'll use a web search tool called [Tavily](https://llamahub.ai/l/tools/llama-index-tools-tavily-research), which is available in LlamaHub.

```python
from llama_index.tools.tavily_research import TavilyToolSpec

tavily_tool = TavilyToolSpec(api_key=os.getenv("TAVILY_API_KEY"))
```

It requires an API key, which we're going to set in our `.env` file as `TAVILY_API_KEY` and retrieve using the `os.getenv` method. Let's bring in our imports:

```python
import os
from llama_index.core.agent import AgentWorkflow
from llama_index.llms.openai import OpenAI
from llama_index.core.workflow import Event
```

And initialize the tool:

```python
tavily_tool = TavilyToolSpec(api_key=os.getenv("TAVILY_API_KEY"))
```

Now we'll create an agent using that tool and an LLM that we initialized just like we did previously.

```python
agent = AgentWorkflow.from_tools(
    [tavily_tool],
    llm=OpenAI(model="gpt-4o"),
)
```

In previous examples, we've used `await` on the `workflow.run` method to get the final response from the agent. However, if we don't await the response, we get an asynchronous iterator back that we can iterate over to get the events as they come in. This iterator will return all sorts of events. We'll start with an `AgentStream` event, which contains the "delta" (the most recent change) to the output as it comes in. We'll need to import that event type:

```python
from llama_index.core.agent.workflow import AgentStream
```

And now we can run the workflow and look for events of that type to output:

```python
handler = agent.run(user_msg="What is the weather in San Francisco?")

async for ev in handler.stream_events():
    if isinstance(ev, AgentStream):
        print(ev.delta, end="", flush=True)
```

If you run this yourself, you will see the output arriving in chunks as the agent runs, returning something like this:

```
The current weather in San Francisco is partly cloudy with a temperature of 13.9°C (57.0°F).
```

`AgentStream` is just one of many events that `AgentWorkflow` emits as it runs. The others are:

- `AgentInput`: the full message object that begins the agent's execution
- `AgentOutput`: the response from the agent
- `ToolCall`: which tools were called and with what arguments
- `ToolCallResult`: the result of a tool call

You can see us filtering for more of these events in the [full code of this example](https://github.com/run-llama/python-agents-tutorial/blob/main/4_streaming.py).

Next you'll learn about how to get a [human in the loop](https://developers.llamaindex.ai/python/framework/understanding/agent/human_in_the_loop) to provide feedback to your agents.
