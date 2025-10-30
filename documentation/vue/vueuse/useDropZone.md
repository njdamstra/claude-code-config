[Skip to content](https://vueuse.org/core/useDropZone/#VPContent)

On this page

# useDropZone [​](https://vueuse.org/core/useDropZone/\#usedropzone)

Category

[Elements](https://vueuse.org/functions#category=Elements)

Export Size

1.13 kB

Last Changed

6 months ago

Create a zone where files can be dropped.

WARNING

Due to Safari browser limitations, file type validation is only possible during the drop event, not during drag events. As a result, the `isOverDropZone` value will always be `true` during drag operations in Safari, regardless of file type.

## Demo [​](https://vueuse.org/core/useDropZone/\#demo)

[source](https://github.com/vueuse/vueuse/blob/main/packages/core/useDropZone/demo.vue) [playground (beta)](https://playground.vueuse.org/?vueuse=14.0.0-beta.1#eNrtVW1v2jAQ/isnvgASIQxN+4AC2qbuTWo3aeunET6YxEm9OnYUO7SUsd++s5NAEtJ20jStkyYh8J3vufO9Pex6r9J0vMlpb9bzVJCxVIOiOk+BExHP/Z5Wfm/hC5akMtOwg1zRs0ymX6WgsIcokwn0XyIe9W4gM9qv2aorwrm8+UyjkcFd0iTlRFOUD1BEIsIXgRRKQ8Q4VWdEE5jXwN4OBEnoDJTOmIhHoNgdSiJP1jQbgd6mtTtOlL6QIYsYDSsb2C9Xi8FyNazisITE9O0fD+aLKBeBZlKAFKZqA5vgDEzo5Qq+I4TzIex8AcfcxxvCc4qPWq6MnkVQwEq7LkurGSekCADzBQxKWyizMfqxOY4qfZGX1ZvjQV9kaPXmeNA3c7X3dVVptx9i3vjjC/w08v9gav5YEZqNebQS95g/2XIU0xeW+2P2YN5aDO/95cX5G04TKvRi0K+Z9pvTWy3hLzhp2xtPla8dMPVpQ7PaTltvlTyovWBUTvED8FkpH5rd6bP9oBH6CbGBl1hgHIxl8WI3FXF/VQWd1UcI6+oLzy34CtkJBV2mjxKAF7INBNgPhQwWcXoL5ssJJIeYpM7UUprpT8PwxolwEuHKIbmWkFF0xzb0YIvW6cJGt/NVENhW5hkEMklzjauPg45IUzK4w9SU56b2dSXcBIszFmKsHwjiypm23lOZHSXAh0QIqPXB79Wvu9Msc0mYcK6c6WSS3lZ5rWMnzsjWeT6ZuM8m8C1XmkVbJ8BZwQwY1lFVQqKdF5DJXIQ0rAetPbbMKpJCO2vJQ0jW08Y1wDsqaEY4VA1vgF1En7hrOWiNWPPSey0lp0ScMYX938LMkgDWo4nye+A243RG7qjmTUbSh6rU6N3Bz8aJZIZ+LAONgGEJb4f4cyRvfNHsmm7NS80lisc5LBqGnVpzElwb0bQqITgvKXFenIS0o/nRMttudyQ32O+LCTyx/WLZrrI1hHe/rdnKo60hwfttz5ECITnQYgWqM2MnuKMbLc2J3LklbWb5x1bFEtzfWZQGYz+ZbWn+wf9fmd9Ymbp0PFcnz639gfb2PwHekMtB)

Drop files from your computer on to drop zones

General DropZone

isOverDropZone: false

Image DropZone

isOverDropZone: false

## Usage [​](https://vueuse.org/core/useDropZone/\#usage)

vue

```
<script setup lang="ts">
import {
} from '@vueuse/core'
import {
} from 'vue'

const
=
<HTMLDivElement>()

function
(
: File[] | null) {
  // called when files are dropped on zone
}

const {
} =
(
, {

,
  // specify the types of data to be received.

: ['image/jpeg'],
  // control multi-file drop

: true,
  // whether to prevent default behavior for unhandled events

: false,
})
</script>

<template>
  <

="
">
    Drop files here
  </
>
</template>
```

## Type Declarations [​](https://vueuse.org/core/useDropZone/\#type-declarations)

Show Type Declarations

ts

```
export interface UseDropZoneReturn {

:
<File[] | null>

:
<boolean>
}
export interface UseDropZoneOptions {
  /**
   * Allowed data types, if not set, all data types are allowed.
   * Also can be a function to check the data types.
   */

?:
    |
<readonly string[]>
    | ((
: readonly string[]) => boolean)

?: (
: File[] | null,
: DragEvent) => void

?: (
: File[] | null,
: DragEvent) => void

?: (
: File[] | null,
: DragEvent) => void

?: (
: File[] | null,
: DragEvent) => void
  /**
   * Allow multiple files to be dropped. Defaults to true.
   */

?: boolean
  /**
   * Prevent default behavior for unhandled events. Defaults to false.
   */

?: boolean
}
export declare function
(

:
<HTMLElement | Document | null | undefined>,

?: UseDropZoneOptions | UseDropZoneOptions["onDrop"],
): UseDropZoneReturn
```

## Source [​](https://vueuse.org/core/useDropZone/\#source)

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useDropZone/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useDropZone/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useDropZone/index.md)
