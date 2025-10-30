# LlamaIndex Python Async Patterns

[Skip to content](https://developers.llamaindex.ai/python/framework/getting_started/async_python/#_top)

# Async Programming in Python

If you are new to async programming in Python, this page is for you.

In LlamaIndex specifically, many operations and functions support async execution. This allows you to run multiple operations at the same time without blocking the main thread, which helps improve overall throughput and performance in many cases.

Here are some of the key concepts you should understand:

## 1. The Basics of `asyncio`

[Section titled "1. The Basics of asyncio"](https://developers.llamaindex.ai/python/framework/getting_started/async_python/#1-the-basics-of-asyncio)

- **Event Loop**:
The event loop handles the scheduling and execution of async operations. It continuously checks for and executes tasks (coroutines). All async operations run by this loop, and there can only be one event loop per thread.

- **`asyncio.run()`**:
This function is the entry point for running an asynchronous program. It creates and manages the event loop and cleans up after it completes. Remember that it is designed to be called once per thread. Some frameworks like FastAPI will run the event loop for you, others will require you to run it yourself.

- **Async + Python Notebooks**:
Python notebooks are a special case where the event loop is already running. This means you don't need to call `asyncio.run()` yourself, and can directly call and await async functions.


## 2. Async Functions and `await`

[Section titled "2. Async Functions and await"](https://developers.llamaindex.ai/python/framework/getting_started/async_python/#2-async-functions-and-await)

- **Defining Async Functions**:
Use the `async def` syntax to define an asynchronous function (coroutine). Instead of executing immediately, calling an async function returns a coroutine object that needs to be scheduled and run.

- **Using `await`**:
Inside an async function, `await` is used to pause execution of that function until the awaited task is complete. When you write `await some_fn()`, the function yields control back to the event loop so that other tasks can be scheduled and run. Only one async function executes at a time, and they cooperate by yielding with `await`.


## 3. Concurrency Explained

[Section titled "3. Concurrency Explained"](https://developers.llamaindex.ai/python/framework/getting_started/async_python/#3-concurrency-explained)

- **Cooperative Concurrency**:
Although you can schedule multiple async tasks, only one task runs at a time. This is different from true parallelism, where multiple tasks run at the same time. When a task hits an `await`, it suspends its execution so that another task may run. This makes async programs excellent for I/O-bound tasks where waiting is common, such as API calls to LLMs and other services.

- **Not True Parallelism**:
Asyncio enables concurrency but does not run tasks in parallel. For CPU-bound work requiring parallel execution, consider threading or multiprocessing. LlamaIndex typically avoids multiprocessing in most cases, and leaves it up to the user to implement, as it can be complex to do so in a way that is safe and efficient.


## 4. Handling Blocking (Synchronous) Code

[Section titled "4. Handling Blocking (Synchronous) Code"](https://developers.llamaindex.ai/python/framework/getting_started/async_python/#4-handling-blocking-synchronous-code)

- **`asyncio.to_thread()`**:
Sometimes you need to run synchronous (blocking) code without freezing your async program. `asyncio.to_thread()` offloads the blocking code to a separate thread, allowing the event loop to continue processing other tasks. Use it cautiously, as it adds some overhead and can make debugging more challenging.

- **Alternative: Executors**:
You might also encounter the use of `loop.run_in_executor()` to handle blocking functions.


## 5. A Practical Example

[Section titled "5. A Practical Example"](https://developers.llamaindex.ai/python/framework/getting_started/async_python/#5-a-practical-example)

Below is an example demonstrating how to write and run async functions with `asyncio`:

```python
import asyncio

async def fetch_data(source):
    """Simulate fetching data from a source"""
    print(f"Fetching from {source}...")
    await asyncio.sleep(2)  # Simulate I/O operation
    return f"Data from {source}"

async def main():
    # Run tasks concurrently
    results = await asyncio.gather(
        fetch_data("API 1"),
        fetch_data("API 2"),
        fetch_data("API 3")
    )

    for result in results:
        print(result)

# Run the async program
if __name__ == "__main__":
    asyncio.run(main())
```

This example demonstrates:
- How to define async functions with `async def`
- How to use `await` to pause execution
- How to run multiple async operations concurrently with `asyncio.gather()`
- How to start an async program with `asyncio.run()`

## LlamaIndex Async Patterns

In LlamaIndex, many operations have async equivalents:

- **Async Chat**: Use `astream_chat()` instead of `stream_chat()`
- **Async Query**: Use `aquery()` instead of `query()`
- **Async Retrieval**: Use `aretrieve()` instead of `retrieve()`

Example:
```python
import asyncio
from llama_index.llms.openai import OpenAI

async def main():
    llm = OpenAI(model="gpt-4")

    # Async streaming
    response = await llm.astream_chat([
        {"role": "user", "content": "Tell me a story"}
    ])

    async for chunk in response:
        print(chunk.delta, end="", flush=True)

if __name__ == "__main__":
    asyncio.run(main())
```
