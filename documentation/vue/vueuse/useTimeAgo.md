# useTimeAgo

**Category:** Time
**Export Size:** 1.42 kB
**Last Changed:** 2 months ago

Reactive time ago. Automatically update the time ago string when the time changes.

## Usage

```ts
import { useTimeAgo } from '@vueuse/core'

const timeAgo = useTimeAgo(new Date(2021, 0, 1))
```

## Component Usage

This function also provides a renderless component version via the `@vueuse/components` package.

```vue
<template>
  <UseTimeAgo v-slot="{ timeAgo }" :time="new Date(2021, 0, 1)">
    Time Ago: {{ timeAgo }}
  </UseTimeAgo>
</template>
```

## Non-Reactivity Usage

In case you don't need the reactivity, you can use the `formatTimeAgo` function to get the formatted string instead of a Ref.

```ts
import { formatTimeAgo } from '@vueuse/core'

const timeAgo = formatTimeAgo(new Date(2021, 0, 1)) // string
```

## Type Declarations

```ts
export type UseTimeAgoFormatter<T = number> = (
  value: T,
  isPast: boolean,
) => string

export type UseTimeAgoUnitNames =
  | "second"
  | "minute"
  | "hour"
  | "day"
  | "week"
  | "month"
  | "year"

export interface UseTimeAgoMessagesBuiltIn {
  justNow: string
  past: string | UseTimeAgoFormatter<string>
  future: string | UseTimeAgoFormatter<string>
  invalid: string
}

export type UseTimeAgoMessages<
  UnitNames extends string = UseTimeAgoUnitNames,
> = UseTimeAgoMessagesBuiltIn &
  Record<UnitNames, string | UseTimeAgoFormatter<number>>

export interface UseTimeAgoOptions<
  UnitNames extends string = UseTimeAgoUnitNames,
> {
  /**
   * Maximum unit (of diff in milliseconds) to display the full date instead of relative
   *
   * @default undefined
   */
  max?: UnitNames | number

  /**
   * Formatter for full date
   */
  fullDateFormatter?: (date: Date) => string

  /**
   * Messages for formatting the string
   */
  messages?: UseTimeAgoMessages<UnitNames>

  /**
   * Minimum display time unit (default is minute)
   *
   * @default false
   */
  showSecond?: boolean

  /**
   * Rounding method to apply.
   *
   * @default 'round'
   */
  rounding?: "round" | "ceil" | "floor" | number

  /**
   * Custom units
   */
  units?: UseTimeAgoUnit<UnitNames>[]
}

export interface UseTimeAgoReactiveOptions<
  Controls extends boolean,
  UnitNames extends string = UseTimeAgoUnitNames,
> extends UseTimeAgoOptions<UnitNames> {
  /**
   * Expose more controls
   *
   * @default false
   */
  controls?: Controls

  /**
   * Intervals to update, set 0 to disable auto update
   *
   * @default 30_000
   */
  updateInterval?: number
}

export interface UseTimeAgoUnit<
  UnitNames extends string = UseTimeAgoUnitNames,
> {
  max: number
  value: number
  name: UnitNames
}

export type UseTimeAgoReturn<Controls extends boolean = false> =
  Controls extends true
    ? {
        timeAgo: ComputedRef<string>
      } & Pausable
    : ComputedRef<string>

/**
 * Reactive time ago formatter.
 *
 * @see https://vueuse.org/useTimeAgo
 */
export declare function useTimeAgo<
  UnitNames extends string = UseTimeAgoUnitNames,
>(
  time: MaybeRefOrGetter<Date | number | string>,
  options?: UseTimeAgoReactiveOptions<false, UnitNames>,
): UseTimeAgoReturn<false>

export declare function useTimeAgo<
  UnitNames extends string = UseTimeAgoUnitNames,
>(
  time: MaybeRefOrGetter<Date | number | string>,
  options: UseTimeAgoReactiveOptions<true, UnitNames>,
): UseTimeAgoReturn<true>

export declare function formatTimeAgo<
  UnitNames extends string = UseTimeAgoUnitNames,
>(
  from: Date,
  options?: UseTimeAgoOptions<UnitNames>,
  now?: Date | number,
): string
```

## Key Features

- **Automatic Updates**: Automatically updates the time ago string (default: every 30 seconds)
- **Customizable Messages**: Fully customizable text for all time units
- **Multiple Languages**: Easy internationalization support
- **Custom Units**: Define your own time units
- **Rounding Options**: Control how time differences are rounded
- **Max Display**: Show full date after a certain time threshold
- **Controls**: Optional pause/resume functionality
- **Non-reactive Version**: Available via `formatTimeAgo` function

## Options

- `max` - Maximum unit or milliseconds to display full date instead of relative (default: `undefined`)
- `fullDateFormatter` - Custom formatter for full date display
- `messages` - Custom messages for formatting the string
- `showSecond` - Show seconds in the output (default: `false`)
- `rounding` - Rounding method: `'round'`, `'ceil'`, `'floor'`, or number (default: `'round'`)
- `units` - Custom time units
- `controls` - Expose pause/resume controls (default: `false`)
- `updateInterval` - Update interval in milliseconds, set to 0 to disable (default: `30000`)

## Default Messages

```ts
{
  justNow: 'just now',
  past: n => n.match(/\d/) ? `${n} ago` : n,
  future: n => n.match(/\d/) ? `in ${n}` : n,
  month: (n, past) => n === 1
    ? past ? 'last month' : 'next month'
    : `${n} month${n > 1 ? 's' : ''}`,
  year: (n, past) => n === 1
    ? past ? 'last year' : 'next year'
    : `${n} year${n > 1 ? 's' : ''}`,
  day: (n, past) => n === 1
    ? past ? 'yesterday' : 'tomorrow'
    : `${n} day${n > 1 ? 's' : ''}`,
  week: (n, past) => n === 1
    ? past ? 'last week' : 'next week'
    : `${n} week${n > 1 ? 's' : ''}`,
  hour: n => `${n} hour${n > 1 ? 's' : ''}`,
  minute: n => `${n} minute${n > 1 ? 's' : ''}`,
  second: n => `${n} second${n > 1 ? 's' : ''}`,
  invalid: ''
}
```

## Examples

### Basic Usage
```ts
const timeAgo = useTimeAgo(new Date(2021, 0, 1))
// => "4 years ago"
```

### Show Seconds
```ts
const timeAgo = useTimeAgo(new Date(), { showSecond: true })
// => "just now" or "5 seconds ago"
```

### With Max Display
```ts
const timeAgo = useTimeAgo(new Date(2020, 0, 1), {
  max: 'month',
  fullDateFormatter: (date) => date.toLocaleDateString()
})
// If more than a month ago, shows full date
```

### Custom Messages
```ts
const timeAgo = useTimeAgo(date, {
  messages: {
    justNow: 'right now',
    past: n => `${n} earlier`,
    future: n => `${n} from now`,
    second: n => `${n}s`,
    minute: n => `${n}m`,
    hour: n => `${n}h`,
    day: n => `${n}d`,
    week: n => `${n}w`,
    month: n => `${n}mo`,
    year: n => `${n}y`,
    invalid: 'Invalid date'
  }
})
```

### With Controls
```ts
const { timeAgo, pause, resume, isActive } = useTimeAgo(date, {
  controls: true
})

// Pause updates
pause()

// Resume updates
resume()
```

### Custom Update Interval
```ts
// Update every 5 seconds
const timeAgo = useTimeAgo(date, { updateInterval: 5000 })

// Disable auto-update
const timeAgo = useTimeAgo(date, { updateInterval: 0 })
```

### Internationalization
```ts
// French
const timeAgoFr = useTimeAgo(date, {
  messages: {
    justNow: 'à l\'instant',
    past: n => `il y a ${n}`,
    future: n => `dans ${n}`,
    second: n => `${n} seconde${n > 1 ? 's' : ''}`,
    minute: n => `${n} minute${n > 1 ? 's' : ''}`,
    hour: n => `${n} heure${n > 1 ? 's' : ''}`,
    day: n => `${n} jour${n > 1 ? 's' : ''}`,
    week: n => `${n} semaine${n > 1 ? 's' : ''}`,
    month: n => `${n} mois`,
    year: n => `${n} an${n > 1 ? 's' : ''}`,
    invalid: 'Date invalide'
  }
})
```

### Custom Rounding
```ts
// Always round up
const timeAgo = useTimeAgo(date, { rounding: 'ceil' })

// Always round down
const timeAgo = useTimeAgo(date, { rounding: 'floor' })
```

## Use Cases

- **Social Media**: Display post timestamps ("5 minutes ago")
- **Comment Sections**: Show when comments were posted
- **Activity Feeds**: Display when activities occurred
- **Last Updated**: Show when content was last modified
- **Notifications**: Display notification timestamps
- **Chat Applications**: Show message timestamps

## Comparison with Alternatives

### vs moment.js / dayjs
- **Lighter**: No external dependencies
- **Reactive**: Automatically updates
- **Vue-Native**: Designed for Vue's reactivity system

### vs Intl.RelativeTimeFormat
- **More Flexible**: Customizable messages and units
- **Auto-updating**: Built-in update mechanism
- **Simpler API**: Easier to use and configure

## References

- [VueUse Documentation](https://vueuse.org/core/useTimeAgo/)
- [Source Code](https://github.com/vueuse/vueuse/blob/main/packages/core/useTimeAgo/index.ts)
