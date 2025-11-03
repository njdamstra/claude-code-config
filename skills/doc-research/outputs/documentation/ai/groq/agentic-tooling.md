# Groq Agentic Tooling

The document describes Groq's Compound systems, which are advanced AI systems designed to solve problems by taking action and intelligently using external tools like web search and code execution, alongside powerful LLMs such as GPT-OSS 120B, Llama 4 Scout, and Llama 3.3 70B.[1] This allows for more accurate, up-to-date, and capable responses than an LLM alone.[1]

There are two available Compound systems:
*   `groq/compound`: Supports multiple tool calls per request, suitable for use cases requiring multiple web searches or code executions.[1]
*   `groq/compound-mini`: Supports a single tool call per request and has an average of 3x lower latency than `groq/compound`.[1]

Both systems support the following built-in tools: Web Search, Visit Website, Code Execution, Browser Automation, and Wolfram Alpha.[1] Custom user-provided tools are not supported at this time.[1]

To use these systems, the `model` parameter in the API call should be set to either `groq/compound` or `groq/compound-mini`.[1] The API intelligently decides when to use search or code execution to answer the user's query, with tool calls performed server-side.[1] The `executed_tools` field in the response can be checked to view the tools used, and `usage_breakdown` provides detailed information about the underlying models used during execution.[1] Compound systems also support versioning through the `Groq-Model-Version` header.[1]

