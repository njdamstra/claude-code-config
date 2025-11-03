[Skip to content](https://developers.llamaindex.ai/python/workflows/durable_workflows#_top)

# Writing durable workflows

Workflows are ephemeral by default, meaning that once the `run()` method returns its result, the workflow state is lost. A subsequent call to `run()` on the same workflow instance will start from a fresh state.

If the use case requires to persist the workflow state across multiple runs and possibly different processes, there are a few strategies that can be used to make workflows more durable.

## Storing data in the workflow instance

[Section titled "Storing data in the workflow instance"](https://developers.llamaindex.ai/python/workflows/durable_workflows#storing-data-in-the-workflow-instance)

Workflows are regular Python classes, and data can be stored in class or instance variables, so that subsequent `run()` invocations can access it.

```

```

In this case, multiple calls to `run()` will reuse the same database client.

| Persists over `run` calls | ✅ |
| --- | --- |
| Persists over process restarts | ❌ |
| Survives runtime errors | ❌ |

## Storing data in the context object

[Section titled "Storing data in the context object"](https://developers.llamaindex.ai/python/workflows/durable_workflows#storing-data-in-the-context-object)

Each workflow comes with a special object responsible for its runtime operations called `Context`. The context instance is available to any step of a workflow and comes with a `store` property that can be used to store and load state data. Using the state store has two major advantages compared to class and instance variables:

- It's async safe and supports concurrent access
- It can be serialized

```

```

| Persists over `run` calls | ✅ |
| --- | --- |
| Persists over process restarts | ✅ |
| Survives runtime errors | ❌ |

## Using external resources to checkpoint execution

[Section titled "Using external resources to checkpoint execution"](https://developers.llamaindex.ai/python/workflows/durable_workflows#using-external-resources-to-checkpoint-execution)

To avoid any overhead, workflows don't take snapshots of the current state automatically, so they can't survive a fatal error on their own. However, any step can rely on some external database like Redis and snapshot the current context on sensitive parts of the code.

For example, given a long running workflow processing hundreds of documents, we could save the id of the last document successfully processed in the state store:

```

```

The workflow will use a Redis collection to store a snapshot of the current context after every conversion. If the process running the workflow crashes, the process can be safely restarted with the same input. In fact, `ctx.store` will contain the list of documents already processed and the `for` loop will be able to skip them and continue to process the remaining work.

### Bonus: inject dependencies into the workflow to reduce boilerplate

[Section titled "Bonus: inject dependencies into the workflow to reduce boilerplate"](https://developers.llamaindex.ai/python/workflows/durable_workflows#bonus-inject-dependencies-into-the-workflow-to-reduce-boilerplate)

Using the Resource feature of workflows, the Redis client can be injected into the step directly:

```

```

| Persists over `run` calls | ✅ |
| --- | --- |
| Persists over process restarts | ✅ |
| Survives runtime errors | ✅ |

Ask AI
