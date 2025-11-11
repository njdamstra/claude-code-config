# useSpeechRecognition

**Category**: Sensors
**Export Size**: 714 B
**Last Changed**: 7 months ago

Reactive SpeechRecognition.

[Can I use?](https://caniuse.com/speech-recognition)

## Demo

[source](https://github.com/vueuse/vueuse/blob/main/packages/core/useSpeechRecognition/demo.vue) [playground (beta)](https://playground.vueuse.org/?vueuse=14.0.0-beta.1#eNqNVMtu2zAQ/ZUhF1pA0n2bFEXbBujQYcO2YBl0ZRMjWRIl+aAbhv/7KMlO0m5sFwsm+fgeyR55qHq79XgUjVLRFqZrhxad1yCYrFd55GweLXeST1oZBxdwS/yFl1xyh78LRwkB16gaaHBELLSbFVJgNMgwWAGzUCLqF6wmgeEVG82YYDrf0ymbsnJZKOkcoIDVP8jlz9fnzQ+BDUq3jkcoxuMbumSOEb6XWErf7NFsd+t4uyPMDRVKIW+k2FJ/thHnEkp1Ej7xGFZruIQrQJcrUNbuEDRIKh0z4TTtY19g1iEH19rbQ5ym6ZMx7JwGg/Gl51jAHa4TiP9MgLc6dxo+p2KBrsPamy+4dUzUuYDZtI1TQExuFJdO1ebF51IHMgrIVc8LaBuYDi7HGNChcAvQUkMpwY+jDgJTIKgGrAJ1JgTrlLbgDa9rNFzWQ+IKYqkD6ntHMaZ+Om8kVEzYvCH7mDMew1alDb1Ko8F7o5VF2+E7k2FsH6jyMnHcye6ENiSbjLSunptLzN7uQ6jExZVXzfUy64aWRpQPrp4XOhEsSn8Nw0ZijSKOoBDMWhpVA94hLUigBNVNJ19BJu9wSh6mU/0Oh/7bJMxTk9QRTSXUKTknJBUGfl8nNT1rMp9OszkY5WWJZfuXBGet7DEh36RF49XQi7QuqITFG5776KCgQzKb/5+U6nq4E9NMXKAlvJLwViojrc7rx27vnaNGPhYCF2/EPujoneolxLq8Dk7xZTbIXnT9C5NXV1k=)

## Usage

```ts
import { useSpeechRecognition } from '@vueuse/core'

const {
  isSupported,
  isListening,
  isFinal,
  result,
  start,
  stop,
} = useSpeechRecognition()
```

## Options

The following shows the default values of the options, they will be directly passed to SpeechRecognition API.

```ts
useSpeechRecognition({
  lang: 'en-US',
  interimResults: true,
  continuous: true,
})
```

## Type Declarations

```ts
export interface UseSpeechRecognitionOptions extends ConfigurableWindow {
  /**
   * Controls whether continuous results are returned for each recognition, or only a single result.
   *
   * @default true
   */
  continuous?: boolean
  /**
   * Controls whether interim results should be returned (true) or not (false.) Interim results are results that are not yet final
   *
   * @default true
   */
  interimResults?: boolean
  /**
   * Language for SpeechRecognition
   *
   * @default 'en-US'
   */
  lang?: MaybeRefOrGetter<string>
  /**
   * A number representing the maximum returned alternatives for each result.
   *
   * @see https://developer.mozilla.org/en-US/docs/Web/API/SpeechRecognition/maxAlternatives
   * @default 1
   */
  maxAlternatives?: number
}

/**
 * Reactive SpeechRecognition.
 *
 * @see https://vueuse.org/useSpeechRecognition
 * @see https://developer.mozilla.org/en-US/docs/Web/API/SpeechRecognition SpeechRecognition
 * @param options
 */
export declare function useSpeechRecognition(
  options?: UseSpeechRecognitionOptions,
): {
  isSupported: ComputedRef<boolean>
  isListening: ShallowRef<boolean, boolean>
  isFinal: ShallowRef<boolean, boolean>
  recognition: SpeechRecognition | undefined
  result: ShallowRef<string, string>
  error: ShallowRef<SpeechRecognitionErrorEvent | undefined, SpeechRecognitionErrorEvent | undefined>
  toggle: (value?: boolean) => void
  start: () => void
  stop: () => void
}

export type UseSpeechRecognitionReturn = ReturnType<typeof useSpeechRecognition>
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useSpeechRecognition/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useSpeechRecognition/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useSpeechRecognition/index.md)

## Contributors

* Anthony Fu
* IlyaL
* Jelf
* SerKo
* Byron
* 青椒肉丝
* Neil Richter
* Mark Noonan
* vaakian X
* wheat
* Joe Maylor
* Shinigami
* Alex Kozack
* EGGSY
* Antério Vieira

## Changelog

* **v12.8.0** on 3/5/2025: `7432f` - feat(types): deprecate MaybeRef and MaybeRefOrGetter in favor of Vue's native (#4636)
* **v12.6.0** on 2/14/2025: `4f104` - fix: improve start and stop method behavior (#4565)
* **v12.3.0** on 1/2/2025: `890ab` - fix: execute 'start' when not ended (#4119), `59f75` - feat(toValue): deprecate toValue from `@vueuse/shared` in favor of Vue's native
* **v12.0.0-beta.1** on 11/21/2024: `0a9ed` - feat!: drop Vue 2 support, optimize bundles and clean up (#4349)
* **v11.0.0-beta.2** on 7/17/2024: `9eda8` - feat: support maxAlternatives option (#4067)
* **v10.10.1** on 6/11/2024: `7c36f` - fix: send correct transcript result (#3891)
* **v10.8.0** on 2/20/2024: `a086e` - fix: stricter types
