# useWebWorkerFn

Category: Browser

Export Size: 888 B

Last Changed: 3 months ago

Related: [`useWebWorker`](https://vueuse.org/core/useWebWorker/)

Run expensive functions without blocking the UI, using a simple syntax that makes use of Promise. A port of [alewin/useWorker](https://github.com/alewin/useWorker).

## Usage

### Basic example

```ts
import { useWebWorkerFn } from '@vueuse/core'

const { workerFn } = useWebWorkerFn(() => {
  // some heavy works to do in web worker
})
```

### With dependencies

```ts
import { useWebWorkerFn } from '@vueuse/core'

const { workerFn, workerStatus, workerTerminate } = useWebWorkerFn(
  dates => dates.sort(dateFns.compareAsc),
  {
    timeout: 50000,
    dependencies: [
      'https://cdnjs.cloudflare.com/ajax/libs/date-fns/1.30.1/date_fns.js', // dateFns
    ],
  },
)
```

### With local dependencies

```ts
import { useWebWorkerFn } from '@vueuse/core'

const pow = (a: number) => a * a

const { workerFn, workerStatus, workerTerminate } = useWebWorkerFn(
  numbers => pow(numbers),
  {
    timeout: 50000,
    localDependencies: [pow]
  },
)
```

## Web Worker

Before you start using this function, we suggest you read the [Web Worker](https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API/Using_web_workers) documentation.

## Credit

This function is a Vue port of [https://github.com/alewin/useWorker](https://github.com/alewin/useWorker) by Alessio Koci, with the help of [@Donskelle](https://github.com/Donskelle) to migration.

## Type Declarations

```ts
export type WebWorkerStatus =
  | "PENDING"
  | "SUCCESS"
  | "RUNNING"
  | "ERROR"
  | "TIMEOUT_EXPIRED"

export interface UseWebWorkerOptions extends ConfigurableWindow {
  /**
   * Number of milliseconds before killing the worker
   *
   * @default undefined
   */
  timeout?: number
  /**
   * An array that contains the external dependencies needed to run the worker
   */
  dependencies?: string[]
  /**
   * An array that contains the local dependencies needed to run the worker
   */
  localDependencies?: Function[]
}

/**
 * Run expensive function without blocking the UI, using a simple syntax that makes use of Promise.
 *
 * @see https://vueuse.org/useWebWorkerFn
 * @param fn
 * @param options
 */
export declare function useWebWorkerFn<T extends (...fnArgs: any[]) => any>(
  fn: T,
  options?: UseWebWorkerOptions,
): {
  workerFn: (...fnArgs: Parameters<T>) => Promise<ReturnType<T>>
  workerStatus: Ref<WebWorkerStatus, WebWorkerStatus>
  workerTerminate: (status?: WebWorkerStatus) => void
}

export type UseWebWorkerFnReturn = ReturnType<typeof useWebWorkerFn>
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useWebWorkerFn/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useWebWorkerFn/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useWebWorkerFn/index.md)

## Changelog

### v12.0.0-beta.1 on 11/21/2024
- feat!: drop Vue 2 support, optimize bundles and clean up (#4349)

### v10.10.0 on 5/27/2024
- feat: support local function dependencies (#3899)

### v10.7.0 on 12/4/2023
- feat: upgrade deps (#3614)

### v10.4.0 on 8/25/2023
- fix(useWebWorker): prevent error event bubbling (#3141)
