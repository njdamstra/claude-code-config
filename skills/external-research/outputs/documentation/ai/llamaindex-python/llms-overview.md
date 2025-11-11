[Skip to content](https://developers.llamaindex.ai/python/framework-api-reference/llms#llama_index.core.llms.llm.LLM)

# Index

## LLM [\\#](https://developers.llamaindex.ai/python/framework-api-reference/llms\\#llama_index.core.llms.llm.LLM "Permanent link")

Bases: `BaseLLM`

The LLM class is the main class for interacting with language models.

Attributes:

| Name | Type | Description |
| --- | --- | --- |
| `system_prompt` | `Optional[str]` | System prompt for LLM calls. |
| `messages_to_prompt` | `Callable` | Function to convert a list of messages to an LLM prompt. |
| `completion_to_prompt` | `Callable` | Function to convert a completion to an LLM prompt. |
| `output_parser` | `Optional[ [BaseOutputParser](https://developers.llamaindex.ai/python/output_parsers/#llama_index.core.types.BaseOutputParser "BaseOutputParser (llama_index.core.types.BaseOutputParser)")]` | Output parser to parse, validate, and correct errors programmatically. |
| `pydantic_program_mode` | `PydanticProgramMode` | Pydantic program mode to use for structured prediction. |

### metadata`abstractmethod``property`[\\#](https://developers.llamaindex.ai/python/framework-api-reference/llms\\#llama_index.core.llms.llm.LLM.metadata "Permanent link")

```
metadata: LLMMetadata

```

LLM metadata.

Returns:

| Name | Type | Description |
| --- | --- | --- |
| `LLMMetadata` | `LLMMetadata` | LLM metadata containing various information about the LLM. |

### structured\_predict [\\#](https://developers.llamaindex.ai/python/framework-api-reference/llms\\#llama_index.core.llms.llm.LLM.structured_predict "Permanent link")

```
structured_predict(
    output_cls: Type[Model],
    prompt: [PromptTemplate](https://developers.llamaindex.ai/python/prompts/#llama_index.core.prompts.PromptTemplate "PromptTemplate (llama_index.core.prompts.PromptTemplate)"),
    llm_kwargs: Optional[Dict[str, Any]] = None,
    **prompt_args: Any
) -> Model

```

Structured predict.

Parameters:

| Name | Type | Description | Default |
| --- | --- | --- | --- |
| `output_cls` | `BaseModel` | Output class to use for structured prediction. | _required_ |
| `prompt` | `[PromptTemplate](https://developers.llamaindex.ai/python/prompts/#llama_index.core.prompts.PromptTemplate "PromptTemplate (llama_index.core.prompts.PromptTemplate)")` | Prompt template to use for structured prediction. | _required_ |
| `llm_kwargs` | `Optional[Dict[str, Any]]` | Arguments that are passed down to the LLM invoked by the program. | `None` |
| `prompt_args` | `Any` | Additional arguments to format the prompt with. | `{}` |

Returns:

| Name | Type | Description |
| --- | --- | --- |
| `BaseModel` | `Model` | The structured prediction output. |

Examples:

```
from pydantic import BaseModel

class Test(BaseModel):
    \"\"\"My test class.\"\"\"
    name: str

from llama_index.core.prompts import PromptTemplate

prompt = PromptTemplate("Please predict a Test with a random name related to {topic}.")
output = llm.structured_predict(Test, prompt, topic="cats")
print(output.name)

```

### astructured\_predict`async`[\\#](https://developers.llamaindex.ai/python/framework-api-reference/llms\\#llama_index.core.llms.llm.LLM.astructured_predict "Permanent link")

```
astructured_predict(
    output_cls: Type[Model],
    prompt: [PromptTemplate](https://developers.llamaindex.ai/python/prompts/#llama_index.core.prompts.PromptTemplate "PromptTemplate (llama_index.core.prompts.PromptTemplate)"),
    llm_kwargs: Optional[Dict[str, Any]] = None,
    **prompt_args: Any
) -> Model

```

Async Structured predict.

Parameters:

| Name | Type | Description | Default |
| --- | --- | --- | --- |
| `output_cls` | `BaseModel` | Output class to use for structured prediction. | _required_ |
| `prompt` | `[PromptTemplate](https://developers.llamaindex.ai/python/prompts/#llama_index.core.prompts.PromptTemplate "PromptTemplate (llama_index.core.prompts.PromptTemplate)")` | Prompt template to use for structured prediction. | _required_ |
| `llm_kwargs` | `Optional[Dict[str, Any]]` | Arguments that are passed down to the LLM invoked by the program. | `None` |
| `prompt_args` | `Any` | Additional arguments to format the prompt with. | `{}` |

Returns:

| Name | Type | Description |
| --- | --- | --- |
| `BaseModel` | `Model` | The structured prediction output. |

Examples:

```
from pydantic import BaseModel

class Test(BaseModel):
    \"\"\"My test class.\"\"\"
    name: str

from llama_index.core.prompts import PromptTemplate

prompt = PromptTemplate("Please predict a Test with a random name related to {topic}.")
output = await llm.astructured_predict(Test, prompt, topic="cats")
print(output.name)

```

### stream\_structured\_predict [\\#](https://developers.llamaindex.ai/python/framework-api-reference/llms\\#llama_index.core.llms.llm.LLM.stream_structured_predict "Permanent link")

```
stream_structured_predict(
    output_cls: Type[Model],
    prompt: [PromptTemplate](https://developers.llamaindex.ai/python/prompts/#llama_index.core.prompts.PromptTemplate "PromptTemplate (llama_index.core.prompts.PromptTemplate)"),
    llm_kwargs: Optional[Dict[str, Any]] = None,
    **prompt_args: Any
) -> Generator[Union[Model, FlexibleModel], None, None]

```

Stream Structured predict.

Parameters:

| Name | Type | Description | Default |
| --- | --- | --- | --- |
| `output_cls` | `BaseModel` | Output class to use for structured prediction. | _required_ |
| `prompt` | `[PromptTemplate](https://developers.llamaindex.ai/python/prompts/#llama_index.core.prompts.PromptTemplate "PromptTemplate (llama_index.core.prompts.PromptTemplate)")` | Prompt template to use for structured prediction. | _required_ |
| `llm_kwargs` | `Optional[Dict[str, Any]]` | Arguments that are passed down to the LLM invoked by the program. | `None` |
| `prompt_args` | `Any` | Additional arguments to format the prompt with. | `{}` |

Returns:

| Name | Type | Description |
| --- | --- | --- |
| `Generator` | `None` | A generator returning partial copies of the model or list of models. |

Examples:

```
from pydantic import BaseModel

class Test(BaseModel):
    \"\"\"My test class.\"\"\"
    name: str

from llama_index.core.prompts import PromptTemplate

prompt = PromptTemplate("Please predict a Test with a random name related to {topic}.")
stream_output = llm.stream_structured_predict(Test, prompt, topic="cats")
for partial_output in stream_output:
    # stream partial outputs until completion
    print(partial_output.name)

```

### astream\_structured\_predict`async`[\\#](https://developers.llamaindex.ai/python/framework-api-reference/llms\\#llama_index.core.llms.llm.LLM.astream_structured_predict "Permanent link")

```
astream_structured_predict(
    output_cls: Type[Model],
    prompt: [PromptTemplate](https://developers.llamaindex.ai/python/prompts/#llama_index.core.prompts.PromptTemplate "PromptTemplate (llama_index.core.prompts.PromptTemplate)"),
    llm_kwargs: Optional[Dict[str, Any]] = None,
    **prompt_args: Any
) -> AsyncGenerator[Union[Model, FlexibleModel], None]

```

Async Stream Structured predict.

Parameters:

| Name | Type | Description | Default |
| --- | --- | --- | --- |
| `output_cls` | `BaseModel` | Output class to use for structured prediction. | _required_ |
| `prompt` | `[PromptTemplate](https://developers.llamaindex.ai/python/prompts/#llama_index.core.prompts.PromptTemplate "PromptTemplate (llama_index.core.prompts.PromptTemplate)")` | Prompt template to use for structured prediction. | _required_ |
| `llm_kwargs` | `Optional[Dict[str, Any]]` | Arguments that are passed down to the LLM invoked by the program. | `None` |
| `prompt_args` | `Any` | Additional arguments to format the prompt with. | `{}` |

Returns:

| Name | Type | Description |
| --- | --- | --- |
| `Generator` | `AsyncGenerator[Union[Model, FlexibleModel], None]` | A generator returning partial copies of the model or list of models. |

Examples:

```
from pydantic import BaseModel

class Test(BaseModel):
    \"\"\"My test class.\"\"\"
    name: str

from llama_index.core.prompts import PromptTemplate

prompt = PromptTemplate("Please predict a Test with a random name related to {topic}.")
stream_output = await llm.astream_structured_predict(Test, prompt, topic="cats")
async for partial_output in stream_output:
    # stream partial outputs until completion
    print(partial_output.name)

```

### predict [\\#](https://developers.llamaindex.ai/python/framework-api-reference/llms\\#llama_index.core.llms.llm.LLM.predict "Permanent link")

```
predict(
    prompt: [BasePromptTemplate](https://developers.llamaindex.ai/python/prompts/#llama_index.core.prompts.BasePromptTemplate "BasePromptTemplate (llama_index.core.prompts.BasePromptTemplate)"), **prompt_args: Any
) -> str

```

Predict for a given prompt.

Parameters:

| Name | Type | Description | Default |
| --- | --- | --- | --- |
| `prompt` | `[BasePromptTemplate](https://developers.llamaindex.ai/python/prompts/#llama_index.core.prompts.BasePromptTemplate "BasePromptTemplate (llama_index.core.prompts.BasePromptTemplate)")` | The prompt to use for prediction. | _required_ |
| `prompt_args` | `Any` | Additional arguments to format the prompt with. | `{}` |

Returns:

| Name | Type | Description |
| --- | --- | --- |
| `str` | `str` | The prediction output. |

Examples:

```
from llama_index.core.prompts import PromptTemplate

prompt = PromptTemplate("Please write a random name related to {topic}.")
output = llm.predict(prompt, topic="cats")
print(output)

```

### stream [\\#](https://developers.llamaindex.ai/python/framework-api-reference/llms\\#llama_index.core.llms.llm.LLM.stream "Permanent link")

```
stream(
    prompt: [BasePromptTemplate](https://developers.llamaindex.ai/python/prompts/#llama_index.core.prompts.BasePromptTemplate "BasePromptTemplate (llama_index.core.prompts.BasePromptTemplate)"), **prompt_args: Any
) -> TokenGen

```

Stream predict for a given prompt.

Parameters:

| Name | Type | Description | Default |
| --- | --- | --- | --- |
| `prompt` | `[BasePromptTemplate](https://developers.llamaindex.ai/python/prompts/#llama_index.core.prompts.BasePromptTemplate "BasePromptTemplate (llama_index.core.prompts.BasePromptTemplate)")` | The prompt to use for prediction. | _required_ |
| `prompt_args` | `Any` | Additional arguments to format the prompt with. | `{}` |

Yields:

| Name | Type | Description |
| --- | --- | --- |
| `str` | `TokenGen` | Each streamed token. |

Examples:

```
from llama_index.core.prompts import PromptTemplate

prompt = PromptTemplate("Please write a random name related to {topic}.")
gen = llm.stream(prompt, topic="cats")
for token in gen:
    print(token, end="", flush=True)

```

### apredict`async`[\\#](https://developers.llamaindex.ai/python/framework-api-reference/llms\\#llama_index.core.llms.llm.LLM.apredict "Permanent link")

```
apredict(
    prompt: [BasePromptTemplate](https://developers.llamaindex.ai/python/prompts/#llama_index.core.prompts.BasePromptTemplate "BasePromptTemplate (llama_index.core.prompts.BasePromptTemplate)"), **prompt_args: Any
) -> str

```

Async Predict for a given prompt.

Parameters:

| Name | Type | Description | Default |
| --- | --- | --- | --- |
| `prompt` | `[BasePromptTemplate](https://developers.llamaindex.ai/python/prompts/#llama_index.core.prompts.BasePromptTemplate "BasePromptTemplate (llama_index.core.prompts.BasePromptTemplate)")` | The prompt to use for prediction. | _required_ |
| `prompt_args` | `Any` | Additional arguments to format the prompt with. | `{}` |

Returns:

| Name | Type | Description |
| --- | --- | --- |
| `str` | `str` | The prediction output. |

Examples:

```
from llama_index.core.prompts import PromptTemplate

prompt = PromptTemplate("Please write a random name related to {topic}.")
output = await llm.apredict(prompt, topic="cats")
print(output)

```

### astream`async`[\\#](https://developers.llamaindex.ai/python/framework-api-reference/llms\\#llama_index.core.llms.llm.LLM.astream "Permanent link")

```
astream(
    prompt: [BasePromptTemplate](https://developers.llamaindex.ai/python/prompts/#llama_index.core.prompts.BasePromptTemplate "BasePromptTemplate (llama_index.core.prompts.BasePromptTemplate)"), **prompt_args: Any
) -> TokenAsyncGen

```

Async stream predict for a given prompt.

prompt (BasePromptTemplate):
The prompt to use for prediction.
prompt\_args (Any):
Additional arguments to format the prompt with.

Yields:

| Name | Type | Description |
| --- | --- | --- |
| `str` | `TokenAsyncGen` | An async generator that yields strings of tokens. |

Examples:

```
from llama_index.core.prompts import PromptTemplate

prompt = PromptTemplate("Please write a random name related to {topic}.")
gen = await llm.astream(prompt, topic="cats")
async for token in gen:
    print(token, end="", flush=True)

```

### predict\_and\_call [\\#](https://developers.llamaindex.ai/python/framework-api-reference/llms\\#llama_index.core.llms.llm.LLM.predict_and_call "Permanent link")

```
predict_and_call(
    tools: List[[BaseTool](https://developers.llamaindex.ai/python/tools/#llama_index.core.tools.types.BaseTool "BaseTool (llama_index.core.tools.types.BaseTool)")],
    user_msg: Optional[Union[str, [ChatMessage](https://developers.llamaindex.ai/python/framework-api-reference/llms#llama_index.core.base.llms.types.ChatMessage "ChatMessage (llama_index.core.base.llms.types.ChatMessage)")]] = None,
    chat_history: Optional[List[[ChatMessage](https://developers.llamaindex.ai/python/framework-api-reference/llms#llama_index.core.base.llms.types.ChatMessage "ChatMessage (llama_index.core.base.llms.types.ChatMessage)")]] = None,
    verbose: bool = False,
    **kwargs: Any
) -> [AgentChatResponse](https://developers.llamaindex.ai/python/chat_engines/#llama_index.core.chat_engine.types.AgentChatResponse "AgentChatResponse            dataclass    (llama_index.core.chat_engine.types.AgentChatResponse)")

```

Predict and call the tool.

By default uses a ReAct agent to do tool calling (through text prompting),
but function calling LLMs will implement this differently.

### apredict\_and\_call`async`[\\#](https://developers.llamaindex.ai/python/framework-api-reference/llms\\#llama_index.core.llms.llm.LLM.apredict_and_call "Permanent link")

```
apredict_and_call(
    tools: List[[BaseTool](https://developers.llamaindex.ai/python/tools/#llama_index.core.tools.types.BaseTool "BaseTool (llama_index.core.tools.types.BaseTool)")],
    user_msg: Optional[Union[str, [ChatMessage](https://developers.llamaindex.ai/python/framework-api-reference/llms#llama_index.core.base.llms.types.ChatMessage "ChatMessage (llama_index.core.base.llms.types.ChatMessage)")]] = None,
    chat_history: Optional[List[[ChatMessage](https://developers.llamaindex.ai/python/framework-api-reference/llms#llama_index.core.base.llms.types.ChatMessage "ChatMessage (llama_index.core.base.llms.types.ChatMessage)")]] = None,
    verbose: bool = False,
    **kwargs: Any
) -> [AgentChatResponse](https://developers.llamaindex.ai/python/chat_engines/#llama_index.core.chat_engine.types.AgentChatResponse "AgentChatResponse            dataclass    (llama_index.core.chat_engine.types.AgentChatResponse)")

```

Predict and call the tool.

### as\_structured\_llm [\\#](https://developers.llamaindex.ai/python/framework-api-reference/llms\\#llama_index.core.llms.llm.LLM.as_structured_llm "Permanent link")

```
as_structured_llm(
    output_cls: Type[BaseModel], **kwargs: Any
) -> StructuredLLM

```

Return a structured LLM around a given object.

### class\_name`classmethod`[\\#](https://developers.llamaindex.ai/python/framework-api-reference/llms\\#llama_index.core.llms.llm.LLM.class_name "Permanent link")

```
class_name() -> str

```

Get the class name, used as a unique ID in serialization.

This provides a key that makes serialization robust against actual class
name changes.

### convert\_chat\_messages [\\#](https://developers.llamaindex.ai/python/framework-api-reference/llms\\#llama_index.core.llms.llm.LLM.convert_chat_messages "Permanent link")

```
convert_chat_messages(
    messages: Sequence[[ChatMessage](https://developers.llamaindex.ai/python/framework-api-reference/llms#llama_index.core.base.llms.types.ChatMessage "ChatMessage (llama_index.core.base.llms.types.ChatMessage)")],
) -> List[Any]

```

Convert chat messages to an LLM specific message format.

### chat`abstractmethod`[\\#](https://developers.llamaindex.ai/python/framework-api-reference/llms\\#llama_index.core.llms.llm.LLM.chat "Permanent link")

```
chat(
    messages: Sequence[[ChatMessage](https://developers.llamaindex.ai/python/framework-api-reference/llms#llama_index.core.base.llms.types.ChatMessage "ChatMessage (llama_index.core.base.llms.types.ChatMessage)")], **kwargs: Any
) -> [ChatResponse](https://developers.llamaindex.ai/python/framework-api-reference/llms#llama_index.core.base.llms.types.ChatResponse "ChatResponse (llama_index.core.base.llms.types.ChatResponse)")

```

Chat endpoint for LLM.

Parameters:

| Name | Type | Description | Default |
| --- | --- | --- | --- |
| `messages` | `Sequence[ [ChatMessage](https://developers.llamaindex.ai/python/framework-api-reference/llms#llama_index.core.base.llms.types.ChatMessage "ChatMessage (llama_index.core.base.llms.types.ChatMessage)")]` | Sequence of chat messages. | _required_ |
| `kwargs` | `Any` | Additional keyword arguments to pass to the LLM. | `{}` |

Returns:

| Name | Type | Description |
| --- | --- | --- |
| `ChatResponse` | `[ChatResponse](https://developers.llamaindex.ai/python/framework-api-reference/llms#llama_index.core.base.llms.types.ChatResponse "ChatResponse (llama_index.core.base.llms.types.ChatResponse)")` | Chat response from the LLM. |

Examples:

```
from llama_index.core.llms import ChatMessage

response = llm.chat([ChatMessage(role="user", content="Hello")])
print(response.content)

```

### complete`abstractmethod`[\\#](https://developers.llamaindex.ai/python/framework-api-reference/llms\\#llama_index.core.llms.llm.LLM.complete "Permanent link")

```
complete(
    prompt: str, formatted: bool = False, **kwargs: Any
) -> [CompletionResponse](https://developers.llamaindex.ai/python/framework-api-reference/llms#llama_index.core.base.llms.types.CompletionResponse "CompletionResponse (llama_index.core.base.llms.types.CompletionResponse)")

```

Completion endpoint for LLM.

If the LLM is a chat model, the prompt is transformed into a single `user` message.

Parameters:

| Name | Type | Description | Default |
| --- | --- | --- | --- |
| `prompt` | `str` | Prompt to send to the LLM. | _required_ |
| `formatted` | `bool` | Whether the prompt is already formatted for the LLM, by default False. | `False` |
| `kwargs` | `Any` | Additional keyword arguments to pass to the LLM. | `{}` |

Returns:

| Name | Type | Description |
| --- | --- | --- |
| `CompletionResponse` | `[CompletionResponse](https://developers.llamaindex.ai/python/framework-api-reference/llms#llama_index.core.base.llms.types.CompletionResponse "CompletionResponse (llama_index.core.base.llms.types.CompletionResponse)")` | Completion response from the LLM. |

Examples:

```
response = llm.complete("your prompt")
print(response.text)

```

### stream\_chat`abstractmethod`[\\#](https://developers.llamaindex.ai/python/framework-api-reference/llms\\#llama_index.core.llms.llm.LLM.stream_chat "Permanent link")

```
stream_chat(
    messages: Sequence[[ChatMessage](https://developers.llamaindex.ai/python/framework-api-reference/llms#llama_index.core.base.llms.types.ChatMessage "ChatMessage (llama_index.core.base.llms.types.ChatMessage)")], **kwargs: Any
) -> ChatResponseGen

```

Streaming chat endpoint for LLM.

Parameters:

| Name | Type | Description | Default |
| --- | --- | --- | --- |
| `messages` | `Sequence[ [ChatMessage](https://developers.llamaindex.ai/python/framework-api-reference/llms#llama_index.core.base.llms.types.ChatMessage "ChatMessage (llama_index.core.base.llms.types.ChatMessage)")]` | Sequence of chat messages. | _required_ |
| `kwargs` | `Any` | Additional keyword arguments to pass to the LLM. | `{}` |

Yields:

| Name | Type | Description |
| --- | --- | --- |
| `ChatResponse` | `ChatResponseGen` | A generator of ChatResponse objects, each containing a new token of the response. |

Examples:

```
from llama_index.core.llms import ChatMessage

gen = llm.stream_chat([ChatMessage(role="user", content="Hello")])
for response in gen:
    print(response.delta, end="", flush=True)

```

### stream\_complete`abstractmethod`[\\#](https://developers.llamaindex.ai/python/framework-api-reference/llms\\#llama_index.core.llms.llm.LLM.stream_complete "Permanent link")

```
stream_complete(
    prompt: str, formatted: bool = False, **kwargs: Any
) -> CompletionResponseGen

```

Streaming completion endpoint for LLM.

If the LLM is a chat model, the prompt is transformed into a single `user` message.

Parameters:

| Name | Type | Description | Default |
| --- | --- | --- | --- |
| `prompt` | `str` | Prompt to send to the LLM. | _required_ |
| `formatted` | `bool` | Whether the prompt is already formatted for the LLM, by default False. | `False` |
| `kwargs` | `Any` | Additional keyword arguments to pass to the LLM. | `{}` |

Yields:

| Name | Type | Description |
| --- | --- | --- |
| `CompletionResponse` | `CompletionResponseGen` | A generator of CompletionResponse objects, each containing a new token of the response. |

Examples:

```
gen = llm.stream_complete("your prompt")
for response in gen:
    print(response.text, end="", flush=True)

```

### achat`abstractmethod``async`[\\#](https://developers.llamaindex.ai/python/framework-api-reference/llms\\#llama_index.core.llms.llm.LLM.achat "Permanent link")

```
achat(
    messages: Sequence[[ChatMessage](https://developers.llamaindex.ai/python/framework-api-reference/llms#llama_index.core.base.llms.types.ChatMessage "ChatMessage (llama_index.core.base.llms.types.ChatMessage)")], **kwargs: Any
) -> [ChatResponse](https://developers.llamaindex.ai/python/framework-api-reference/llms#llama_index.core.base.llms.types.ChatResponse "ChatResponse (llama_index.core.base.llms.types.ChatResponse)")

```

Async chat endpoint for LLM.

Parameters:

| Name | Type | Description | Default |
| --- | --- | --- | --- |
| `messages` | `Sequence[ [ChatMessage](https://developers.llamaindex.ai/python/framework-api-reference/llms#llama_index.core.base.llms.types.ChatMessage "ChatMessage (llama_index.core.base.llms.types.ChatMessage)")]` | Sequence of chat messages. | _required_ |
| `kwargs` | `Any` | Additional keyword arguments to pass to the LLM. | `{}` |

Returns:

| Name | Type | Description |
| --- | --- | --- |
| `ChatResponse` | `[ChatResponse](https://developers.llamaindex.ai/python/framework-api-reference/llms#llama_index.core.base.llms.types.ChatResponse "ChatResponse (llama_index.core.base.llms.types.ChatResponse)")` | Chat response from the LLM. |

Examples:

```
from llama_index.core.llms import ChatMessage

response = await llm.achat([ChatMessage(role="user", content="Hello")])
print(response.content)

```

### acomplete`abstractmethod``async`[\\#](https://developers.llamaindex.ai/python/framework-api-reference/llms\\#llama_index.core.llms.llm.LLM.acomplete "Permanent link")

```
acomplete(
    prompt: str, formatted: bool = False, **kwargs: Any
) -> [CompletionResponse](https://developers.llamaindex.ai/python/framework-api-reference/llms#llama_index.core.base.llms.types.CompletionResponse "CompletionResponse (llama_index.core.base.llms.types.CompletionResponse)")

```

Async completion endpoint for LLM.

If the LLM is a chat model, the prompt is transformed into a single `user` message.

Parameters:

| Name | Type | Description | Default |
| --- | --- | --- | --- |
| `prompt` | `str` | Prompt to send to the LLM. | _required_ |
| `formatted` | `bool` | Whether the prompt is already formatted for the LLM, by default False. | `False` |
| `kwargs` | `Any` | Additional keyword arguments to pass to the LLM. | `{}` |

Returns:

| Name | Type | Description |
| --- | --- | --- |
| `CompletionResponse` | `[CompletionResponse](https://developers.llamaindex.ai/python/framework-api-reference/llms#llama_index.core.base.llms.types.CompletionResponse "CompletionResponse (llama_index.core.base.llms.types.CompletionResponse)")` | Completion response from the LLM. |

Examples:

```
response = await llm.acomplete("your prompt")
print(response.text)

```

### astream\_chat`abstractmethod``async`[\\#](https://developers.llamaindex.ai/python/framework-api-reference/llms\\#llama_index.core.llms.llm.LLM.astream_chat "Permanent link")

```
astream_chat(
    messages: Sequence[[ChatMessage](https://developers.llamaindex.ai/python/framework-api-reference/llms#llama_index.core.base.llms.types.ChatMessage "ChatMessage (llama_index.core.base.llms.types.ChatMessage)")], **kwargs: Any
) -> ChatResponseAsyncGen

```

Async streaming chat endpoint for LLM.

Parameters:

| Name | Type | Description | Default |
| --- | --- | --- | --- |
| `messages` | `Sequence[ [ChatMessage](https://developers.llamaindex.ai/python/framework-api-reference/llms#llama_index.core.base.llms.types.ChatMessage "ChatMessage (llama_index.core.base.llms.types.ChatMessage)")]` | Sequence of chat messages. | _required_ |
| `kwargs` | `Any` | Additional keyword arguments to pass to the LLM. | `{}` |

Yields:

| Name | Type | Description |
| --- | --- | --- |
| `ChatResponse` | `ChatResponseAsyncGen` | An async generator of ChatResponse objects, each containing a new token of the response. |

Examples:

```
from llama_index.core.llms import ChatMessage

gen = await llm.astream_chat([ChatMessage(role="user", content="Hello")])
async for response in gen:
    print(response.delta, end="", flush=True)

```

### astream\_complete`abstractmethod``async`[\\#](https://developers.llamaindex.ai/python/framework-api-reference/llms\\#llama_index.core.llms.llm.LLM.astream_complete "Permanent link")

```
astream_complete(
    prompt: str, formatted: bool = False, **kwargs: Any
) -> CompletionResponseAsyncGen

```

Async streaming completion endpoint for LLM.

If the LLM is a chat model, the prompt is transformed into a single `user` message.

Parameters:

| Name | Type | Description | Default |
| --- | --- | --- | --- |
| `prompt` | `str` | Prompt to send to the LLM. | _required_ |
| `formatted` | `bool` | Whether the prompt is already formatted for the LLM, by default False. | `False` |
| `kwargs` | `Any` | Additional keyword arguments to pass to the LLM. | `{}` |

Yields:

| Name | Type | Description |
| --- | --- | --- |
| `CompletionResponse` | `CompletionResponseAsyncGen` | An async generator of CompletionResponse objects, each containing a new token of the response. |

Examples:

```
gen = await llm.astream_complete("your prompt")
async for response in gen:
    print(response.text, end="", flush=True)

```

## MessageRole [\\#](https://developers.llamaindex.ai/python/framework-api-reference/llms\\#llama_index.core.base.llms.types.MessageRole "Permanent link")

Bases: `str`, `Enum`

Message role.

Source code in `.build/python/llama-index-core/llama_index/core/base/llms/types.py`

|     |     |
| --- | --- |
| ```<br>40<br>41<br>42<br>43<br>44<br>45<br>46<br>47<br>48<br>49<br>50<br>``` | ```<br>class MessageRole(str, Enum):<br>    """Message role."""<br>    SYSTEM = "system"<br>    DEVELOPER = "developer"<br>    USER = "user"<br>    ASSISTANT = "assistant"<br>    FUNCTION = "function"<br>    TOOL = "tool"<br>    CHATBOT = "chatbot"<br>    MODEL = "model"<br>``` |

## TextBlock [\\#](https://developers.llamaindex.ai/python/framework-api-reference/llms\\#llama_index.core.base.llms.types.TextBlock "Permanent link")

Bases: `BaseModel`

A representation of text data to directly pass to/from the LLM.

Source code in `.build/python/llama-index-core/llama_index/core/base/llms/types.py`

|     |     |
| --- | --- |
| ```<br>53<br>54<br>55<br>56<br>57<br>``` | ```<br>class TextBlock(BaseModel):<br>    """A representation of text data to directly pass to/from the LLM."""<br>    block_type: Literal["text"] = "text"<br>    text: str<br>``` |

## ImageBlock [\\#](https://developers.llamaindex.ai/python/framework-api-reference/llms\\#llama_index.core.base.llms.types.ImageBlock "Permanent link")

Bases: `BaseModel`

A representation of image data to directly pass to/from the LLM.

[Additional content continues with detailed class definitions for ImageBlock, AudioBlock, VideoBlock, DocumentBlock, CachePoint, CitableBlock, CitationBlock, ChatMessage, LogProb, ChatResponse, and CompletionResponse...]

Back to top
