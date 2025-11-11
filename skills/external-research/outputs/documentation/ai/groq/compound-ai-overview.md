[![Groq](https://console.groq.com/groq-logo.svg)](https://console.groq.com/home)

[Docs](https://console.groq.com/docs/overview) [Login](https://console.groq.com/home)

[Log In](https://console.groq.com/login)

# Compound

While LLMs excel at generating text, Groq's Compound systems take the next step.
Compound is an advanced AI system that is designed to solve problems by taking action and intelligently uses external tools, such as web search and code execution, alongside the powerful [GPT-OSS 120B](https://console.groq.com/docs/model/openai/gpt-oss-120b), [Llama 4 Scout](https://console.groq.com/docs/model/meta-llama/llama-4-scout-17b-16e-instruct), and [Llama 3.3 70B](https://console.groq.com/docs/model/llama-3.3-70b-versatile) models.
This allows it access to real-time information and interaction with external environments, providing more accurate, up-to-date, and capable responses than an LLM alone.

Groq's compound AI system should not be used by customers for processing protected health information as it is not a HIPAA Covered Cloud Service under Groq's Business Associate Addendum at this time. This system is also not available currently for use with regional / sovereign endpoints.

## [Available Compound Systems](https://console.groq.com/docs/compound\#available-compound-systems)

There are two compound systems available:

- [`groq/compound`](https://console.groq.com/docs/compound/systems/compound): supports multiple tool calls per request. This system is great for use cases that require multiple web searches or code executions per request.
- [`groq/compound-mini`](https://console.groq.com/docs/compound/systems/compound-mini): supports a single tool call per request. This system is great for use cases that require a single web search or code execution per request. `groq/compound-mini` has an average of 3x lower latency than `groq/compound`.

Both systems support the following tools:

- [Web Search](https://console.groq.com/docs/web-search)
- [Visit Website](https://console.groq.com/docs/visit-website)
- [Code Execution](https://console.groq.com/docs/code-execution)
- [Browser Automation](https://console.groq.com/docs/browser-automation)
- [Wolfram Alpha](https://console.groq.com/docs/wolfram-alpha)

Custom [user-provided tools](https://console.groq.com/docs/tool-use) are not supported at this time.

## [Quickstart](https://console.groq.com/docs/compound\#quickstart)

To use compound systems, change the `model` parameter to either `groq/compound` or `groq/compound-mini`:

Python

```
1from groq import Groq
2
3client = Groq()
4
5completion = client.chat.completions.create(
6    messages=[\
7        {\
8            "role": "user",\
9            "content": "What is the current weather in Tokyo?",\
10        }\
11    ],
12    # Change model to compound to use built-in tools
13    # model: "llama-3.3-70b-versatile",
14    model="groq/compound",
15)
16
17print(completion.choices[0].message.content)
18# Print all tool calls
19# print(completion.choices[0].message.executed_tools)
```

And that's it!

When the API is called, it will intelligently decide when to use search or code execution to best answer the user's query.
These tool calls are performed on the server side, so no additional setup is required on your part to use built-in tools.

In the above example, the API will use its build in web search tool to find the current weather in Tokyo.
If you didn't use compound systems, you might have needed to add your own custom tools to make API requests to a weather service, then perform multiple API calls to Groq to get a final result.
Instead, with compound systems, you can get a final result with a single API call.

## [Executed Tools](https://console.groq.com/docs/compound\#executed-tools)

To view the tools (search or code execution) used automatically by the compound system, check the `executed_tools` field in the response:

Python

```
1import os
2from groq import Groq
3
4client = Groq(api_key=os.environ.get("GROQ_API_KEY"))
5
6response = client.chat.completions.create(
7    model="groq/compound",
8    messages=[\
9        {"role": "user", "content": "What did Groq release last week?"}\
10    ]
11)
12# Log the tools that were used to generate the response
13print(response.choices[0].message.executed_tools)
```

## [Model Usage Details](https://console.groq.com/docs/compound\#model-usage-details)

The `usage_breakdown` field in responses provides detailed information about all the underlying models used during the compound system's execution.

JSON

```
"usage_breakdown": {
  "models": [\
    {\
      "model": "llama-3.3-70b-versatile",\
      "usage": {\
        "queue_time": 0.017298032,\
        "prompt_tokens": 226,\
        "prompt_time": 0.023959775,\
        "completion_tokens": 16,\
        "completion_time": 0.061639794,\
        "total_tokens": 242,\
        "total_time": 0.085599569\
      }\
    },\
    {\
      "model": "openai/gpt-oss-120b",\
      "usage": {\
        "queue_time": 0.019125835,\
        "prompt_tokens": 903,\
        "prompt_time": 0.033082052,\
        "completion_tokens": 873,\
        "completion_time": 1.776467372,\
        "total_tokens": 1776,\
        "total_time": 1.809549424\
      }\
    }\
  ]
}
```

## [System Versioning](https://console.groq.com/docs/compound\#system-versioning)

Compound systems support versioning through the `Groq-Model-Version` header. In most cases, you won't need to change anything since you'll automatically be on the latest stable version. To view the latest changes to the compound systems, see the [Compound Changelog](https://console.groq.com/docs/changelog/compound).

### [Available Systems and Versions](https://console.groq.com/docs/compound\#available-systems-and-versions)

| System | Default Version<br>(no header) | Latest Version<br>( `Groq-Model-Version: latest`) | Previous Versions |
| --- | --- | --- | --- |
| [`groq/compound`](https://console.groq.com/docs/compound/systems/compound) | `2025-08-16` (stable) | `2025-08-16` (latest) | `2025-07-23` |
| [`groq/compound-mini`](https://console.groq.com/docs/compound/systems/compound-mini) | `2025-08-16` (stable) | `2025-08-16` (latest) | `2025-07-23` |

### [Version Details](https://console.groq.com/docs/compound\#version-details)

- **Default (no header)**: Uses version `2025-08-16`, the most recent stable version that has been fully tested and deployed
- **Latest** ( `Groq-Model-Version: latest`): Uses version `2025-08-16`, the prerelease version with the newest features before they're rolled out to everyone

To use a specific version, pass the version in the `Groq-Model-Version` header:

curl

```
curl -X POST "https://api.groq.com/openai/v1/chat/completions" \
  -H "Authorization: Bearer $GROQ_API_KEY" \
  -H "Content-Type: application/json" \
  -H "Groq-Model-Version: latest" \
  -d '{
    "model": "groq/compound",
    "messages": [{"role": "user", "content": "What is the weather today?"}]
  }'
```

## [What's Next?](https://console.groq.com/docs/compound\#whats-next)

Now that you understand the basics of compound systems, explore these topics:

- **[Systems](https://console.groq.com/docs/compound/systems)** \- Learn about the two compound systems and when to use each one
- **[Built-in Tools](https://console.groq.com/docs/compound/built-in-tools)** \- Learn about the built-in tools available in Groq's Compound systems
- **[Search Settings](https://console.groq.com/docs/web-search#search-settings)** \- Customize web search behavior with domain filtering
- **[Use Cases](https://console.groq.com/docs/compound/use-cases)** \- Explore practical applications and detailed examples

### Was this page helpful?

YesNoSuggest Edits

#### On this page

- [Available Compound Systems](https://console.groq.com/docs/compound#available-compound-systems)
- [Quickstart](https://console.groq.com/docs/compound#quickstart)
- [Executed Tools](https://console.groq.com/docs/compound#executed-tools)
- [Model Usage Details](https://console.groq.com/docs/compound#model-usage-details)
- [System Versioning](https://console.groq.com/docs/compound#system-versioning)
- [What's Next?](https://console.groq.com/docs/compound#whats-next)

StripeM-Inner
