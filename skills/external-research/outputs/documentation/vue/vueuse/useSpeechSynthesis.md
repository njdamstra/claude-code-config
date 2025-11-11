# useSpeechSynthesis

**Category**: Sensors
**Export Size**: 1.2 kB
**Last Changed**: 7 months ago

Reactive [SpeechSynthesis](https://developer.mozilla.org/en-US/docs/Web/API/SpeechSynthesis).

## Demo

[source](https://github.com/vueuse/vueuse/blob/main/packages/core/useSpeechSynthesis/demo.vue) [playground (beta)](https://playground.vueuse.org/?vueuse=14.0.0-beta.1#eNqNVMtu2zAQ/ZUhF1pA0n2bFEXbBujQYcO2YBl0ZRMjWRIl+aAbhv/7KMlO0m5sFwsm+fgeyR55qHq79XgUjVLRFqZrhxad1yCYrFd55GweLXeST1oZBxdwS/yFl1xyh78LRwkB16gaaHBELLSbFVJgNMgwWAGzUCLqF6wmgeEVG82YYDrf0ymbsnJZKOkcoIDVP8jlz9fnzQ+BDUq3jkcoxuMbumSOEb6XWErf7NFsd+t4uyPMDRVKIW+k2FJ/thHnEkp1Ej7xGFZruIQrQJcrUNbuEDRIKh0z4TTtY19g1iEH19rbQ5ym6ZMx7JwGg/Gl51jAHa4TiP9MgLc6dxo+p2KBrsPamy+4dUzUuYDZtI1TQExuFJdO1ebF51IHMgrIVc8LaBuYDi7HGNChcAvQUkMpwY+jDgJTIKgGrAJ1JgTrlLbgDa9rNFzWQ+IKYqkD6ntHMaZ+Om8kVEzYvCH7mDMew1alDb1Ko8F7o5VF2+E7k2FsH6jyMnHcye6ENiSbjLSunptLzN7uQ6jExZVXzfUy64aWRpQPrp4XOhEsSn8Nw0ZijSKOoBDMWhpVA94hLUigBNVNJ19BJu9wSh6mU/0Oh/7bJMxTk9QRTSXUKTknJBUGfl8nNT1rMp9OszkY5WWJZfuXBGet7DEh36RF49XQi7QuqITFG5776KCgQzKb/5+U6nq4E9NMXKAlvJLwViojrc7rx27vnaNGPhYCF2/EPujoneolxLq8Dk7xZTbIXnT9C5NXV1k=)

## Usage

```ts
import { useSpeechSynthesis } from '@vueuse/core'

const {
  isSupported,
  isPlaying,
  status,
  voice,
  text,
  toggle,
  speak,
  stop,
} = useSpeechSynthesis('Hello, world!')
```

## Type Declarations

```ts
export interface UseSpeechSynthesisOptions extends ConfigurableWindow {
  /**
   * Language for SpeechSynthesis
   *
   * @default 'en-US'
   */
  lang?: MaybeRefOrGetter<string>
  /**
   * @see https://developer.mozilla.org/en-US/docs/Web/API/SpeechSynthesisUtterance/pitch
   * @default 1
   */
  pitch?: MaybeRefOrGetter<number>
  /**
   * @see https://developer.mozilla.org/en-US/docs/Web/API/SpeechSynthesisUtterance/rate
   * @default 1
   */
  rate?: MaybeRefOrGetter<number>
  /**
   * @see https://developer.mozilla.org/en-US/docs/Web/API/SpeechSynthesisUtterance/voice
   */
  voice?: MaybeRefOrGetter<SpeechSynthesisVoice>
  /**
   * @see https://developer.mozilla.org/en-US/docs/Web/API/SpeechSynthesisUtterance/volume
   * @default 1
   */
  volume?: MaybeRefOrGetter<number>
}

/**
 * Reactive SpeechSynthesis.
 *
 * @see https://vueuse.org/useSpeechSynthesis
 * @see https://developer.mozilla.org/en-US/docs/Web/API/SpeechSynthesis SpeechSynthesis
 * @param text
 * @param options
 */
export declare function useSpeechSynthesis(
  text: MaybeRefOrGetter<string>,
  options?: UseSpeechSynthesisOptions,
): {
  isSupported: ComputedRef<boolean>
  isPlaying: ShallowRef<boolean, boolean>
  status: ShallowRef<"init" | "play" | "pause" | "end", "init" | "play" | "pause" | "end">
  voice: WritableComputedRef<SpeechSynthesisVoice | undefined, SpeechSynthesisVoice | undefined>
  text: WritableComputedRef<string, string>
  utterance: ComputedRef<SpeechSynthesisUtterance | undefined>
  error: ShallowRef<any, any>
  toggle: (value?: boolean) => void
  speak: () => void
  stop: () => void
}

export type UseSpeechSynthesisReturn = ReturnType<
  typeof useSpeechSynthesis
>
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useSpeechSynthesis/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useSpeechSynthesis/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useSpeechSynthesis/index.md)
