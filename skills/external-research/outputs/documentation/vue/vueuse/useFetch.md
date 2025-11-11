# useFetch

Category: [Network](https://vueuse.org/functions#category=Network)

Export Size: 2.28 kB

Reactive [Fetch API](https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API) provides the ability to abort requests, intercept requests before they are fired, automatically refetch requests when the url changes, and create your own `useFetch` with predefined options.

[Learn useFetch with this FREE video lesson from Vue School!](https://vueschool.io/lessons/vueuse-utilities-usefetch-and-reactify?friend=vueuse)

**TIP**: When using with Nuxt 3, this function will **NOT** be auto imported in favor of Nuxt's built-in `useFetch()`. Use explicit import if you want to use the function from VueUse.

## Basic Usage

The `useFetch` function can be used by simply providing a url. The url can be either a string or a `ref`. The `data` object will contain the result of the request, the `error` object will contain any errors, and the `isFetching` object will indicate if the request is loading.

```ts
import { useFetch } from '@vueuse/core'

const { data, error, isFetching } = useFetch(url)
```

## Asynchronous Usage

`useFetch` can also be awaited just like a normal fetch. Note that whenever a component is asynchronous, whatever component that uses it must wrap the component in a `<Suspense>` tag.

```ts
const { data, error, isFetching } = await useFetch(url)
```

## Refetching on URL change

Using a `ref` for the url parameter will allow the `useFetch` function to automatically trigger another request when the url is changed.

```ts
const url = ref('https://my-api.com/user/1')

const { data } = useFetch(url, { refetch: true })

url.value = 'https://my-api.com/user/2' // Will trigger another request
```

## Prevent request from firing immediately

Setting the `immediate` option to false will prevent the request from firing until the `execute` function is called.

```ts
const { execute } = useFetch(url, { immediate: false })

execute()
```

## Aborting a request

A request can be aborted by using the `abort` function from the `useFetch` function. The `canAbort` property indicates if the request can be aborted.

```ts
const { abort, canAbort } = useFetch(url)

setTimeout(() => {
  if (canAbort.value)
    abort()
}, 100)
```

A request can also be aborted automatically by using `timeout` property.

```ts
const { data } = useFetch(url, { timeout: 100 })
```

## Setting the request method and return type

The request method and return type can be set by adding the appropriate methods to the end of `useFetch`

```ts
// Request will be sent with GET method and data will be parsed as JSON
const { data } = useFetch(url).get().json()

// Request will be sent with POST method and data will be parsed as text
const { data } = useFetch(url).post().text()
```

## Creating a Custom Instance

The `createFetch` function will return a useFetch function with whatever pre-configured options that are provided to it. This is useful for interacting with API's throughout an application that uses the same base URL or needs Authorization headers.

```ts
const useMyFetch = createFetch({
  baseUrl: 'https://my-api.com',
  options: {
    async beforeFetch({ options }) {
      const myToken = await getMyToken()
      options.headers.Authorization = `Bearer ${myToken}`

      return { options }
    },
  },
  fetchOptions: {
    mode: 'cors',
  },
})

const { isFetching, error, data } = useMyFetch('users')
```

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useFetch/index.ts)
