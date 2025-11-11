[Skip to content](https://vueuse.org/shared/until/#VPContent)

On this page

# until [​](https://vueuse.org/shared/until/\#until)

Category

[Watch](https://vueuse.org/functions#category=Watch)

Export Size

609 B

Last Changed

2 weeks ago

Promised one-time watch for changes

## Demo [​](https://vueuse.org/shared/until/\#demo)

[source](https://github.com/vueuse/vueuse/blob/main/packages/shared/until/demo.vue) [playground (beta)](https://playground.vueuse.org/?vueuse=14.0.0-beta.1#eNptUMFuwjAM/ZW3XlokRI9IqCDYdtknTOqlCx5UtHaUuKCp6r/PbTn0QKQkdvzei5/75OT95t5RskuK6ELtFZG082gqvuzLRGOZHEquWy9B0aPmu9xojY61buyK9CEWU8CA3yAt0qOp2XPuJFBacslOOI5UNwLXpuDWOJMzwn7Bz1YjdpbPqvjHDtkK+wP6koHqUdU6f5pNOquNyjtl24ll9YaCZum3dLiIYvuWWmGwXeSzK/NgiVLrm0rJMqBgseh0PkMF2/GIV3lArzTLbYp8QkxYf5j63KF/GsEwFLmfiz+dqjCOrqndzYZmFs3OODfY+mIXqCXWCZvP4NdEG8uC+EmviUW+8JEM/9y9mb4=)

Add to 7 to show the alert.

Count: 0

Increment  Decrement

## Usage [​](https://vueuse.org/shared/until/\#usage)

#### Wait for some async data to be ready [​](https://vueuse.org/shared/until/\#wait-for-some-async-data-to-be-ready)

ts

```
import {
,
 } from '@vueuse/core'

const {
,
 } =
(

('https://jsonplaceholder.typicode.com/todos/1').
(
 =>
.
()),
  {},
)

;(async () => {
  await
(
).
(true)


.
(
) // state is now ready!
})()
```

#### Wait for custom conditions [​](https://vueuse.org/shared/until/\#wait-for-custom-conditions)

> You can use `invoke` to call the async function.

ts

```
import {
,
,
 } from '@vueuse/core'

const {
 } =
()

(async () => {
  await
(
).
(
 =>
 > 7)


('Counter is now larger than 7!')
})
```

#### Timeout [​](https://vueuse.org/shared/until/\#timeout)

ts

```
// will be resolve until ref.value === true or 1000ms passed
await
(
).
(true, {
: 1000 })

// will throw if timeout
try {
  await
(
).
(true, {
: 1000,
: true })
  // ref.value === true
}
catch (
) {
  // timeout
}
```

#### More Examples [​](https://vueuse.org/shared/until/\#more-examples)

ts

```
await
(
).
(true)
await
(
).
(
 =>
 > 10 &&
 < 100)
await
(
).
()
await
(
).
(10)
await
(
).
()
await
(
).
()

await
(
).
.
()
await
(
).
.
()
```

## Type Declarations [​](https://vueuse.org/shared/until/\#type-declarations)

Show Type Declarations

ts

````
export interface UntilToMatchOptions {
  /**
   * Milliseconds timeout for promise to resolve/reject if the when condition does not meet.
   * 0 for never timed out
   *
   * @default 0
   */

?: number
  /**
   * Reject the promise when timeout
   *
   * @default false
   */

?: boolean
  /**
   * `flush` option for internal watch
   *
   * @default 'sync'
   */

?:

  /**
   * `deep` option for internal watch
   *
   * @default 'false'
   */

?:
["deep"]
}
export interface
<
,
 extends boolean = false> {

: (<
 extends
 =
>(

: (
:
) =>
 is
,

?: UntilToMatchOptions,
  ) =>
 extends true ?
<
<
,
>> :
<
>) &
    ((

: (
:
) => boolean,

?: UntilToMatchOptions,
    ) =>
<
>)

: (
?: UntilToMatchOptions) =>
<
>

: (
?: number,
?: UntilToMatchOptions) =>
<
>
}
type
 = false | void | null | undefined | 0 | 0n | ""
export interface
<
,
 extends boolean = false>
  extends
<
,
> {
  readonly
:
<
,
 extends true ? false : true>

: <
 =
>(

:
<
>,

?: UntilToMatchOptions,
  ) =>
 extends true ?
<
> :
<
>

: (

?: UntilToMatchOptions,
  ) =>
 extends true ?
<
 &
> :
<
<
,
>>

: (

?: UntilToMatchOptions,
  ) =>
 extends true ?
<
<
, null>> :
<null>

: (

?: UntilToMatchOptions,
  ) =>
 extends true ?
<
<
, undefined>> :
<undefined>

: (
?: UntilToMatchOptions) =>
<
>
}
export interface
<
> extends
<
> {
  readonly
:
<
>

: (

:
<
<
<
>>>,

?: UntilToMatchOptions,
  ) =>
<
>
}
/**
 * Promised one-time watch for changes
 *
 * @see https://vueuse.org/until
 * @example
 * ```
 * const { count } = useCounter()
 *
 * await until(count).toMatch(v => v > 7)
 *
 * alert('Counter is now larger than 7!')
 * ```
 */
export declare function
<
 extends unknown[]>(

:
<
> |
<
>,
):
<
>
export declare function
<
>(

:
<
> |
<
>,
):
<
>
````

## Source [​](https://vueuse.org/shared/until/\#source)

[Source](https://github.com/vueuse/vueuse/blob/main/packages/shared/until/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/shared/until/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/shared/until/index.md)
