[Skip to content](https://vueuse.org/core/useManualRefHistory/#VPContent)

On this page

# useManualRefHistory [​](https://vueuse.org/core/useManualRefHistory/\#usemanualrefhistory)

Category

[State](https://vueuse.org/functions#category=State)

Export Size

518 B

Last Changed

8 months ago

Related

[`useRefHistory`](https://vueuse.org/core/useRefHistory/)

Manually track the change history of a ref when the using calls `commit()`, also provides undo and redo functionality

## Demo [​](https://vueuse.org/core/useManualRefHistory/\#demo)

[source](https://github.com/vueuse/vueuse/blob/main/packages/core/useManualRefHistory/demo.vue) [playground (beta)](https://playground.vueuse.org/?vueuse=14.0.0-beta.1#eNqNU02PmzAQ/SsmWqnlMA27SHuoUli04hdwzYFhYuiI+dKME6hC/juepGkbcRvbz89+z9MXDyFsuhaLbVElFXUgSEhtACPd264uKNXFXe20DT4S9NAmfFCkO3w0aNERDPAavYXVPybhYql8xNVFg/I2tITNCcg4rtdOeZcI5IJs94N/fT0j3/HA9Zluvb6G3d2yfdNJ0+L9ppEkWcT9Rjfw9QUr1xqzYp6qnBSyHg4IbTCSkCOAynnC/ABQRqbEyu2LuK2LnBsRAE9oUBHQHkE7XiLBCxr/AeTZMhzzas+uYRoZy0w5kTe6W3JP0VvUzfkllDdJ/J4Sttmec7dHkAziz2KjatxjegN04tVHJte8HvydhwBs2bmcPmfoEDDfFj/pApZtE7pZQueNr+xB3MCV1U58iJuLLvZQ4d6bBvPs51+9Hp7n8qS+ZPknH872UhZzFPK/jTHffzo9HO+5PapMQbpTX15ahKitjAfu7/vxYwwDH5dhi4lVeXHjYvgGagbzpA==)

Count: 0

Increment  Decrement / Commit  Undo  Redo

History (limited to 10 records for demo)

2025-10-01 17:04:30{ value: 0 }

## Usage [​](https://vueuse.org/core/useManualRefHistory/\#usage)

ts

```
import {
} from '@vueuse/core'
import {
} from 'vue'

const
=
(0)
const {
,
,
,
} =
(
)

.
+= 1

()

.
(
.
)
/* [\
  { snapshot: 1, timestamp: 1601912898062 },\
  { snapshot: 0, timestamp: 1601912898061 }\
] */
```

You can use `undo` to reset the ref value to the last history point.

ts

```

.
(
.
) // 1

()

.
(
.
) // 0
```

#### History of mutable objects [​](https://vueuse.org/core/useManualRefHistory/\#history-of-mutable-objects)

If you are going to mutate the source, you need to pass a custom clone function or use `clone` `true` as a param, that is a shortcut for a minimal clone function `x => JSON.parse(JSON.stringify(x))` that will be used in both `dump` and `parse`.

ts

```
import {
} from '@vueuse/core'
import {
} from 'vue'

const
=
({
: 1,
: 2 })
const {
,
,
,
} =
(
, {
: true })

.
.
+= 1

()
```

#### Custom Clone Function [​](https://vueuse.org/core/useManualRefHistory/\#custom-clone-function)

To use a full featured or custom clone function, you can set up via the `clone` options.

For example, using [structuredClone](https://developer.mozilla.org/en-US/docs/Web/API/structuredClone):

ts

```
import {
} from '@vueuse/core'

const
=
(target, {
:
})
```

Or by using [lodash's `cloneDeep`](https://lodash.com/docs/4.17.15#cloneDeep):

ts

```
import {
} from '@vueuse/core'
import {
} from 'lodash-es'

const
=
(target, {
:
})
```

Or a more lightweight [`klona`](https://github.com/lukeed/klona):

ts

```
import {
} from '@vueuse/core'
import {
} from 'klona'

const
=
(target, {
:
})
```

#### Custom Dump and Parse Function [​](https://vueuse.org/core/useManualRefHistory/\#custom-dump-and-parse-function)

Instead of using the `clone` options, you can pass custom functions to control the serialization and parsing. In case you do not need history values to be objects, this can save an extra clone when undoing. It is also useful in case you want to have the snapshots already stringified to be saved to local storage for example.

ts

```
import {
} from '@vueuse/core'

const
=
(target, {

:
.
,

:
.
,
})
```

### History Capacity [​](https://vueuse.org/core/useManualRefHistory/\#history-capacity)

We will keep all the history by default (unlimited) until you explicitly clear them up, you can set the maximal amount of history to be kept by `capacity` options.

ts

```
import {
} from '@vueuse/core'

const
=
(target, {

: 15, // limit to 15 history records
})

.
() // explicitly clear all the history
```

## Type Declarations [​](https://vueuse.org/core/useManualRefHistory/\#type-declarations)

Show Type Declarations

ts

```
export interface
<
> {

:


: number
}
export interface
<
,
=
> {
  /**
   * Maximum number of history to be kept. Default to unlimited.
   */

?: number
  /**
   * Clone when taking a snapshot, shortcut for dump: JSON.parse(JSON.stringify(value)).
   * Default to false
   *
   * @default false
   */

?: boolean |
<
>
  /**
   * Serialize data into the history
   */

?: (
:
) =>


  /**
   * Deserialize data from the history
   */

?: (
:
) =>

  /**
   * set data source
   */

?: (
:
<
>,
:
) => void
}
export interface
<
,
> {
  /**
   * Bypassed tracking ref from the argument
   */

:
<
>
  /**
   * An array of history records for undo, newest comes to first
   */

:
<
<
>[]>
  /**
   * Last history point, source can be different if paused
   */

:
<
<
>>
  /**
   * Same as {@link UseManualRefHistoryReturn.history | history}
   */

:
<
<
>[]>
  /**
   * Records array for redo
   */

:
<
<
>[]>
  /**
   * A ref representing if undo is possible (non empty undoStack)
   */

:
<boolean>
  /**
   * A ref representing if redo is possible (non empty redoStack)
   */

:
<boolean>
  /**
   * Undo changes
   */

: () => void
  /**
   * Redo changes
   */

: () => void
  /**
   * Clear all the history
   */

: () => void
  /**
   * Create a new history record
   */

: () => void
  /**
   * Reset ref's value with latest history
   */

: () => void
}
/**
 * Track the change history of a ref, also provides undo and redo functionality.
 *
 * @see https://vueuse.org/useManualRefHistory
 * @param source
 * @param options
 */
export declare function
<
,
=
>(

:
<
>,

?:
<
,
>,
):
<
,
>
```

## Source [​](https://vueuse.org/core/useManualRefHistory/\#source)

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useManualRefHistory/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useManualRefHistory/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useManualRefHistory/index.md)
