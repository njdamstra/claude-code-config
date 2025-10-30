# Tracing LlamaIndex with MLflow

MLflow Tracing provides automatic tracing capability for LlamaIndex applications. You can enable tracing for LlamaIndex by calling the `mlflow.llama_index.autolog()` function, and nested traces are automatically logged to the active MLflow Experiment upon invocation of LlamaIndex engines and workflows.

![LlamaIndex Tracing via autolog](https://mlflow.org/docs/latest/assets/images/llamaindex-tracing-67ed751e565ef74209381a497c70cf18.gif)

## Overview

[LlamaIndex](https://www.llamaindex.ai/) is an open-source framework for building agentic generative AI applications that allow large language models to work with your data in any format.

MLflow Tracing is an OpenTelemetry-based tracing capability and supports one-click instrumentation for LlamaIndex applications.

```python
import mlflow

mlflow.llama_index.autolog()
```

**Note**: MLflow LlamaIndex integration is not only about tracing. MLflow offers full tracking experience for LlamaIndex, including model tracking, index management, and evaluation. Check out the [MLflow LlamaIndex Flavor](https://mlflow.org/docs/latest/genai/flavors/llama-index/) to learn more!

## Example Usage

### Setup Test Data

First, let's download test data to create a toy index:

```bash
mkdir -p data
curl -L https://raw.githubusercontent.com/run-llama/llama_index/main/docs/docs/examples/data/paul_graham/paul_graham_essay.txt -o ./data/paul_graham_essay.txt
```

### Create Vector Index

Load documents into a simple in-memory vector index:

```python
from llama_index.core import VectorStoreIndex, SimpleDirectoryReader

documents = SimpleDirectoryReader("data").load_data()
index = VectorStoreIndex.from_documents(documents)
```

### Enable Tracing and Query

Now you can enable LlamaIndex auto tracing and start querying the index:

```python
import mlflow

# Enabling tracing for LlamaIndex
mlflow.llama_index.autolog()

# Optional: Set a tracking URI and an experiment
mlflow.set_tracking_uri("http://localhost:5000")
mlflow.set_experiment("LlamaIndex")

# Query the index
query_engine = index.as_query_engine()
response = query_engine.query("What was the first program the author wrote?")
```

## Token Usage Tracking

MLflow >= 3.2.0 supports token usage tracking for LlamaIndex. The token usage for each LLM call will be logged in the `mlflow.chat.tokenUsage` attribute. The total token usage throughout the trace will be available in the `token_usage` field of the trace info object.

```python
import json
import mlflow
from llama_index.llms.openai import OpenAI
from llama_index.core import Settings
from llama_index.core.llms import ChatMessage

mlflow.llama_index.autolog()

# Use the chat complete method to create new chat
llm = OpenAI(model="gpt-3.5-turbo")
Settings.llm = llm
response = llm.chat(
    [ChatMessage(role="user", content="What is the capital of France?")]
)

# Get the trace object just created
last_trace_id = mlflow.get_last_active_trace_id()
trace = mlflow.get_trace(trace_id=last_trace_id)

# Print the token usage
total_usage = trace.info.token_usage
print("== Total token usage: ==")
print(f"  Input tokens: {total_usage['input_tokens']}")
print(f"  Output tokens: {total_usage['output_tokens']}")
print(f"  Total tokens: {total_usage['total_tokens']}")

# Print the token usage for each LLM call
print("\n== Detailed usage for each LLM call: ==")
for span in trace.data.spans:
    if usage := span.get_attribute("mlflow.chat.tokenUsage"):
        print(f"{span.name}:")
        print(f"  Input tokens: {usage['input_tokens']}")
        print(f"  Output tokens: {usage['output_tokens']}")
        print(f"  Total tokens: {usage['total_tokens']}")
```

**Output:**
```
== Total token usage: ==
  Input tokens: 14
  Output tokens: 7
  Total tokens: 21

== Detailed usage for each LLM call: ==
OpenAI.chat:
  Input tokens: 14
  Output tokens: 7
  Total tokens: 21
```

## LlamaIndex Workflow

The `Workflow` is LlamaIndex's next-generation GenAI orchestration framework. It is designed as a flexible and interpretable framework for building arbitrary LLM applications such as an agent, a RAG flow, a data extraction pipeline, etc.

MLflow supports tracking, evaluating, and tracing the Workflow objects, which makes them more observable and maintainable.

Automatic tracing for LlamaIndex workflow works off-the-shelf by calling the same `mlflow.llama_index.autolog()`.

To learn more about MLflow's integration with LlamaIndex Workflow, continue to the following tutorials:
- [Building Advanced RAG with MLflow and LlamaIndex Workflow](https://mlflow.org/blog/mlflow-llama-index-workflow)

## Disable Auto-Tracing

Auto tracing for LlamaIndex can be disabled globally by calling:

```python
mlflow.llama_index.autolog(disable=True)
# or
mlflow.autolog(disable=True)
```

## MLflow Tracing Overview

MLflow Tracing enhances LLM observability in your applications by capturing the inputs, outputs, and metadata associated with each intermediate step of a request, enabling you to easily pinpoint the source of bugs and unexpected behaviors.

### Use Cases Throughout the ML Lifecycle

MLflow Tracing empowers you throughout the end-to-end lifecycle of a machine learning project:

#### Build & Debug
Traces provide deep insights into what happens beneath the abstractions of GenAI libraries, helping you precisely identify where issues occur. You can navigate traces seamlessly within your preferred IDE, notebook, or the MLflow UI.

#### Track Annotation and Human Feedbacks
Human feedback is essential for building high-quality GenAI applications. MLflow supports collecting, managing, and utilizing feedback from end-users and domain experts. Feedbacks are attached to traces and recorded with metadata, including user, timestamp, revisions, etc.

#### Evaluate and Enhance Quality
Combined with MLflow GenAI Evaluation, MLflow offers a seamless experience for evaluating your applications. Tracing helps by allowing you to track quality assessment and inspect the evaluation results with visibility into the internals of the system.

#### Monitor Applications in Production
MLflow Tracing captures key metrics like latency and token usage at each step, as well as various quality metrics, helping you identify bottlenecks, monitor efficiency, and find optimization opportunities.

#### Create High-Quality Datasets
Traces from production systems capture perfect data for building high-quality datasets with precise details for internal components like retrievers and tools.

## What Makes MLflow Tracing Unique?

### Open Source
MLflow is open source and 100% FREE. You don't need to pay additional SaaS costs to add observability to your GenAI stack. Your trace data is hosted on your own infrastructure.

### OpenTelemetry
MLflow Tracing is compatible with OpenTelemetry, making it free from vendor lock-in and easy to integrate with your existing observability stack.

### Framework Agnostic
MLflow Tracing integrates with 20+ GenAI libraries, including OpenAI, LangChain, LlamaIndex, DSPy, Pydantic AI, allowing you to switch between frameworks with ease.

### End-to-End Platform
MLflow Tracing empowers you throughout the end-to-end machine learning lifecycle, combined with its version tracking and evaluation capabilities.

### Strong Community
MLflow boasts a vibrant Open Source community as a part of the Linux Foundation, with 20K+ GitHub Stars and 20MM+ monthly downloads.

## One-line Auto Tracing Integrations

MLflow Tracing is integrated with various GenAI libraries and provides one-line automatic tracing experience for each library:

```python
import mlflow

mlflow.openai.autolog()  # or replace 'openai' with other library names
```

Supported integrations include:
- OpenAI
- LangChain
- LangGraph
- LlamaIndex
- Anthropic
- DSPy
- Bedrock
- Semantic Kernel
- AutoGen
- AG2
- Gemini
- LiteLLM
- CrewAI
- Ollama
- PydanticAI
- And many more...

## Flexible and Customizable

In addition to one-line auto tracing, MLflow offers Python SDK for manually instrumenting your code:

- Trace a function with `@mlflow.trace` decorator
- Trace any block of code using context manager
- Combine multiple auto-tracing integrations
- Instrument multi-threaded applications
- Native async support
- Group and filter traces using sessions
- Redact PII data from traces
- Disable tracing globally
- Configure sampling ratio to control trace throughput

## Production Readiness

MLflow Tracing is production ready and provides comprehensive monitoring capabilities for your GenAI applications. By enabling async logging, trace logging is done in the background and does not impact application performance.

For production deployments, it is recommended to use the **Lightweight Tracing SDK** (`mlflow-tracing`) that is optimized for reducing the total installation size and minimizing dependencies while maintaining full tracing capabilities. Compared to the full `mlflow` package, the `mlflow-tracing` package requires 95% smaller footprint.

## Additional Resources

- [MLflow Tracing Documentation](https://mlflow.org/docs/latest/genai/tracing/)
- [MLflow LlamaIndex Flavor](https://mlflow.org/docs/latest/genai/flavors/llama-index/)
- [Production Monitoring Guide](https://mlflow.org/docs/latest/genai/tracing/prod-tracing/)
- [Building Advanced RAG with MLflow and LlamaIndex Workflow](https://mlflow.org/blog/mlflow-llama-index-workflow)
