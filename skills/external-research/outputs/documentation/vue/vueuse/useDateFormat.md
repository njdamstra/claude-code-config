# useDateFormat

**Category:** Time
**Export Size:** 972 B
**Last Changed:** 2 months ago

Get the formatted date according to the string of tokens passed in, inspired by [dayjs](https://github.com/iamkun/dayjs).

## Format Tokens

**List of all available formats (HH:mm:ss by default):**

| Format | Output | Description |
|--------|--------|-------------|
| `Yo` | 2018th | Ordinal formatted year |
| `YY` | 18 | Two-digit year |
| `YYYY` | 2018 | Four-digit year |
| `M` | 1-12 | The month, beginning at 1 |
| `Mo` | 1st, 2nd, ..., 12th | The month, ordinal formatted |
| `MM` | 01-12 | The month, 2-digits |
| `MMM` | Jan-Dec | The abbreviated month name |
| `MMMM` | January-December | The full month name |
| `D` | 1-31 | The day of the month |
| `Do` | 1st, 2nd, ..., 31st | The day of the month, ordinal formatted |
| `DD` | 01-31 | The day of the month, 2-digits |
| `H` | 0-23 | The hour |
| `Ho` | 0th, 1st, 2nd, ..., 23rd | The hour, ordinal formatted |
| `HH` | 00-23 | The hour, 2-digits |
| `h` | 1-12 | The hour, 12-hour clock |
| `ho` | 1st, 2nd, ..., 12th | The hour, 12-hour clock, sorted |
| `hh` | 01-12 | The hour, 12-hour clock, 2-digits |
| `m` | 0-59 | The minute |
| `mo` | 0th, 1st, ..., 59th | The minute, ordinal formatted |
| `mm` | 00-59 | The minute, 2-digits |
| `s` | 0-59 | The second |
| `so` | 0th, 1st, ..., 59th | The second, ordinal formatted |
| `ss` | 00-59 | The second, 2-digits |
| `SSS` | 000-999 | The millisecond, 3-digits |
| `A` | AM PM | The meridiem |
| `AA` | A.M. P.M. | The meridiem, periods |
| `a` | am pm | The meridiem, lowercase |
| `aa` | a.m. p.m. | The meridiem, lowercase and periods |
| `d` | 0-6 | The day of the week, with Sunday as 0 |
| `dd` | S-S | The min name of the day of the week |
| `ddd` | Sun-Sat | The short name of the day of the week |
| `dddd` | Sunday-Saturday | The name of the day of the week |
| `z` | GMT, GMT+1 | The timezone with offset |
| `zz` | GMT, GMT+1 | The timezone with offset |
| `zzz` | GMT, GMT+1 | The timezone with offset |
| `zzzz` | GMT, GMT+01:00 | The long timezone with offset |

## Usage

### Basic

```vue
<script setup lang="ts">
import { useDateFormat, useNow } from '@vueuse/core'

const formatted = useDateFormat(useNow(), 'YYYY-MM-DD HH:mm:ss')
</script>

<template>
  <div>{{ formatted }}</div>
</template>
```

### Use with Locales

```vue
<script setup lang="ts">
import { useDateFormat, useNow } from '@vueuse/core'

const formatted = useDateFormat(useNow(), 'YYYY-MM-DD (ddd)', {
  locales: 'en-US'
})
</script>

<template>
  <div>{{ formatted }}</div>
</template>
```

### Use with Custom Meridiem

```vue
<script setup lang="ts">
import { useDateFormat } from '@vueuse/core'

function customMeridiem(
  hours: number,
  minutes: number,
  isLowercase?: boolean,
  hasPeriod?: boolean
) {
  const m = hours > 11 ? (isLowercase ? 'μμ' : 'ΜΜ') : (isLowercase ? 'πμ' : 'ΠΜ')
  return hasPeriod ? m.split('').reduce((acc, c) => acc += `${c}.`, '') : m
}

const am = useDateFormat('2022-01-01 05:05:05', 'hh:mm:ss A', {
  customMeridiem
})
// am.value = '05:05:05 ΠΜ'

const pm = useDateFormat('2022-01-01 17:05:05', 'hh:mm:ss AA', {
  customMeridiem
})
// pm.value = '05:05:05 Μ.Μ.'
</script>
```

## Type Declarations

```ts
export type DateLike = Date | number | string | undefined

export interface UseDateFormatOptions {
  /**
   * The locale(s) to used for dd/ddd/dddd/MMM/MMMM format
   *
   * [MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl#locales_argument).
   */
  locales?: MaybeRefOrGetter<Intl.LocalesArgument>

  /**
   * A custom function to re-modify the way to display meridiem
   */
  customMeridiem?: (
    hours: number,
    minutes: number,
    isLowercase?: boolean,
    hasPeriod?: boolean,
  ) => string
}

export declare function formatDate(
  date: Date,
  formatStr: string,
  options?: UseDateFormatOptions,
): string

export declare function normalizeDate(date: DateLike): Date

export type UseDateFormatReturn = ComputedRef<string>

/**
 * Get the formatted date according to the string of tokens passed in.
 *
 * @see https://vueuse.org/useDateFormat
 * @param date - The date to format, can either be a `Date` object, a timestamp, or a string
 * @param formatStr - The combination of tokens to format the date
 * @param options - UseDateFormatOptions
 */
export declare function useDateFormat(
  date: MaybeRefOrGetter<DateLike>,
  formatStr?: MaybeRefOrGetter<string>,
  options?: UseDateFormatOptions,
): UseDateFormatReturn
```

## Key Features

- **Flexible Date Input**: Accepts Date objects, timestamps, or date strings
- **Extensive Format Tokens**: Wide variety of format tokens including ordinals
- **Locale Support**: Use any Intl locale for month/day names
- **Custom Meridiem**: Define custom AM/PM formatting
- **Reactive**: Automatically updates when date or format changes
- **Timezone Support**: Format timezone information (z, zz, zzz, zzzz)

## Options

- `locales` - Intl locale(s) for dd/ddd/dddd/MMM/MMMM format (default: browser locale)
- `customMeridiem` - Custom function to format meridiem (AM/PM)

## Examples

### Common Date Formats

```ts
// ISO Date
useDateFormat(date, 'YYYY-MM-DD')
// => "2025-10-01"

// US Date
useDateFormat(date, 'MM/DD/YYYY')
// => "10/01/2025"

// Full Date with Time
useDateFormat(date, 'MMMM Do, YYYY [at] HH:mm:ss')
// => "October 1st, 2025 at 14:30:45"

// 12-hour Time
useDateFormat(date, 'h:mm A')
// => "2:30 PM"

// Full Weekday
useDateFormat(date, 'dddd, MMMM D, YYYY')
// => "Wednesday, October 1, 2025"
```

### With Reactive Date

```ts
import { useNow, useDateFormat } from '@vueuse/core'

const now = useNow()
const formatted = useDateFormat(now, 'YYYY-MM-DD HH:mm:ss')
// Automatically updates every frame
```

### With Different Locales

```ts
// French
const frDate = useDateFormat(date, 'dddd D MMMM YYYY', {
  locales: 'fr-FR'
})
// => "mercredi 1 octobre 2025"

// German
const deDate = useDateFormat(date, 'dddd, D. MMMM YYYY', {
  locales: 'de-DE'
})
// => "Mittwoch, 1. Oktober 2025"
```

### With Timezone

```ts
useDateFormat(date, 'YYYY-MM-DD HH:mm:ss zzzz')
// => "2025-10-01 14:30:45 GMT-04:00"
```

## Use Cases

- **Display Formatted Dates**: Show dates in any format
- **Localized Dates**: Display dates in user's language
- **Live Clocks**: Combine with useNow for live time displays
- **Timestamp Formatting**: Format Unix timestamps
- **Date/Time Pickers**: Display selected dates
- **Logging**: Format timestamps for logs

## Comparison with Alternatives

### vs dayjs
- **Lighter**: No external dependencies
- **Reactive**: Built for Vue's reactivity system
- **Simpler**: Focused on formatting only

### vs Intl.DateTimeFormat
- **More Flexible**: More format token options
- **Familiar Syntax**: dayjs-like format strings
- **Reactive**: Works seamlessly with Vue refs

## References

- [VueUse Documentation](https://vueuse.org/shared/useDateFormat/)
- [Source Code](https://github.com/vueuse/vueuse/blob/main/packages/shared/useDateFormat/index.ts)
- [dayjs](https://github.com/iamkun/dayjs)
- [Intl.DateTimeFormat](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl/DateTimeFormat)
