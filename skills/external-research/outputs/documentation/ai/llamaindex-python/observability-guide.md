# Observability

LlamaIndex provides **one-click observability** 🔭 to allow you to build principled LLM applications in a production setting.

A key requirement for principled development of LLM applications over your data (RAG systems, agents) is being able to observe, debug, and evaluate
your system - both as a whole and for each component.

This feature allows you to seamlessly integrate the LlamaIndex library with powerful observability/evaluation tools offered by our partners.
Configure a variable once, and you'll be able to do things like the following:

- View LLM/prompt inputs/outputs
- Ensure that the outputs of any component (LLMs, embeddings) are performing as expected
- View call traces for both indexing and querying

Each provider has similarities and differences. Take a look below for the full set of guides for each one!

**NOTE:**

Observability is now being handled via the [`instrumentation` module](https://developers.llamaindex.ai/python/framework/module_guides/observability/instrumentation) (available in v0.10.20 and later.)

A lot of the tooling and integrations mentioned in this page use our legacy `CallbackManager` or don't use `set_global_handler`. We've marked these integrations as such!

## Usage Pattern

To toggle, you will generally just need to do the following:

```python
# Set global handler
set_global_handler(handler_name, **kwargs)
```

Note that all `kwargs` to `set_global_handler` are passed to the underlying callback handler.

And that's it! Executions will get seamlessly piped to downstream service and you'll be able to access features such as viewing execution traces of your application.

## Integrations

### OpenTelemetry

[OpenTelemetry](https://openetelemetry.io/) is a widely used open-source service for tracing and observability, with numerous backend integrations (such as Jaeger, Zipkin or Prometheus).

Our OpenTelemetry integration traces all the events produced by pieces of LlamaIndex code, including LLMs, Agents, RAG pipeline components and many more: everything you would get out with LlamaIndex native instrumentation you can export in OpenTelemetry format!

You can install the library with:

```bash
pip install opentelemetry-sdk opentelemetry-exporter-otlp
```

And can use it in your code with the default settings, as in this example with a RAG pipeline:

```python
from opentelemetry import trace
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import SimpleSpanProcessor
from opentelemetry.exporter.otlp.proto.http.trace_exporter import OTLPSpanExporter

# Set up OpenTelemetry
trace.set_tracer_provider(TracerProvider())
tracer_provider = trace.get_tracer_provider()
tracer_provider.add_span_processor(
    SimpleSpanProcessor(OTLPSpanExporter())
)

# Your LlamaIndex code here
```

Or you can use a more complex and customized set-up, such as in the following example:

```python
# Custom configuration example
```

We also have a [demo repository](https://github.com/run-llama/agents-observability-demo) where we show how to trace agentic workflows and pipe the registered traces into a Postgres database.

### LlamaTrace (Hosted Arize Phoenix)

We've partnered with Arize on [LlamaTrace](https://llamatrace.com/), a hosted tracing, observability, and evaluation platform that works natively with LlamaIndex open-source users and has integrations with LlamaCloud.

This is built upon the open-source Arize [Phoenix](https://github.com/Arize-ai/phoenix) project. Phoenix provides a notebook-first experience for monitoring your models and LLM Applications by providing:

- LLM Traces - Trace through the execution of your LLM Application to understand the internals of your LLM Application and to troubleshoot problems related to things like retrieval and tool execution.
- LLM Evals - Leverage the power of large language models to evaluate your generative model or application's relevance, toxicity, and more.

#### Usage Pattern

To install the integration package, do `pip install -U llama-index-callbacks-arize-phoenix`.

Then create an account on LlamaTrace: [https://llamatrace.com/login](https://llamatrace.com/login). Create an API key and put it in the `PHOENIX_API_KEY` variable below.

Then run the following code:

```python
import os
os.environ["PHOENIX_API_KEY"] = "your-api-key"

import phoenix as px
px.launch_app()

# Set up LlamaIndex callback
from llama_index.core import set_global_handler
set_global_handler("arize_phoenix")
```

### Weights and Biases (W&B) Weave

[W&B Weave](https://weave-docs.wandb.ai/) is a framework for tracking, experimenting with, evaluating, deploying, and improving LLM applications. Designed for scalability and flexibility, Weave supports every stage of your application development workflow.

#### Usage Pattern

The integration leverages LlamaIndex's [`instrumentation` module](https://developers.llamaindex.ai/python/framework/module_guides/observability/instrumentation) to register spans/events as Weave calls. By default, Weave automatically patches and tracks calls to [common LLM libraries and frameworks](https://weave-docs.wandb.ai/guides/integrations/).

Install the `weave` library:

```bash
pip install weave
```

Get a W&B API Key:

If you don't already have a W&B account, create one by visiting [https://wandb.ai](https://wandb.ai/) and copy your API key from [https://wandb.ai/authorize](https://wandb.ai/authorize). When prompted to authenticate, enter the API key.

```python
import weave
weave.init('project-name')
```

Traces include execution time, token usage, cost, inputs/outputs, errors, nested operations, and streaming data. If you are new to Weave tracing, learn more about how to navigate it [here](https://weave-docs.wandb.ai/guides/tracking/trace-tree).

If you have a custom function which is not traced, decorate it with [`@weave.op()`](https://weave-docs.wandb.ai/guides/tracking/ops).

You can also control the patching behavior using the `autopatch_settings` argument in `weave.init`. For example if you don't want to trace a library/framework you can turn it off like this:

```python
weave.init('project-name', autopatch_settings={'llamaindex': False})
```

No additional LlamaIndex configuration is required; tracing begins once `weave.init()` is called.

### MLflow

[MLflow](https://mlflow.org/docs/latest/llms/tracing/index.html) is an open-source MLOps/LLMOps platform, focuses on the full lifecycle for machine learning projects, ensuring that each phase is manageable, traceable, and reproducible.
**MLflow Tracing** is an OpenTelemetry-based tracing capability and supports one-click instrumentation for LlamaIndex applications.

#### Usage Pattern

Since MLflow is open-source, you can start using it without any account creation or API key setup. Jump straight into the code after installing the MLflow package!

```python
pip install mlflow

import mlflow
mlflow.llama_index.autolog()

# Your LlamaIndex code here
```

#### Support Table

MLflow Tracing support the full range of LlamaIndex features. Some new features like [AgentWorkflow](https://www.llamaindex.ai/blog/introducing-agentworkflow-a-powerful-system-for-building-ai-agent-systems) requires MLflow >= 2.18.0.

| Streaming | Async | Engine | Agents | Workflow | AgentWorkflow |
| --- | --- | --- | --- | --- | --- |
| ✅ | ✅ | ✅ | ✅ | ✅ (>= 2.18) | ✅ (>= 2.18) |

### OpenLLMetry

[OpenLLMetry](https://github.com/traceloop/openllmetry) is an open-source project based on OpenTelemetry for tracing and monitoring
LLM applications. It connects to [all major observability platforms](https://www.traceloop.com/docs/openllmetry/integrations/introduction) and installs in minutes.

#### Usage Pattern

```python
from traceloop.sdk import Traceloop
Traceloop.init()
```

### Langfuse 🪢

[Langfuse](https://langfuse.com/docs) is an open source LLM engineering platform to help teams collaboratively debug, analyze and iterate on their LLM Applications. With the Langfuse integration, you can track and monitor performance, traces, and metrics of your LlamaIndex application. Detailed [traces](https://langfuse.com/docs/tracing) of the context augmentation and the LLM querying processes are captured and can be inspected directly in the Langfuse UI.

#### Usage Pattern

Make sure you have both `llama-index` and `langfuse` installed.

```bash
pip install llama-index langfuse
```

Next, set up your Langfuse API keys. You can get these keys by signing up for a free [Langfuse Cloud](https://cloud.langfuse.com/) account or by [self-hosting Langfuse](https://langfuse.com/self-hosting). These environment variables are essential for the Langfuse client to authenticate and send data to your Langfuse project.

```python
import os
os.environ["LANGFUSE_PUBLIC_KEY"] = "your-public-key"
os.environ["LANGFUSE_SECRET_KEY"] = "your-secret-key"
os.environ["LANGFUSE_HOST"] = "https://cloud.langfuse.com" # or your self-hosted URL
```

With the environment variables set, we can now initialize the Langfuse client. `get_client()` initializes the Langfuse client using the credentials provided in the environment variables.

```python
from langfuse import Langfuse
langfuse = Langfuse()
```

Now, we initialize the [OpenInference LlamaIndex instrumentation](https://docs.arize.com/phoenix/tracing/integrations-tracing/llamaindex). This third-party instrumentation automatically captures LlamaIndex operations and exports OpenTelemetry (OTel) spans to Langfuse.

```python
from openinference.instrumentation.llama_index import LlamaIndexInstrumentor
LlamaIndexInstrumentor().instrument()
```

You can now see the logs of your LlamaIndex application in Langfuse.

### Literal AI

[Literal AI](https://literalai.com/) is the go-to LLM evaluation and observability solution, enabling engineering and product teams to ship LLM applications reliably, faster and at scale. This is possible through a collaborative development cycle involving prompt engineering, LLM observability, LLM evaluation and LLM monitoring. Conversation Threads and Agent Runs can be automatically logged on Literal AI.

The simplest way to get started and try out Literal AI is to signup on our [cloud instance](https://cloud.getliteral.ai/).
You can then navigate to **Settings**, grab your API key, and start logging!

#### Usage Pattern

- Install the Literal AI Python SDK with `pip install literalai`
- On your Literal AI project, go to **Settings** and grab your API key
- If you are using a self-hosted instance of Literal AI, also make note of its base URL

Then add the following lines to your applicative code :

```python
import os
os.environ["LITERAL_API_KEY"] = "your-api-key"

from llama_index.core import set_global_handler
set_global_handler("literalai")
```

### Comet Opik

[Opik](https://www.comet.com/docs/opik/?utm_source=llama-index&utm_medium=docs&utm_campaign=opik&utm_content=home_page) is an open-source end to end LLM Evaluation Platform built by Comet.

To get started, simply sign up for an account on [Comet](https://www.comet.com/signup?from=llm&utm_medium=github&utm_source=llama-index&utm_campaign=opik) and grab your API key.

#### Usage Pattern

- Install the Opik Python SDK with `pip install opik`
- In Opik, get your API key from the user menu.
- If you are using a self-hosted instance of Opik, also make note of its base URL.

You can configure Opik using the environment variables `OPIK_API_KEY`, `OPIK_WORKSPACE` and `OPIK_URL_OVERRIDE` if you are using a [self-hosted instance](https://www.comet.com/docs/opik/self-host/self_hosting_opik). You can set these by calling:

```python
import os
os.environ["OPIK_API_KEY"] = "your-api-key"
os.environ["OPIK_WORKSPACE"] = "your-workspace"
```

You can now use the Opik integration with LlamaIndex by setting the global handler:

```python
from llama_index.core import set_global_handler
set_global_handler("opik")
```

### Additional Integrations

The guide also covers many other observability integrations including:

- **Argilla** - Collaboration tool for AI engineers
- **Agenta** - Open-source LLMOps platform
- **Deepeval** - Evaluation framework for LLM applications
- **Maxim AI** - Agent Simulation and Evaluation platform
- **HoneyHive** - Trace execution flow and debugging
- **PromptLayer** - Analytics and prompt management
- **Langtrace** - OpenTelemetry-based tracing
- **OpenLIT** - OpenTelemetry-native GenAI observability
- **AgentOps** - Agent monitoring and evaluation

And legacy integrations using the `CallbackManager`:
- **TruEra TruLens** - Evaluation and feedback functions
- **OpenInference** - Open standard for AI model inferences
- **Simple (LLM Inputs/Outputs)** - Basic console logging

For detailed usage patterns and examples for each integration, refer to the official LlamaIndex documentation.

## More observability

- [Callbacks Guide](https://developers.llamaindex.ai/python/framework/module_guides/observability/callbacks)
