[Skip to content](https://vueuse.org/core/useStyleTag/#VPContent)

On this page

# useStyleTag [​](https://vueuse.org/core/useStyleTag/\#usestyletag)

Category

[Browser](https://vueuse.org/functions#category=Browser)

Export Size

513 B

Last Changed

5 months ago

Inject reactive `style` element in head.

## Demo [​](https://vueuse.org/core/useStyleTag/\#demo)

[source](https://github.com/vueuse/vueuse/blob/main/packages/core/useStyleTag/demo.vue) [playground (beta)](https://playground.vueuse.org/?vueuse=14.0.0-beta.1#eNptUk1P4zAQ/Suz2QOsRJsVgktwKxBwQOJWuOWAaw/FwrEte9JSVfnvTGoSysfJM/abN2/eeFdchTBdt1hUhUgqmkCQkNoAVrrVrC4o1cW8dqYJPhLsoE24oK3FB7mCDp6jb+Dokuv5vlQ+4lHtaqe8SwSqTeSb68UCZvBUu6nGxjPDUqrXVfSt0xX8lfpMneL5/wvoBgThG8mI8hvUmtULbdFav9mDn6YUTXP877PfDow+AZXSCVgvOWxdPk265xM1C54dDnA8KmQWUebxeVhOCJtgJSFnAEKb9T4AuNWGgAuqnDLuQ+x60niNlh1jAXUBtA3Y28fvnEW/SZydcqisTH28mTy31vJFmXuUQxOxbIm8g0qbJJcWNYOHCRh+qaxRr3zXz7bfTS+kf840ufoL09DSR94pMsch9Z/fuLNzI/tjTn/ws+SRnH1Nva+TfoljpQjzu5sKhGJz5rt+Q9B1gn8Kp6IMn6is4RA5Lu07frBKlAdbKrp33/nxvQ==)

Edit CSS: .demo { background: #ad4c2e50; }
.demo textarea { background: lightyellow; }

Load  Unload

ID: `vueuse_styletag_1`

Loaded: `true`

## Usage [​](https://vueuse.org/core/useStyleTag/\#usage)

### Basic usage [​](https://vueuse.org/core/useStyleTag/\#basic-usage)

Provide a CSS string, then [`useStyleTag`](https://vueuse.org/core/useStyleTag/) will automatically generate an id and inject it in `<head>`.

ts

```
import {
} from '@vueuse/core'

const {


,


,


,


,


,
} =
('.foo { margin-top: 32px; }')

// Later you can modify styles

.
= '.foo { margin-top: 64px; }'
```

This code will be injected to `<head>`:

html

```
<style id="vueuse_styletag_1">
  .foo {
    margin-top: 64px;
  }
</style>
```

### Custom ID [​](https://vueuse.org/core/useStyleTag/\#custom-id)

If you need to define your own id, you can pass `id` as first argument.

ts

```

('.foo { margin-top: 32px; }', {
: 'custom-id' })
```

html

```
<!-- injected to <head> -->
<style id="custom-id">
  .foo {
    margin-top: 32px;
  }
</style>
```

### Media query [​](https://vueuse.org/core/useStyleTag/\#media-query)

You can pass media attributes as last argument within object.

ts

```

('.foo { margin-top: 32px; }', {
: 'print' })
```

html

```
<!-- injected to <head> -->
<style id="vueuse_styletag_1" media="print">
  .foo {
    margin-top: 32px;
  }
</style>
```

## Type Declarations [​](https://vueuse.org/core/useStyleTag/\#type-declarations)

ts

```
export interface UseStyleTagOptions extends ConfigurableDocument {
  /**
   * Media query for styles to apply
   */

?: string
  /**
   * Load the style immediately
   *
   * @default true
   */

?: boolean
  /**
   * Manual controls the timing of loading and unloading
   *
   * @default false
   */

?: boolean
  /**
   * DOM id of the style tag
   *
   * @default auto-incremented
   */

?: string
  /**
   * Nonce value for CSP (Content Security Policy)
   *
   * @default undefined
   */

?: string
}
export interface UseStyleTagReturn {

: string

:
<string>

: () => void

: () => void

:
<
<boolean>>
}
/**
 * Inject <style> element in head.
 *
 * Overload: Omitted id
 *
 * @see https://vueuse.org/useStyleTag
 * @param css
 * @param options
 */
export declare function
(

:
<string>,

?: UseStyleTagOptions,
): UseStyleTagReturn
```

## Source [​](https://vueuse.org/core/useStyleTag/\#source)

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useStyleTag/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useStyleTag/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useStyleTag/index.md)
