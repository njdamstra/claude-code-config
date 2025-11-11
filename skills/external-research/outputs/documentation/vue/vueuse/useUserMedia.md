# useUserMedia

**Category**: Sensors
**Export Size**: 633 B
**Last Changed**: last week
**Related**: [useDevicesList](useDevicesList.md), [useDisplayMedia](useDisplayMedia.md), [usePermission](usePermission.md)

Reactive `mediaDevices.getUserMedia` streaming.

## Demo

[source](https://github.com/vueuse/vueuse/blob/main/packages/core/useUserMedia/demo.vue) [playground (beta)](https://playground.vueuse.org/?vueuse=14.0.0-beta.1#eNqNVMtu2zAQ/ZUhF1pA0n2bFEXbBujQYcO2YBl0ZRMjWRIl+aAbhv/7KMlO0m5sFwsm+fgeyR55qHq79XgUjVLRFqZrhxad1yCYrFd55GweLXeST1oZBxdwS/yFl1xyh78LRwkB16gaaHBELLSbFVJgNMgwWAGzUCLqF6wmgeEVG82YYDrf0ymbsnJZKOkcoIDVP8jlz9fnzQ+BDUq3jkcoxuMbumSOEb6XWErf7NFsd+t4uyPMDRVKIW+k2FJ/thHnEkp1Ej7xGFZruIQrQJcrUNbuEDRIKh0z4TTtY19g1iEH19rbQ5ym6ZMx7JwGg/Gl51jAHa4TiP9MgLc6dxo+p2KBrsPamy+4dUzUuYDZtI1TQExuFJdO1ebF51IHMgrIVc8LaBuYDi7HGNChcAvQUkMpwY+jDgJTIKgGrAJ1JgTrlLbgDa9rNFzWQ+IKYqkD6ntHMaZ+Om8kVEzYvCH7mDMew1alDb1Ko8F7o5VF2+E7k2FsH6jyMnHcye6ENiSbjLSunptLzN7uQ6jExZVXzfUy64aWRpQPrp4XOhEsSn8Nw0ZijSKOoBDMWhpVA94hLUigBNVNJ19BJu9wSh6mU/0Oh/7bJMxTk9QRTSXUKTknJBUGfl8nNT1rMp9OszkY5WWJZfuXBGet7DEh36RF49XQi7QuqITFG5776KCgQzKb/5+U6nq4E9NMXKAlvJLwViojrc7rx27vnaNGPhYCF2/EPujoneolxLq8Dk7xZTbIXnT9C5NXV1k=)

## Usage

### Vue

```vue
<script setup lang="ts">
import { useUserMedia } from '@vueuse/core'
import { useTemplateRef, watchEffect } from 'vue'

const { stream, start } = useUserMedia()
start()

const videoRef = useTemplateRef('video')

watchEffect(() => {
  // preview on a video element
  videoRef.value.srcObject = stream.value
})
</script>

<template>
  <video ref="video" />
</template>
```

### Devices

```ts
import { useDevicesList, useUserMedia } from '@vueuse/core'
import { computed, reactive } from 'vue'

const {
  videoInputs: cameras,
  audioInputs: microphones,
} = useDevicesList({
  requestPermissions: true,
})

const currentCamera = computed(() => cameras.value?.deviceId)
const currentMicrophone = computed(() => microphones.value?.deviceId)

const { stream } = useUserMedia({
  constraints: reactive({
    video: { deviceId: currentCamera },
    audio: { deviceId: currentMicrophone, }
  })
})
```

## Type Declarations

```ts
export interface UseUserMediaOptions extends ConfigurableNavigator {
  /**
   * If the stream is enabled
   * @default false
   */
  enabled?: MaybeRef<boolean>
  /**
   * Recreate stream when deviceIds or constraints changed
   *
   * @default true
   */
  autoSwitch?: MaybeRef<boolean>
  /**
   * MediaStreamConstraints to be applied to the requested MediaStream
   * If provided, the constraints will override videoDeviceId and audioDeviceId
   *
   * @default {}
   */
  constraints?: MaybeRef<MediaStreamConstraints>
}

/**
 * Reactive `mediaDevices.getUserMedia` streaming
 *
 * @see https://vueuse.org/useUserMedia
 * @param options
 */
export declare function useUserMedia(options?: UseUserMediaOptions): {
  isSupported: ComputedRef<boolean>
  stream: Ref<MediaStream | undefined, MediaStream | undefined>
  start: () => Promise<MediaStream | undefined>
  stop: () => void
  restart: () => Promise<MediaStream | undefined>
  constraints: Ref<
    | MediaStreamConstraints
    | {
        audio?:
          | boolean
          | {
              advanced?:
                | {
                    aspectRatio?:
                      | number
                      | {
                          exact?: number | undefined
                          ideal?: number | undefined
                          max?: number | undefined
                          min?: number | undefined
                        }
                      | undefined
                    autoGainControl?:
                      | boolean
                      | { exact?: boolean | undefined; ideal?: boolean | undefined }
                      | undefined
                    backgroundBlur?:
                      | boolean
                      | { exact?: boolean | undefined; ideal?: boolean | undefined }
                      | undefined
                    channelCount?:
                      | number
                      | {
                          exact?: number | undefined
                          ideal?: number | undefined
                          max?: number | undefined
                          min?: number | undefined
                        }
                      | undefined
                    deviceId?:
                      | string
                      | string[]
                      | {
                          exact?: string | string[] | undefined
                          ideal?: string | string[] | undefined
                        }
                      | undefined
                    displaySurface?:
                      | string
                      | string[]
                      | {
                          exact?: string | string[] | undefined
                          ideal?: string | string[] | undefined
                        }
                      | undefined
                    echoCancellation?:
                      | boolean
                      | { exact?: boolean | undefined; ideal?: boolean | undefined }
                      | undefined
                    facingMode?:
                      | string
                      | string[]
                      | {
                          exact?: string | string[] | undefined
                          ideal?: string | string[] | undefined
                        }
                      | undefined
                    frameRate?:
                      | number
                      | {
                          exact?: number | undefined
                          ideal?: number | undefined
                          max?: number | undefined
                          min?: number | undefined
                        }
                      | undefined
                    groupId?:
                      | string
                      | string[]
                      | {
                          exact?: string | string[] | undefined
                          ideal?: string | string[] | undefined
                        }
                      | undefined
                    height?:
                      | number
                      | {
                          exact?: number | undefined
                          ideal?: number | undefined
                          max?: number | undefined
                          min?: number | undefined
                        }
                      | undefined
                    noiseSuppression?:
                      | boolean
                      | { exact?: boolean | undefined; ideal?: boolean | undefined }
                      | undefined
                    sampleRate?:
                      | number
                      | {
                          exact?: number | undefined
                          ideal?: number | undefined
                          max?: number | undefined
                          min?: number | undefined
                        }
                      | undefined
                    sampleSize?:
                      | number
                      | {
                          exact?: number | undefined
                          ideal?: number | undefined
                          max?: number | undefined
                          min?: number | undefined
                        }
                      | undefined
                    width?:
                      | number
                      | {
                          exact?: number | undefined
                          ideal?: number | undefined
                          max?: number | undefined
                          min?: number | undefined
                        }
                      | undefined
                  }[]
                | undefined
              aspectRatio?:
                | number
                | {
                    exact?: number | undefined
                    ideal?: number | undefined
                    max?: number | undefined
                    min?: number | undefined
                  }
                | undefined
              autoGainControl?:
                | boolean
                | { exact?: boolean | undefined; ideal?: boolean | undefined }
                | undefined
              backgroundBlur?:
                | boolean
                | { exact?: boolean | undefined; ideal?: boolean | undefined }
                | undefined
              channelCount?:
                | number
                | {
                    exact?: number | undefined
                    ideal?: number | undefined
                    max?: number | undefined
                    min?: number | undefined
                  }
                | undefined
              deviceId?:
                | string
                | string[]
                | {
                    exact?: string | string[] | undefined
                    ideal?: string | string[] | undefined
                  }
                | undefined
              displaySurface?:
                | string
                | string[]
                | {
                    exact?: string | string[] | undefined
                    ideal?: string | string[] | undefined
                  }
                | undefined
              echoCancellation?:
                | boolean
                | { exact?: boolean | undefined; ideal?: boolean | undefined }
                | undefined
              facingMode?:
                | string
                | string[]
                | {
                    exact?: string | string[] | undefined
                    ideal?: string | string[] | undefined
                  }
                | undefined
              frameRate?:
                | number
                | {
                    exact?: number | undefined
                    ideal?: number | undefined
                    max?: number | undefined
                    min?: number | undefined
                  }
                | undefined
              groupId?:
                | string
                | string[]
                | {
                    exact?: string | string[] | undefined
                    ideal?: string | string[] | undefined
                  }
                | undefined
              height?:
                | number
                | {
                    exact?: number | undefined
                    ideal?: number | undefined
                    max?: number | undefined
                    min?: number | undefined
                  }
                | undefined
              noiseSuppression?:
                | boolean
                | { exact?: boolean | undefined; ideal?: boolean | undefined }
                | undefined
              sampleRate?:
                | number
                | {
                    exact?: number | undefined
                    ideal?: number | undefined
                    max?: number | undefined
                    min?: number | undefined
                  }
                | undefined
              sampleSize?:
                | number
                | {
                    exact?: number | undefined
                    ideal?: number | undefined
                    max?: number | undefined
                    min?: number | undefined
                  }
                | undefined
              width?:
                | number
                | {
                    exact?: number | undefined
                    ideal?: number | undefined
                    max?: number | undefined
                    min?: number | undefined
                  }
                | undefined
            }
          | undefined
        peerIdentity?: string | undefined
        preferCurrentTab?: boolean | undefined
        video?:
          | boolean
          | {
              advanced?:
                | {
                    aspectRatio?:
                      | number
                      | {
                          exact?: number | undefined
                          ideal?: number | undefined
                          max?: number | undefined
                          min?: number | undefined
                        }
                      | undefined
                    autoGainControl?:
                      | boolean
                      | { exact?: boolean | undefined; ideal?: boolean | undefined }
                      | undefined
                    backgroundBlur?:
                      | boolean
                      | { exact?: boolean | undefined; ideal?: boolean | undefined }
                      | undefined
                    channelCount?:
                      | number
                      | {
                          exact?: number | undefined
                          ideal?: number | undefined
                          max?: number | undefined
                          min?: number | undefined
                        }
                      | undefined
                    deviceId?:
                      | string
                      | string[]
                      | {
                          exact?: string | string[] | undefined
                          ideal?: string | string[] | undefined
                        }
                      | undefined
                    displaySurface?:
                      | string
                      | string[]
                      | {
                          exact?: string | string[] | undefined
                          ideal?: string | string[] | undefined
                        }
                      | undefined
                    echoCancellation?:
                      | boolean
                      | { exact?: boolean | undefined; ideal?: boolean | undefined }
                      | undefined
                    facingMode?:
                      | string
                      | string[]
                      | {
                          exact?: string | string[] | undefined
                          ideal?: string | string[] | undefined
                        }
                      | undefined
                    frameRate?:
                      | number
                      | {
                          exact?: number | undefined
                          ideal?: number | undefined
                          max?: number | undefined
                          min?: number | undefined
                        }
                      | undefined
                    groupId?:
                      | string
                      | string[]
                      | {
                          exact?: string | string[] | undefined
                          ideal?: string | string[] | undefined
                        }
                      | undefined
                    height?:
                      | number
                      | {
                          exact?: number | undefined
                          ideal?: number | undefined
                          max?: number | undefined
                          min?: number | undefined
                        }
                      | undefined
                    noiseSuppression?:
                      | boolean
                      | { exact?: boolean | undefined; ideal?: boolean | undefined }
                      | undefined
                    sampleRate?:
                      | number
                      | {
                          exact?: number | undefined
                          ideal?: number | undefined
                          max?: number | undefined
                          min?: number | undefined
                        }
                      | undefined
                    sampleSize?:
                      | number
                      | {
                          exact?: number | undefined
                          ideal?: number | undefined
                          max?: number | undefined
                          min?: number | undefined
                        }
                      | undefined
                    width?:
                      | number
                      | {
                          exact?: number | undefined
                          ideal?: number | undefined
                          max?: number | undefined
                          min?: number | undefined
                        }
                      | undefined
                  }[]
                | undefined
              aspectRatio?:
                | number
                | {
                    exact?: number | undefined
                    ideal?: number | undefined
                    max?: number | undefined
                    min?: number | undefined
                  }
                | undefined
              autoGainControl?:
                | boolean
                | { exact?: boolean | undefined; ideal?: boolean | undefined }
                | undefined
              backgroundBlur?:
                | boolean
                | { exact?: boolean | undefined; ideal?: boolean | undefined }
                | undefined
              channelCount?:
                | number
                | {
                    exact?: number | undefined
                    ideal?: number | undefined
                    max?: number | undefined
                    min?: number | undefined
                  }
                | undefined
              deviceId?:
                | string
                | string[]
                | {
                    exact?: string | string[] | undefined
                    ideal?: string | string[] | undefined
                  }
                | undefined
              displaySurface?:
                | string
                | string[]
                | {
                    exact?: string | string[] | undefined
                    ideal?: string | string[] | undefined
                  }
                | undefined
              echoCancellation?:
                | boolean
                | { exact?: boolean | undefined; ideal?: boolean | undefined }
                | undefined
              facingMode?:
                | string
                | string[]
                | {
                    exact?: string | string[] | undefined
                    ideal?: string | string[] | undefined
                  }
                | undefined
              frameRate?:
                | number
                | {
                    exact?: number | undefined
                    ideal?: number | undefined
                    max?: number | undefined
                    min?: number | undefined
                  }
                | undefined
              groupId?:
                | string
                | string[]
                | {
                    exact?: string | string[] | undefined
                    ideal?: string | string[] | undefined
                  }
                | undefined
              height?:
                | number
                | {
                    exact?: number | undefined
                    ideal?: number | undefined
                    max?: number | undefined
                    min?: number | undefined
                  }
                | undefined
              noiseSuppression?:
                | boolean
                | { exact?: boolean | undefined; ideal?: boolean | undefined }
                | undefined
              sampleRate?:
                | number
                | {
                    exact?: number | undefined
                    ideal?: number | undefined
                    max?: number | undefined
                    min?: number | undefined
                  }
                | undefined
              sampleSize?:
                | number
                | {
                    exact?: number | undefined
                    ideal?: number | undefined
                    max?: number | undefined
                    min?: number | undefined
                  }
                | undefined
              width?:
                | number
                | {
                    exact?: number | undefined
                    ideal?: number | undefined
                    max?: number | undefined
                    min?: number | undefined
                  }
                | undefined
            }
          | undefined
      }
    >
  enabled: Ref<boolean, boolean> | ShallowRef<boolean, boolean> | WritableComputedRef<boolean, boolean> | ShallowRef<true, true> | ShallowRef<false, false>
  autoSwitch: Ref<boolean, boolean> | ShallowRef<boolean, boolean> | WritableComputedRef<boolean, boolean> | ShallowRef<true, true> | ShallowRef<false, false>
}

export type UseUserMediaReturn = ReturnType<typeof useUserMedia>
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useUserMedia/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useUserMedia/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useUserMedia/index.md)

## Contributors

* Anthony Fu
* IlyaL
* bab
* SerKo
* OrbisK
* Waleed Khaled
* Martin
* Jelf
* wheat
* Shinigami
* Alex Kozack

## Changelog

* **v14.0.0-beta.1** on 9/19/2025
  * `4b3e9` - fix: add deep watch to constraints (#5046)
* **v12.8.0** on 3/5/2025
  * `7432f` - feat(types): deprecate MaybeRef and MaybeRefOrGetter in favor of Vue's native (#4636)
* **v12.3.0** on 1/2/2025
  * `59f75` - feat(toValue): deprecate toValue from @vueuse/shared in favor of Vue's native
* **v12.0.0-beta.1** on 11/21/2024
  * `0a9ed` - feat!: drop Vue 2 support, optimize bundles and clean up (#4349)
* **v10.8.0** on 2/20/2024
  * `6d44d` - fix: stop stream on scope dispose (#3757)
