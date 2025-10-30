# useMediaControls

**Category**: Browser
**Export Size**: 2.4 kB
**Last Changed**: 2 weeks ago

Reactive media controls for both `<audio>` and `<video>` elements.

## Usage

`useMediaControls` provides a set of reactive properties and controls for managing HTML5 media elements.

```vue
<script setup lang="ts">
import { ref } from 'vue'
import { useMediaControls } from '@vueuse/core'

const video = ref<HTMLVideoElement>()
const {
  playing,
  currentTime,
  duration,
  volume,
  muted,
  ended,
} = useMediaControls(video, {
  src: 'https://vjs.zencdn.net/v/oceans.mp4'
})

function togglePlay() {
  playing.value = !playing.value
}
</script>

<template>
  <video ref="video" />
  <button @click="togglePlay">
    {{ playing ? 'Pause' : 'Play' }}
  </button>
  <span>{{ currentTime }} / {{ duration }}</span>
  <input type="range" v-model="volume" min="0" max="1" step="0.01" />
</template>
```

## Reactive State and Controls

The composable returns the following reactive properties:

- `playing`: `ref<boolean>` - `true` if the media is currently playing.
- `currentTime`: `ref<number>` - The current playback time in seconds.
- `duration`: `ref<number>` - The total duration of the media in seconds.
- `volume`: `ref<number>` - The volume of the media, from 0.0 to 1.0.
- `muted`: `ref<boolean>` - `true` if the media is muted.
- `ended`: `ref<boolean>` - `true` if the media has finished playing.
- `buffered`: `ref<TimeRange[]>` - The buffered time ranges.
- `seeking`: `ref<boolean>` - `true` if the media is currently seeking.
- `stalled`: `ref<boolean>` - `true` if the media is stalled.
- `waiting`: `ref<boolean>` - `true` if the media is waiting for data.

You can control the media by setting these refs.

## Text Tracks (Captions/Subtitles)

You can provide an array of tracks (captions, subtitles, etc.) via the `tracks` option.

```ts
const {
  tracks,
  selectedTrack,
  enableTrack,
  disableTrack,
} = useMediaControls(video, {
  src: 'your-video.mp4',
  tracks: [
    {
      default: true,
      kind: 'subtitles',
      label: 'English',
      src: 'subtitles/en.vtt',
      srcLang: 'en',
    },
  ],
})
```

- `tracks`: A reactive array of the available text tracks.
- `selectedTrack`: A `ref` to the currently selected track's index (-1 if none).
- `enableTrack(index)`: Enable a track by its index.
- `disableTrack()`: Disable the currently active track.

## Type Declarations

```ts
export declare function useMediaControls(
  target: MaybeRefOrGetter<HTMLMediaElement | null | undefined>,
  options?: UseMediaControlsOptions,
): UseMediaControlsReturn
```

## Source

- [Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useMediaControls/index.ts)
- [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useMediaControls/index.md)
