# Structured Outputs Parsing Helpers

The OpenAI API supports extracting JSON from the model with the `response_format` request param, for more details on the API, see [this guide](https://platform.openai.com/docs/guides/structured-outputs).

The SDK provides a `client.chat.completions.parse()` method which is a wrapper over the `client.chat.completions.create()` that
provides richer integrations with Python specific types & returns a `ParsedChatCompletion` object, which is a subclass of the standard `ChatCompletion` class.

## Auto-parsing response content with Pydantic models

You can pass a pydantic model to the `.parse()` method and the SDK will automatically convert the model
into a JSON schema, send it to the API and parse the response content back into the given model.

```python
from typing import List
from pydantic import BaseModel
from openai import OpenAI

class Step(BaseModel):
    explanation: str
    output: str

class MathResponse(BaseModel):
    steps: List[Step]
    final_answer: str

client = OpenAI()
completion = client.chat.completions.parse(
    model="gpt-4o-2024-08-06",
    messages=[
        {"role": "system", "content": "You are a helpful math tutor."},
        {"role": "user", "content": "solve 8x + 31 = 2"},
    ],
    response_format=MathResponse,
)

message = completion.choices[0].message
if message.parsed:
    print(message.parsed.steps)
    print("answer: ", message.parsed.final_answer)
else:
    print(message.refusal)
```

## Auto-parsing function tool calls

The `.parse()` method will also automatically parse `function` tool calls if:

- You use the `openai.pydantic_function_tool()` helper method
- You mark your tool schema with `"strict": True`

For example:

```python
from enum import Enum
from typing import List, Union
from pydantic import BaseModel
import openai

class Table(str, Enum):
    orders = "orders"
    customers = "customers"
    products = "products"

class Column(str, Enum):
    id = "id"
    status = "status"
    expected_delivery_date = "expected_delivery_date"
    delivered_at = "delivered_at"
    shipped_at = "shipped_at"
    ordered_at = "ordered_at"
    canceled_at = "canceled_at"

class Operator(str, Enum):
    eq = "="
    gt = ">"
    lt = "<"
    le = "<="
    ge = ">="
    ne = "!="

class OrderBy(str, Enum):
    asc = "asc"
    desc = "desc"

class DynamicValue(BaseModel):
    column_name: str

class Condition(BaseModel):
    column: str
    operator: Operator
    value: Union[str, int, DynamicValue]

class Query(BaseModel):
    table_name: Table
    columns: List[Column]
    conditions: List[Condition]
    order_by: OrderBy

client = openai.OpenAI()
completion = client.chat.completions.parse(
    model="gpt-4o-2024-08-06",
    messages=[
        {
            "role": "system",
            "content": "You are a helpful assistant. The current date is August 6, 2024. You help users query for the data they are looking for by calling the query function.",
        },
        {
            "role": "user",
            "content": "look up all my orders in may of last year that were fulfilled but not delivered on time",
        },
    ],
    tools=[
        openai.pydantic_function_tool(Query),
    ],
)

tool_call = (completion.choices[0].message.tool_calls or [])[0]
print(tool_call.function)
assert isinstance(tool_call.function.parsed_arguments, Query)
print(tool_call.function.parsed_arguments.table_name)
```

## Differences from `.create()`

The `chat.completions.parse()` method imposes some additional restrictions on it's usage that `chat.completions.create()` does not.

- If the completion completes with `finish_reason` set to `length` or `content_filter`, the `LengthFinishReasonError` / `ContentFilterFinishReasonError` errors will be raised.
- Only strict function tools can be passed, e.g. `{'type': 'function', 'function': {..., 'strict': True}}`

# Streaming Helpers

OpenAI supports streaming responses when interacting with the [Chat Completion](#chat-completions-api) & [Assistant](#assistant-streaming-api) APIs.

## Chat Completions API

The SDK provides a `.chat.completions.stream()` method that wraps the `.chat.completions.create(stream=True)` stream providing a more granular event API & automatic accumulation of each delta.

It also supports all aforementioned [parsing helpers](#structured-outputs-parsing-helpers).

Unlike `.create(stream=True)`, the `.stream()` method requires usage within a context manager to prevent accidental leakage of the response:

```python
from openai import AsyncOpenAI

client = AsyncOpenAI()

async with client.chat.completions.stream(
    model='gpt-4o-2024-08-06',
    messages=[...],
) as stream:
    async for event in stream:
        if event.type == 'content.delta':
            print(event.content, flush=True, end='')
```

When the context manager is entered, a `ChatCompletionStream` / `AsyncChatCompletionStream` instance is returned which, like `.create(stream=True)` is an iterator in the sync client and an async iterator in the async client. The full list of events that are yielded by the iterator are outlined [below](#chat-completions-events).

When the context manager exits, the response will be closed, however the `stream` instance is still available outside
the context manager.

For complete documentation on streaming events, methods, and the Assistant Streaming API, see the full helpers.md documentation.

# Polling Helpers

When interacting with the API some actions such as starting a Run and adding files to vector stores are asynchronous and take time to complete.
The SDK includes helper functions which will poll the status until it reaches a terminal state and then return the resulting object.
If an API method results in an action which could benefit from polling there will be a corresponding version of the
method ending in `_and_poll`.

All methods also allow you to set the polling frequency, how often the API is checked for an update, via a function argument ( `poll_interval_ms`).

The polling methods are:

```python
client.beta.threads.create_and_run_poll(...)
client.beta.threads.runs.create_and_poll(...)
client.beta.threads.runs.submit_tool_outputs_and_poll(...)
client.beta.vector_stores.files.upload_and_poll(...)
client.beta.vector_stores.files.create_and_poll(...)
client.beta.vector_stores.file_batches.create_and_poll(...)
client.beta.vector_stores.file_batches.upload_and_poll(...)
```

---

**Source:** [OpenAI Python SDK helpers.md](https://github.com/openai/openai-python/blob/main/helpers.md)
