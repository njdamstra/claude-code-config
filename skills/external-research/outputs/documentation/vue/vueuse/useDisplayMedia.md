# useDisplayMedia

Category: [Sensors](https://vueuse.org/functions#category=Sensors)

Export Size: 926 B

Last Changed: 7 months ago

Related: [`useUserMedia`](https://vueuse.org/core/useUserMedia/)

Reactive [`mediaDevices.getDisplayMedia`](https://developer.mozilla.org/en-US/docs/Web/API/MediaDevices/getDisplayMedia) streaming.

## Demo

Start sharing my screen

## Usage

```vue
<script setup lang="ts">
import { useDisplayMedia } from '@vueuse/core'
import { watchEffect, ref } from 'vue'

const { stream, start } = useDisplayMedia()

// start streaming
start()

const video = ref('video')

watchEffect(() => {
  // preview on a video element
  video.value.srcObject = stream.value
})
</script>

<template>
  <video ref="video" />
</template>
```

## Type Declarations

```ts
export interface UseDisplayMediaOptions extends ConfigurableNavigator {
  /**
   * If the stream is enabled
   * @default false
   */
  enabled?: MaybeRef<boolean>
  /**
   * If the stream video media constraints
   */
  video?: boolean | MediaTrackConstraints | undefined
  /**
   * If the stream audio media constraints
   */
  audio?: boolean | MediaTrackConstraints | undefined
}

/**
 * Reactive `mediaDevices.getDisplayMedia` streaming
 *
 * @see https://vueuse.org/useDisplayMedia
 * @param options
 */
export declare function useDisplayMedia(
  options?: UseDisplayMediaOptions
): {
  isSupported: Ref<boolean>
  stream: Ref<MediaStream | undefined, MediaStream | undefined>
  start: () => Promise<MediaStream | undefined>
  stop: () => void
  enabled:
    | WritableComputedRef<boolean, boolean>
    | WritableComputedRef<boolean, boolean>
    | WritableComputedRef<boolean, boolean>
    | Ref<true, true>
    | Ref<false, false>
}

export type UseDisplayMediaReturn = ReturnType<typeof useDisplayMedia>
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useDisplayMedia/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useDisplayMedia/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useDisplayMedia/index.md)

## Contributors

- Anthony Fu
- IlyaL
- SerKo
- Fernando Fernández
- Robert Rosman
- Jelf
- wheat
- Abderrahim SOUBAI-ELIDRISI

## Changelog

### v12.8.0 on 3/5/2025

`7432f` - feat(types): deprecate `MaybeRef` and `MaybeRefOrGetter` in favor of Vue's native (#4636)

### v12.5.0 on 1/22/2025

`c6c6e` - feat: use `useEventListener` where it was not being used (#4479)

### v12.0.0-beta.1 on 11/21/2024

`0a9ed` - feat!: drop Vue 2 support, optimize bundles and clean up (#4349)

### v10.10.0 on 5/27/2024

`a3c6f` - fix: stop stream when screen is not shared anymore (#3976)
