# useWebWorker

Category: Browser

Export Size: 325 B

Last Changed: 2 months ago

Related: [`useWebWorkerFn`](https://vueuse.org/core/useWebWorkerFn/)

Simple [Web Workers](https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API/Using_web_workers) registration and communication.

## Usage

```ts
import { useWebWorker } from '@vueuse/core'

const { data, post, terminate, worker } = useWebWorker('/path/to/worker.js')
```

### State

| State | Type | Description |
| --- | --- | --- |
| data | `Ref<any>` | Reference to the latest data received via the worker, can be watched to respond to incoming messages |
| worker | `ShallowRef<Worker | undefined>` | Reference to the instance of the WebWorker |

### Methods

| Method | Signature | Description |
| --- | --- | --- |
| post | `(message: any, transfer: Transferable[]): void`<br>`(message: any, options?: StructuredSerializeOptions | undefined): void` | Sends data to the worker thread. |
| terminate | `() => void` | Stops and terminates the worker. |

## Type Declarations

```ts
type WorkerFunction = (typeof Worker.prototype)["postMessage"]

export interface UseWebWorkerReturn<Data = any> {
  data: Ref<Data>
  post: WorkerFunction
  terminate: () => void
  worker: ShallowRef<Worker | undefined>
}

type WorkerInstanceFactory = (...args: unknown[]) => Worker

/**
 * Simple Web Workers registration and communication.
 *
 * @see https://vueuse.org/useWebWorker
 * @param url
 * @param workerOptions
 * @param options
 */
export declare function useWebWorker<Data = any>(
  url: string,
  workerOptions?: WorkerOptions,
  options?: ConfigurableWindow,
): UseWebWorkerReturn<Data>

/**
 * Simple Web Workers registration and communication.
 *
 * @see https://vueuse.org/useWebWorker
 */
export declare function useWebWorker<Data = any>(
  worker: Worker | WorkerInstanceFactory,
): UseWebWorkerReturn<Data>
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useWebWorker/index.ts) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useWebWorker/index.md)

## Changelog

### v12.0.0-beta.1 on 11/21/2024
- feat!: drop Vue 2 support, optimize bundles and clean up (#4349)

### v10.2.0 on 6/16/2023
- fix: add web worker transferable option (#3123)
