# useKeyModifier

**Category:** Sensors
**Export Size:** 728 B
**Last Changed:** 2 months ago

Reactive [Modifier State](https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent/getModifierState). Tracks state of any of the [supported modifiers](https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent/getModifierState#browser_compatibility) - see Browser Compatibility notes.

[Learn useKeyModifier with this FREE video lesson from Vue School!](https://vueschool.io/lessons/alt-drag-to-clone-tasks?friend=vueuse)

## Demo

capsLock, numLock, scrollLock, shift, control, alt

## Usage

```ts
import { useKeyModifier } from '@vueuse/core'

const capsLock = useKeyModifier('CapsLock')

console.log(capsLock.value)
```

## Events

You can customize which events will prompt the state to update. By default, these are `mouseup`, `mousedown`, `keyup`, `keydown`. To customize these events:

```ts
import { useKeyModifier } from '@vueuse/core'

const capsLock = useKeyModifier('CapsLock', {
  events: ['mouseup', 'mousedown']
})

console.log(capsLock) // null

// Caps Lock turned on with key press
console.log(capsLock) // null

// Mouse button clicked
console.log(capsLock) // true
```

## Initial State

By default, the returned ref will be `Ref<null>` until the first event is received. You can explicitly pass the initial state to it via:

```ts
const capsLock = useKeyModifier('CapsLock') // Ref<boolean | null>
const capsLockDefault = useKeyModifier('CapsLock', {
  initial: false
}) // Ref<boolean>
```

## Type Declarations

```ts
export type KeyModifier =
  | "Alt"
  | "AltGraph"
  | "CapsLock"
  | "Control"
  | "Fn"
  | "FnLock"
  | "Meta"
  | "NumLock"
  | "ScrollLock"
  | "Shift"
  | "Symbol"
  | "SymbolLock"

export interface UseKeyModifierOptions<Initial> extends ConfigurableDocument {
  /**
   * Event names that will prompt update to modifier states
   *
   * @default ['mousedown', 'mouseup', 'keydown', 'keyup']
   */
  events?: WindowEventName[]

  /**
   * Initial value of the returned ref
   *
   * @default null
   */
  initial?: Initial
}

export type UseKeyModifierReturn<Initial> = Ref<
  Initial extends boolean ? boolean : boolean | null
>

export declare function useKeyModifier<Initial extends boolean | null>(
  modifier: KeyModifier,
  options?: UseKeyModifierOptions<Initial>,
): UseKeyModifierReturn<Initial>
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useKeyModifier/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useKeyModifier/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useKeyModifier/index.md)
