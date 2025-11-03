Classes

# OpenAI

Defined in: [packages/providers/openai/src/llm.ts:62](https://github.com/run-llama/LlamaIndexTS/blob/7283909755f31e059df0d170fefcc019ebbb647f/packages/providers/openai/src/llm.ts#L62)

## Extends

- `ToolCallLLM` < `OpenAIAdditionalChatOptions` >

## Constructors

### Constructor

> **new OpenAI**( `init?`): `OpenAI`

Defined in: [packages/providers/openai/src/llm.ts:94](https://github.com/run-llama/LlamaIndexTS/blob/7283909755f31e059df0d170fefcc019ebbb647f/packages/providers/openai/src/llm.ts#L94)

#### Parameters

##### init?

`Omit` < `Partial` < `OpenAI` >, `"session"` \> & `object`

#### Returns

`OpenAI`

#### Overrides

`ToolCallLLM<OpenAIAdditionalChatOptions>.constructor`

## Properties

### model

> **model**: `ChatModel` \| `string` & `object`

Defined in: [packages/providers/openai/src/llm.ts:63](https://github.com/run-llama/LlamaIndexTS/blob/7283909755f31e059df0d170fefcc019ebbb647f/packages/providers/openai/src/llm.ts#L63)

* * *

### temperature

> **temperature**: `number`

Defined in: [packages/providers/openai/src/llm.ts:67](https://github.com/run-llama/LlamaIndexTS/blob/7283909755f31e059df0d170fefcc019ebbb647f/packages/providers/openai/src/llm.ts#L67)

* * *

### reasoningEffort?

> `optional` **reasoningEffort**: `"low"` \| `"medium"` \| `"high"` \| `"minimal"`

Defined in: [packages/providers/openai/src/llm.ts:68](https://github.com/run-llama/LlamaIndexTS/blob/7283909755f31e059df0d170fefcc019ebbb647f/packages/providers/openai/src/llm.ts#L68)

* * *

### topP

> **topP**: `number`

Defined in: [packages/providers/openai/src/llm.ts:69](https://github.com/run-llama/LlamaIndexTS/blob/7283909755f31e059df0d170fefcc019ebbb647f/packages/providers/openai/src/llm.ts#L69)

* * *

### maxTokens?

> `optional` **maxTokens**: `number`

Defined in: [packages/providers/openai/src/llm.ts:70](https://github.com/run-llama/LlamaIndexTS/blob/7283909755f31e059df0d170fefcc019ebbb647f/packages/providers/openai/src/llm.ts#L70)

* * *

### additionalChatOptions?

> `optional` **additionalChatOptions**: `OpenAIAdditionalChatOptions`

Defined in: [packages/providers/openai/src/llm.ts:71](https://github.com/run-llama/LlamaIndexTS/blob/7283909755f31e059df0d170fefcc019ebbb647f/packages/providers/openai/src/llm.ts#L71)

* * *

### apiKey?

> `optional` **apiKey**: `string` = `undefined`

Defined in: [packages/providers/openai/src/llm.ts:74](https://github.com/run-llama/LlamaIndexTS/blob/7283909755f31e059df0d170fefcc019ebbb647f/packages/providers/openai/src/llm.ts#L74)

* * *

### baseURL?

> `optional` **baseURL**: `string` = `undefined`

Defined in: [packages/providers/openai/src/llm.ts:75](https://github.com/run-llama/LlamaIndexTS/blob/7283909755f31e059df0d170fefcc019ebbb647f/packages/providers/openai/src/llm.ts#L75)

* * *

### maxRetries

> **maxRetries**: `number`

Defined in: [packages/providers/openai/src/llm.ts:76](https://github.com/run-llama/LlamaIndexTS/blob/7283909755f31e059df0d170fefcc019ebbb647f/packages/providers/openai/src/llm.ts#L76)

* * *

### timeout?

> `optional` **timeout**: `number`

Defined in: [packages/providers/openai/src/llm.ts:77](https://github.com/run-llama/LlamaIndexTS/blob/7283909755f31e059df0d170fefcc019ebbb647f/packages/providers/openai/src/llm.ts#L77)

* * *

### additionalSessionOptions?

> `optional` **additionalSessionOptions**: `Omit` < `Partial` < `ClientOptions` >, `"apiKey"` \| `"maxRetries"` \| `"timeout"` >

Defined in: [packages/providers/openai/src/llm.ts:78](https://github.com/run-llama/LlamaIndexTS/blob/7283909755f31e059df0d170fefcc019ebbb647f/packages/providers/openai/src/llm.ts#L78)

* * *

### lazySession()

> **lazySession**: () => `Promise` < [`LLMInstance`](https://next.ts.llamaindex.ai/docs/api/type-aliases/LLMInstance) >

Defined in: [packages/providers/openai/src/llm.ts:85](https://github.com/run-llama/LlamaIndexTS/blob/7283909755f31e059df0d170fefcc019ebbb647f/packages/providers/openai/src/llm.ts#L85)

#### Returns

`Promise` < [`LLMInstance`](https://next.ts.llamaindex.ai/docs/api/type-aliases/LLMInstance) >

## Accessors

### session

#### Get Signature

> **get** **session**(): `Promise` < [`LLMInstance`](https://next.ts.llamaindex.ai/docs/api/type-aliases/LLMInstance) >

Defined in: [packages/providers/openai/src/llm.ts:87](https://github.com/run-llama/LlamaIndexTS/blob/7283909755f31e059df0d170fefcc019ebbb647f/packages/providers/openai/src/llm.ts#L87)

##### Returns

`Promise` < [`LLMInstance`](https://next.ts.llamaindex.ai/docs/api/type-aliases/LLMInstance) >

* * *

### supportToolCall

#### Get Signature

> **get** **supportToolCall**(): `boolean`

Defined in: [packages/providers/openai/src/llm.ts:132](https://github.com/run-llama/LlamaIndexTS/blob/7283909755f31e059df0d170fefcc019ebbb647f/packages/providers/openai/src/llm.ts#L132)

##### Returns

`boolean`

#### Overrides

`ToolCallLLM.supportToolCall`

* * *

### live

#### Get Signature

> **get** **live**(): `OpenAILive`

Defined in: [packages/providers/openai/src/llm.ts:136](https://github.com/run-llama/LlamaIndexTS/blob/7283909755f31e059df0d170fefcc019ebbb647f/packages/providers/openai/src/llm.ts#L136)

##### Returns

`OpenAILive`

* * *

### metadata

#### Get Signature

> **get** **metadata**(): `LLMMetadata` & `object`

Defined in: [packages/providers/openai/src/llm.ts:147](https://github.com/run-llama/LlamaIndexTS/blob/7283909755f31e059df0d170fefcc019ebbb647f/packages/providers/openai/src/llm.ts#L147)

##### Returns

`LLMMetadata` & `object`

#### Overrides

`ToolCallLLM.metadata`

## Methods

### toOpenAIRole()

> `static` **toOpenAIRole**( `messageType`): `ChatCompletionRole`

Defined in: [packages/providers/openai/src/llm.ts:163](https://github.com/run-llama/LlamaIndexTS/blob/7283909755f31e059df0d170fefcc019ebbb647f/packages/providers/openai/src/llm.ts#L163)

#### Parameters

##### messageType

`MessageType`

#### Returns

`ChatCompletionRole`

* * *

### toOpenAIMessage()

> `static` **toOpenAIMessage**( `messages`): `ChatCompletionMessageParam`\[\]

Defined in: [packages/providers/openai/src/llm.ts:176](https://github.com/run-llama/LlamaIndexTS/blob/7283909755f31e059df0d170fefcc019ebbb647f/packages/providers/openai/src/llm.ts#L176)

#### Parameters

##### messages

`ChatMessage` < `ToolCallLLMMessageOptions` >\[\]

#### Returns

`ChatCompletionMessageParam`\[\]

* * *

### chat()

#### Call Signature

> **chat**( `params`): `Promise` < `AsyncIterable` < `ChatResponseChunk` < `ToolCallLLMMessageOptions` >, `any`, `any` >>

Defined in: [packages/providers/openai/src/llm.ts:267](https://github.com/run-llama/LlamaIndexTS/blob/7283909755f31e059df0d170fefcc019ebbb647f/packages/providers/openai/src/llm.ts#L267)

##### Parameters

###### params

`LLMChatParamsStreaming` < `OpenAIAdditionalChatOptions`, `ToolCallLLMMessageOptions` >

##### Returns

`Promise` < `AsyncIterable` < `ChatResponseChunk` < `ToolCallLLMMessageOptions` >, `any`, `any` >>

##### Overrides

`ToolCallLLM.chat`

#### Call Signature

> **chat**( `params`): `Promise` < `ChatResponse` < `ToolCallLLMMessageOptions` >>

Defined in: [packages/providers/openai/src/llm.ts:273](https://github.com/run-llama/LlamaIndexTS/blob/7283909755f31e059df0d170fefcc019ebbb647f/packages/providers/openai/src/llm.ts#L273)

##### Parameters

###### params

`LLMChatParamsNonStreaming` < `OpenAIAdditionalChatOptions`, `ToolCallLLMMessageOptions` >

##### Returns

`Promise` < `ChatResponse` < `ToolCallLLMMessageOptions` >>

##### Overrides

`ToolCallLLM.chat`

* * *

### streamChat()

> `protected` **streamChat**( `baseRequestParams`): `AsyncIterable` < `ChatResponseChunk` < `ToolCallLLMMessageOptions` >>

Defined in: [packages/providers/openai/src/llm.ts:370](https://github.com/run-llama/LlamaIndexTS/blob/7283909755f31e059df0d170fefcc019ebbb647f/packages/providers/openai/src/llm.ts#L370)

#### Parameters

##### baseRequestParams

`ChatCompletionCreateParams`

#### Returns

`AsyncIterable` < `ChatResponseChunk` < `ToolCallLLMMessageOptions` >>

* * *

### toTool()

> `static` **toTool**( `tool`): `ChatCompletionTool`

Defined in: [packages/providers/openai/src/llm.ts:449](https://github.com/run-llama/LlamaIndexTS/blob/7283909755f31e059df0d170fefcc019ebbb647f/packages/providers/openai/src/llm.ts#L449)

#### Parameters

##### tool

`BaseTool`

#### Returns

`ChatCompletionTool`
