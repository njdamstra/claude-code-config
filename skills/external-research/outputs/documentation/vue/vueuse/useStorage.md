[Skip to content](https://vueuse.org/core/useStorage/#VPContent)

On this page

# useStorage [​](https://vueuse.org/core/useStorage/\#usestorage)

Category

[State](https://vueuse.org/functions#category=State)

Export Size

2 kB

Last Changed

last month

Related

[`useColorMode`](https://vueuse.org/core/useColorMode/) [`useDark`](https://vueuse.org/core/useDark/) [`useLocalStorage`](https://vueuse.org/core/useLocalStorage/) [`useSessionStorage`](https://vueuse.org/core/useSessionStorage/) [`useStorageAsync`](https://vueuse.org/core/useStorageAsync/)

Create a reactive ref that can be used to access & modify [LocalStorage](https://developer.mozilla.org/en-US/docs/Web/API/Window/localStorage) or [SessionStorage](https://developer.mozilla.org/en-US/docs/Web/API/Window/sessionStorage).

Uses localStorage by default, other storage sources be specified via third argument.

## Demo [​](https://vueuse.org/core/useStorage/\#demo)

[source](https://github.com/vueuse/vueuse/blob/main/packages/core/useStorage/demo.vue) [playground (beta)](https://playground.vueuse.org/?vueuse=14.0.0-beta.1#eNqdU01vnDAQ/SsjLuxKLJAeVxA1bY+N1KqnSFxcGLZujW35g2aL+O8d22F3T1UTccDz8d543oyX7EHrcvaYHbPG9oZrBxad1yCYPLVd5myX3XeST1oZBwsYZL3j47kAb/GbU4adEFYYjZogf09E5K56ZTC/gJ4eHj+/JJzZJCjQyV5JS5Wc4fJEbNBeiHedBNhxqb07ApPnPbT3kaK8ZKdoAbtfBcwxvgQQAB9h584a1QgztG0L+eglsSqZ77ccoErOGwleDjhyiUPyr+n3EpyDtRYbyFJhgV+9cngEZzwWyT8K9fujEgJjkS9sGCjxCCMTNqWse/rtrx27H/gJR+aFo5YjuWQTceYfmKQvj6BeCWXI94SC+JPP8j8h7REH7qctzUvSqCaDLr8pyhwS9XU4u5yGciD7IFTPxMEmd17c3IUueAN/9xb8pUF8Dq1dZ5UoKaOp0n7RNpHhcNKCImQBNAOf44GOcbYwHyY1oKAFjPgyqNRlEIYblpKKxLX8ByKK+DpI0Pi/EKX003c0N7VoElekoacTiCYuyarpZB3qcCzru+Bnz2Tc1TWFohqxgja4PbqfVkkKLUuSc12biqJJqipp1VQ3CmbrXwQNSE8=)

```
name: Banana
color: Yellow
size: Medium
count: 0

```

## Usage [​](https://vueuse.org/core/useStorage/\#usage)

TIP

When using with Nuxt 3, this function will **NOT** be auto imported in favor of Nitro's built-in [`useStorage()`](https://nitro.unjs.io/guide/storage). Use explicit import if you want to use the function from VueUse.

ts

```
import {
 } from '@vueuse/core'

// bind object
const
 =
('my-store', {
: 'hi',
: 'Hello' })

// bind boolean
const
 =
('my-flag', true) // returns Ref<boolean>

// bind number
const
 =
('my-count', 0) // returns Ref<number>

// bind string with SessionStorage
const
 =
('my-id', 'some-string-id',
) // returns Ref<string>

// delete data from storage

.
 = null
```

## Merge Defaults [​](https://vueuse.org/core/useStorage/\#merge-defaults)

By default, [`useStorage`](https://vueuse.org/core/useStorage/) will use the value from storage if it is present and ignores the default value. Be aware that when you are adding more properties to the default value, the key might be `undefined` if client's storage does not have that key.

ts

```

.
('my-store', '{"hello": "hello"}')

const
 =
('my-store', {
: 'hi',
: 'hello' },
)

.
(
.
.
) // undefined, since the value is not presented in storage
```

To solve that, you can enable `mergeDefaults` option.

TypeScript

ts

```

.
('my-store', '{"hello": "nihao"}')

const
 =
(
  'my-store',
  {
: 'hi',
: 'hello' },

,
  {
: true } // <--
)

.
(
.
.
) // 'nihao', from storage

.
(
.
.
) // 'hello', from merged default value
```

js

```
localStorage.setItem('my-store', '{"hello": "nihao"}')
const state = useStorage(
  'my-store',
  { hello: 'hi', greeting: 'hello' },
  localStorage,
  { mergeDefaults: true },
)
console.log(state.value.hello) // 'nihao', from storage
console.log(state.value.greeting) // 'hello', from merged default value
```

When setting it to true, it will perform a **shallow merge** for objects. You can pass a function to perform custom merge (e.g. deep merge), for example:

TypeScript

ts

```
const
 =
(
  'my-store',
  {
: 'hi',
: 'hello' },

,
  {
: (
,
) => deepMerge(
,
) } // <--
)
```

js

```
const state = useStorage(
  'my-store',
  { hello: 'hi', greeting: 'hello' },
  localStorage,
  {
    mergeDefaults: (storageValue, defaults) =>
      deepMerge(defaults, storageValue),
  },
)
```

## Custom Serialization [​](https://vueuse.org/core/useStorage/\#custom-serialization)

By default, [`useStorage`](https://vueuse.org/core/useStorage/) will smartly use the corresponding serializer based on the data type of provided default value. For example, `JSON.stringify` / `JSON.parse` will be used for objects, `Number.toString` / `parseFloat` for numbers, etc.

You can also provide your own serialization function to [`useStorage`](https://vueuse.org/core/useStorage/):

TypeScript

ts

```
import {
 } from '@vueuse/core'

(
  'key',
  {},

,
  {


: {


: (
: any) =>
 ?
.
(
) : null,


: (
: any) =>
.
(
),
    },
  },
)
```

js

```
import { useStorage } from '@vueuse/core'
useStorage('key', {}, undefined, {
  serializer: {
    read: (v) => (v ? JSON.parse(v) : null),
    write: (v) => JSON.stringify(v),
  },
})
```

Please note when you provide `null` as the default value, [`useStorage`](https://vueuse.org/core/useStorage/) can't assume the data type from it. In this case, you can provide a custom serializer or reuse the built-in ones explicitly.

ts

```
import {
,
 } from '@vueuse/core'

const
 =
('key', null,
, {
:
.
 })

.
 = {
: 'bar' }
```

## Type Declarations [​](https://vueuse.org/core/useStorage/\#type-declarations)

Show Type Declarations

ts

```
export interface
<
> {

: (
: string) =>



: (
:
) => string
}
export interface
<
> {

: (
: string) =>
<
>


: (
:
) =>
<string>
}
export declare const
:
<
  "boolean" | "object" | "number" | "any" | "string" | "map" | "set" | "date",

<any>
>
export declare const
 = "vueuse-storage"
export interface StorageEventLike {

:
 | null

: StorageEvent["key"]

: StorageEvent["oldValue"]

: StorageEvent["newValue"]
}
export interface
<
>
  extends ConfigurableEventFilter,
    ConfigurableWindow,
    ConfigurableFlush {
  /**
   * Watch for deep changes
   *
   * @default true
   */

?: boolean
  /**
   * Listen to storage changes, useful for multiple tabs application
   *
   * @default true
   */

?: boolean
  /**
   * Write the default value to the storage when it does not exist
   *
   * @default true
   */

?: boolean
  /**
   * Merge the default value with the value read from the storage.
   *
   * When setting it to true, it will perform a **shallow merge** for objects.
   * You can pass a function to perform custom merge (e.g. deep merge), for example:
   *
   * @default false
   */

?: boolean | ((
:
,
:
) =>
)
  /**
   * Custom data serialization
   */

?:
<
>
  /**
   * On error callback
   *
   * Default log error to `console.error`
   */

?: (
: unknown) => void
  /**
   * Use shallow ref as reference
   *
   * @default false
   */

?: boolean
  /**
   * Wait for the component to be mounted before reading the storage.
   *
   * @default false
   */

?: boolean
}
export declare function
(

:
<string>,

:
<string>,

?:
,

?:
<string>,
):
<string>
export declare function
(

:
<string>,

:
<boolean>,

?:
,

?:
<boolean>,
):
<boolean>
export declare function
(

:
<string>,

:
<number>,

?:
,

?:
<number>,
):
<number>
export declare function
<
>(

:
<string>,

:
<
>,

?:
,

?:
<
>,
):
<
>
export declare function
<
 = unknown>(

:
<string>,

:
<null>,

?:
,

?:
<
>,
):
<
>
```

## Source [​](https://vueuse.org/core/useStorage/\#source)

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useStorage/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useStorage/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useStorage/index.md)
