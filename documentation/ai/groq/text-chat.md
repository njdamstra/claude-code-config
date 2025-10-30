[![Groq](https://console.groq.com/groq-logo.svg)](https://console.groq.com/home)

[Docs](https://console.groq.com/docs/overview) [Login](https://console.groq.com/home)

[Log In](https://console.groq.com/login)

# Text Generation

Generating text with Groq's Chat Completions API enables you to have natural, conversational interactions with Groq's large language models. It processes a series of messages and generates human-like responses that can be used for various applications including conversational agents, content generation, task automation, and generating structured data outputs like JSON for your applications.

## [Chat Completions](https://console.groq.com/docs/text-chat\#chat-completions)

Chat completions allow your applications to have dynamic interactions with Groq's models. You can send messages that include user inputs and system instructions, and receive responses that match the conversational context.

Chat models can handle both multi-turn discussions (conversations with multiple back-and-forth exchanges) and single-turn tasks where you need just one response.

For details about all available parameters, [visit the API reference page.](https://console.groq.com/docs/api-reference#chat-create)

### [Getting Started with Groq SDK](https://console.groq.com/docs/text-chat\#getting-started-with-groq-sdk)

To start using Groq's Chat Completions API, you'll need to install the [Groq SDK](https://console.groq.com/docs/libraries) and set up your [API key](https://console.groq.com/keys).

PythonJavaScript

shell

```
pip install groq
```

## [Performing a Basic Chat Completion](https://console.groq.com/docs/text-chat\#performing-a-basic-chat-completion)

The simplest way to use the Chat Completions API is to send a list of messages and receive a single response. Messages are provided in chronological order, with each message containing a role ("system", "user", or "assistant") and content.

Python

```
1from groq import Groq
2
3client = Groq()
4
5chat_completion = client.chat.completions.create(
6    messages=[\
7        # Set an optional system message. This sets the behavior of the\
8        # assistant and can be used to provide specific instructions for\
9        # how it should behave throughout the conversation.\
10        {\
11            "role": "system",\
12            "content": "You are a helpful assistant."\
13        },\
14        # Set a user message for the assistant to respond to.\
15        {\
16            "role": "user",\
17            "content": "Explain the importance of fast language models",\
18        }\
19    ],
20
21    # The language model which will generate the completion.
22    model="llama-3.3-70b-versatile"
23)
24
25# Print the completion returned by the LLM.
26print(chat_completion.choices[0].message.content)
```

## [Streaming a Chat Completion](https://console.groq.com/docs/text-chat\#streaming-a-chat-completion)

For a more responsive user experience, you can stream the model's response in real-time. This allows your application to display the response as it's being generated, rather than waiting for the complete response.

To enable streaming, set the parameter `stream=True`. The completion function will then return an iterator of completion deltas rather than a single, full completion.

Python

```
1from groq import Groq
2
3client = Groq()
4
5stream = client.chat.completions.create(
6    #
7    # Required parameters
8    #
9    messages=[\
10        # Set an optional system message. This sets the behavior of the\
11        # assistant and can be used to provide specific instructions for\
12        # how it should behave throughout the conversation.\
13        {\
14            "role": "system",\
15            "content": "You are a helpful assistant."\
16        },\
17        # Set a user message for the assistant to respond to.\
18        {\
19            "role": "user",\
20            "content": "Explain the importance of fast language models",\
21        }\
22    ],
23
24    # The language model which will generate the completion.
25    model="llama-3.3-70b-versatile",
26
27    #
28    # Optional parameters
29    #
30
31    # Controls randomness: lowering results in less random completions.
32    # As the temperature approaches zero, the model will become deterministic
33    # and repetitive.
34    temperature=0.5,
35
36    # The maximum number of tokens to generate. Requests can use up to
37    # 2048 tokens shared between prompt and completion.
38    max_completion_tokens=1024,
39
40    # Controls diversity via nucleus sampling: 0.5 means half of all
41    # likelihood-weighted options are considered.
42    top_p=1,
43
44    # A stop sequence is a predefined or user-specified text string that
45    # signals an AI to stop generating content, ensuring its responses
46    # remain focused and concise. Examples include punctuation marks and
47    # markers like "[end]".
48    stop=None,
49
50    # If set, partial message deltas will be sent.
51    stream=True,
52)
53
54# Print the incremental deltas returned by the LLM.
55for chunk in stream:
56    print(chunk.choices[0].delta.content, end="")
```

## [Performing a Chat Completion with a Stop Sequence](https://console.groq.com/docs/text-chat\#performing-a-chat-completion-with-a-stop-sequence)

Stop sequences allow you to control where the model should stop generating. When the model encounters any of the specified stop sequences, it will halt generation at that point. This is useful when you need responses to end at specific points.

Python

```
1from groq import Groq
2
3client = Groq()
4
5chat_completion = client.chat.completions.create(
6    #
7    # Required parameters
8    #
9    messages=[\
10        # Set an optional system message. This sets the behavior of the\
11        # assistant and can be used to provide specific instructions for\
12        # how it should behave throughout the conversation.\
13        {\
14            "role": "system",\
15            "content": "You are a helpful assistant."\
16        },\
17        # Set a user message for the assistant to respond to.\
18        {\
19            "role": "user",\
20            "content": "Count to 10.  Your response must begin with \"1, \".  example: 1, 2, 3, ...",\
21        }\
22    ],
23
24    # The language model which will generate the completion.
25    model="llama-3.3-70b-versatile",
26
27    #
28    # Optional parameters
29    #
30
31    # Controls randomness: lowering results in less random completions.
32    # As the temperature approaches zero, the model will become deterministic
33    # and repetitive.
34    temperature=0.5,
35
36    # The maximum number of tokens to generate. Requests can use up to
37    # 2048 tokens shared between prompt and completion.
38    max_completion_tokens=1024,
39
40    # Controls diversity via nucleus sampling: 0.5 means half of all
41    # likelihood-weighted options are considered.
42    top_p=1,
43
44    # A stop sequence is a predefined or user-specified text string that
45    # signals an AI to stop generating content, ensuring its responses
46    # remain focused and concise. Examples include punctuation marks and
47    # markers like "[end]".
48    # For this example, we will use ", 6" so that the llm stops counting at 5.
49    # If multiple stop values are needed, an array of string may be passed,
50    # stop=[", 6", ", six", ", Six"]
51    stop=", 6",
52
53    # If set, partial message deltas will be sent.
54    stream=False,
55)
56
57# Print the completion returned by the LLM.
58print(chat_completion.choices[0].message.content)
```

## [Performing an Async Chat Completion](https://console.groq.com/docs/text-chat\#performing-an-async-chat-completion)

For applications that need to maintain responsiveness while waiting for completions, you can use the asynchronous client. This lets you make non-blocking API calls using Python's asyncio framework.

Python

```
1import asyncio
2
3from groq import AsyncGroq
4
5
6async def main():
7    client = AsyncGroq()
8
9    chat_completion = await client.chat.completions.create(
10        #
11        # Required parameters
12        #
13        messages=[\
14            # Set an optional system message. This sets the behavior of the\
15            # assistant and can be used to provide specific instructions for\
16            # how it should behave throughout the conversation.\
17            {\
18                "role": "system",\
19                "content": "You are a helpful assistant."\
20            },\
21            # Set a user message for the assistant to respond to.\
22            {\
23                "role": "user",\
24                "content": "Explain the importance of fast language models",\
25            }\
26        ],
27
28        # The language model which will generate the completion.
29        model="llama-3.3-70b-versatile",
30
31        #
32        # Optional parameters
33        #
34
35        # Controls randomness: lowering results in less random completions.
36        # As the temperature approaches zero, the model will become
37        # deterministic and repetitive.
38        temperature=0.5,
39
40        # The maximum number of tokens to generate. Requests can use up to
41        # 2048 tokens shared between prompt and completion.
42        max_completion_tokens=1024,
43
44        # Controls diversity via nucleus sampling: 0.5 means half of all
45        # likelihood-weighted options are considered.
46        top_p=1,
47
48        # A stop sequence is a predefined or user-specified text string that
49        # signals an AI to stop generating content, ensuring its responses
50        # remain focused and concise. Examples include punctuation marks and
51        # markers like "[end]".
52        stop=None,
53
54        # If set, partial message deltas will be sent.
55        stream=False,
56    )
57
58    # Print the completion returned by the LLM.
59    print(chat_completion.choices[0].message.content)
60
61asyncio.run(main())
```

### [Streaming an Async Chat Completion](https://console.groq.com/docs/text-chat\#streaming-an-async-chat-completion)

You can combine the benefits of streaming and asynchronous processing by streaming completions asynchronously. This is particularly useful for applications that need to handle multiple concurrent conversations.

Python

```
1import asyncio
2
3from groq import AsyncGroq
4
5
6async def main():
7    client = AsyncGroq()
8
9    stream = await client.chat.completions.create(
10        #
11        # Required parameters
12        #
13        messages=[\
14            # Set an optional system message. This sets the behavior of the\
15            # assistant and can be used to provide specific instructions for\
16            # how it should behave throughout the conversation.\
17            {\
18                "role": "system",\
19                "content": "You are a helpful assistant."\
20            },\
21            # Set a user message for the assistant to respond to.\
22            {\
23                "role": "user",\
24                "content": "Explain the importance of fast language models",\
25            }\
26        ],
27
28        # The language model which will generate the completion.
29        model="llama-3.3-70b-versatile",
30
31        #
32        # Optional parameters
33        #
34
35        # Controls randomness: lowering results in less random completions.
36        # As the temperature approaches zero, the model will become
37        # deterministic and repetitive.
38        temperature=0.5,
39
40        # The maximum number of tokens to generate. Requests can use up to
41        # 2048 tokens shared between prompt and completion.
42        max_completion_tokens=1024,
43
44        # Controls diversity via nucleus sampling: 0.5 means half of all
45        # likelihood-weighted options are considered.
46        top_p=1,
47
48        # A stop sequence is a predefined or user-specified text string that
49        # signals an AI to stop generating content, ensuring its responses
50        # remain focused and concise. Examples include punctuation marks and
51        # markers like "[end]".
52        stop=None,
53
54        # If set, partial message deltas will be sent.
55        stream=True,
56    )
57
58    # Print the incremental deltas returned by the LLM.
59    async for chunk in stream:
60        print(chunk.choices[0].delta.content, end="")
61
62asyncio.run(main())
```

## [Structured Outputs and JSON](https://console.groq.com/docs/text-chat\#structured-outputs-and-json)

Need reliable, type-safe JSON responses that match your exact schema? Groq's Structured Outputs feature is designed so that model responses strictly conform to your JSON Schema without validation or retry logic.

For complete guides on implementing structured outputs with JSON Schema or using JSON Object Mode, see our [structured outputs documentation](https://console.groq.com/docs/structured-outputs).

Key capabilities:

- **JSON Schema enforcement**: Responses match your schema exactly
- **Type-safe outputs**: No validation or retry logic needed
- **Programmatic refusal detection**: Handle safety-based refusals programmatically
- **JSON Object Mode**: Basic JSON output with prompt-guided structure

### Was this page helpful?

YesNoSuggest Edits

#### On this page

- [Chat Completions](https://console.groq.com/docs/text-chat#chat-completions)
- [Performing a Basic Chat Completion](https://console.groq.com/docs/text-chat#performing-a-basic-chat-completion)
- [Streaming a Chat Completion](https://console.groq.com/docs/text-chat#streaming-a-chat-completion)
- [Performing a Chat Completion with a Stop Sequence](https://console.groq.com/docs/text-chat#performing-a-chat-completion-with-a-stop-sequence)
- [Performing an Async Chat Completion](https://console.groq.com/docs/text-chat#performing-an-async-chat-completion)
- [Structured Outputs and JSON](https://console.groq.com/docs/text-chat#structured-outputs-and-json)

StripeM-Inner
