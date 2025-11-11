# useTimeAgoIntl

**Category**: Time
**Export Size**: 1.42 kB
**Last Changed**: 2 weeks ago

Reactive time ago with i18n support.

## Usage

`useTimeAgoIntl` provides a reactive "time ago" string that automatically updates as time passes. It uses the browser's `Intl.RelativeTimeFormat` API for internationalization.

```ts
import { useTimeAgoIntl } from '@vueuse/core'

// The time ago string will be automatically updated
const timeAgo = useTimeAgoIntl(new Date(2021, 0, 1))
```

### Non-Reactive Usage

If you don't need reactivity, you can use the `formatTimeAgoIntl` function to get a static formatted string.

```ts
import { formatTimeAgoIntl } from '@vueuse/core'

const timeAgo = formatTimeAgoIntl(new Date(2021, 0, 1)) // returns a string
```

## Options

You can customize the output by providing options for the `locale` and `Intl.RelativeTimeFormat`.

```ts
import { useTimeAgoIntl } from '@vueuse/core'

const timeAgo = useTimeAgoIntl(new Date(), {
  locale: 'fr-FR',
  relativeTimeFormatOptions: {
    numeric: 'auto',
  },
})
```

## Type Declarations

```ts
export interface UseTimeAgoIntlOptions extends UseTimeAgoOptions {
  /**
   * The locale to use.
   *
   * @default undefined
   */
  locale?: MaybeRefOrGetter<string | string[] | undefined>
  /**
   * `Intl.RelativeTimeFormat` options.
   *
   * @default undefined
   */
  relativeTimeFormatOptions?: Intl.RelativeTimeFormatOptions
  /**
   * A function to customize the final output.
   */
  join?: (parts: Intl.RelativeTimeFormatPart[]) => string
  /**
   * Expose the raw parts of the formatted time.
   *
   * @default false
   */
  expose?: boolean
}

export declare function useTimeAgoIntl<Controls extends boolean>(
  time: MaybeRefOrGetter<Date | number | string>,
  options?: UseTimeAgoIntlOptions<Controls>,
): UseTimeAgoReturn<Controls>
```

## Source

- [Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useTimeAgoIntl/index.ts)
- [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useTimeAgoIntl/index.md)
