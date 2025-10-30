[Skip to content](https://vueuse.org/core/usePermission/#VPContent)

On this page

# usePermission [​](https://vueuse.org/core/usePermission/\#usepermission)

Category

[Browser](https://vueuse.org/functions#category=Browser)

Export Size

941 B

Last Changed

2 months ago

Related

[`useUserMedia`](https://vueuse.org/core/useUserMedia/)

Reactive [Permissions API](https://developer.mozilla.org/en-US/docs/Web/API/Permissions_API). The Permissions API provides the tools to allow developers to implement a better user experience as far as permissions are concerned.

## Demo [​](https://vueuse.org/core/usePermission/\#demo)

[source](https://github.com/vueuse/vueuse/blob/main/packages/core/usePermission/demo.vue) [playground (beta)](https://playground.vueuse.org/?vueuse=14.0.0-beta.1#eNp9Vc2OmzAQfpVRLiFS2L1HyaqrqlUPW2nbHKpKuTgwECvGtmyTFYp49w52gk1De4L5fmwzP+a6eNX66dLiYrPY2sJw7cCiazUIJuvdYeHsYfFykLzRyji4gkFWOF51a2gtvqNpuLVcSeihMqqB5Sdai5jnQhlcJr5CNbp1WK5vK1xwtJAjKn+/fn+74R1rBBEHWShp6VjOcFnT1rAbT5EdJEDGJS29ASa7Fexe/BJPozqwa8jOa7h4/jqYAHgFmes0qgousNvtYFm1klZVcrm6a4B2cq2R0MoSKy6xDHgfHjfyMkT9+m6ytLHAH61yuAFnWlwHvBLq47MSAv0m76wsSbiBigkbJP2KHqv4xawoUCDlAh0a+upJxrPlhF6SL7pIceSCu+7LBaWz895RlKNXJUs0R07IG69Pbo/SqrndgyYXgyi3XhVXOLLiXBtFadt3snh0Rz63JIjGgjVo2KMh4IlOcH1UzJQ/kZUz8judU6uUM7Zfhjv8n+9jEERjjUqogg2Ve3QlZOLojLKF0jO7jFRUN6yW6P5V6pRNPLwwSp+UnNkiclEvFc0MD+ec6YkJHV2adQ0V+huTJXXbo+3G56cgSIxoLLeOuL1ThtUzp4yS3AZNYm/tacZBaNRYjew8d6gbEZVDfcRXNTsMnsurgRwMY6+ocjjy/ebKMn97xIvlfpFlfu4n0+jHeWYQA/4wXR6ejoyHQtOH17Tfp4hvZQ8lfRjie5/5KG2iAIw94sNJ/T0yLX2A/i5qQKkq/uWWd/8eU05hv1pRarfP4R9DfxQKHDZaMIcUAWy1wZfr8KOgrPf99nmIB0eiWvR/AEEFbmY=)

```
accelerometer: granted
accessibilityEvents: prompt
ambientLightSensor: prompt
backgroundSync: granted
camera: prompt
clipboardRead: prompt
clipboardWrite: granted
geolocation: prompt
gyroscope: granted
magnetometer: granted
microphone: prompt
notifications: prompt
paymentHandler: granted
persistentStorage: prompt
push: prompt
speaker: prompt
localFonts: prompt

```

## Usage [​](https://vueuse.org/core/usePermission/\#usage)

ts

```
import {
} from '@vueuse/core'

const
=
('microphone')
```

## Type Declarations [​](https://vueuse.org/core/usePermission/\#type-declarations)

Show Type Declarations

ts

```
type
=

  | "accelerometer"
  | "accessibility-events"
  | "ambient-light-sensor"
  | "background-sync"
  | "camera"
  | "clipboard-read"
  | "clipboard-write"
  | "gyroscope"
  | "magnetometer"
  | "microphone"
  | "notifications"
  | "payment-handler"
  | "persistent-storage"
  | "push"
  | "speaker"
  | "local-fonts"
export type
=

  | PermissionDescriptor
  | {

:


    }
export interface
<
extends boolean>
  extends ConfigurableNavigator {
  /**
   * Expose more controls
   *
   * @default false
   */

?:


}
export type
=

<

<
| undefined>
>
export interface UsePermissionReturnWithControls {

:


:
<boolean>

: () =>
<PermissionStatus | undefined>
}
/**
 * Reactive Permissions API.
 *
 * @see https://vueuse.org/usePermission
 *
 * @__NO_SIDE_EFFECTS__
 */
export declare function
(

:

    |

    |
["name"],

?:
<false>,
):


export declare function
(

:

    |

    |
["name"],

:
<true>,
): UsePermissionReturnWithControls
```

## Source [​](https://vueuse.org/core/usePermission/\#source)

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/usePermission/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/usePermission/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/usePermission/index.md)
