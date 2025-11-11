# makeDestructurable

**Category**: Utilities
**Export Size**: 201 B
**Last Changed**: 2 months ago

Make isomorphic destructurable for object and array at the same time. See this blog for more details.

## Usage

### TypeScript Example:

```ts
import { makeDestructurable } from '@vueuse/core'

const foo = { name: 'foo' }
const bar = 1024
const obj = makeDestructurable(
  { foo, bar } as const,
  [foo, bar] as const,
)
```

### Usage:

```ts
let { foo, bar } = obj
let [foo, bar] = obj
```

## Type Declarations

```ts
export declare function makeDestructurable < T extends Record <string, unknown>, A extends readonly any[], >( obj : T , arr : A ): T & A
```

## Source

[Source](https://vueuse.org/shared/makeDestructurable/) • [Docs](https://vueuse.org/shared/makeDestructurable/)

## Contributors

* Anthony Fu
* SerKo
* Breno A
* enpitsulin

## Changelog

* **v13.6.0** on 7/28/2025
  * `d32f8` - refactor: add `@__NO_SIDE_EFFECTS__` annotations to all pure functions (#4907)
* **v10.10.1** on 6/11/2024
  * `842d7` - fix: fix Typescript < 5.0.0 support (#4028)
* **v10.10.0** on 5/27/2024
  * `4ea13` - feat: support parameters without as const (#3971)
