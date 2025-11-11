# useGeolocation

**Category:** Sensors
**Export Size:** 553 B
**Last Changed:** 8 months ago

Reactive [Geolocation API](https://developer.mozilla.org/en-US/docs/Web/API/Geolocation_API). It allows the user to provide their location to web applications if they so desire. For privacy reasons, the user is asked for permission to report location information.

## Demo

```json
{
  "coords": {
    "accuracy": 0,
    "latitude": null,
    "longitude": null,
    "altitude": null,
    "altitudeAccuracy": null,
    "heading": null,
    "speed": null
  },
  "locatedAt": null,
  "error": null
}
```

Pause watch / Start watch

## Usage

```ts
import { useGeolocation } from '@vueuse/core'

const { coords, locatedAt, error, resume, pause } = useGeolocation()
```

| State | Type | Description |
| --- | --- | --- |
| coords | [`Coordinates`](https://developer.mozilla.org/en-US/docs/Web/API/Coordinates) | information about the position retrieved like the latitude and longitude |
| locatedAt | `Date` | The time of the last geolocation call |
| error | `string` | An error message in case geolocation API fails. |
| resume | `function` | Control function to resume updating geolocation |
| pause | `function` | Control function to pause updating geolocation |

## Config

[`useGeolocation`](https://vueuse.org/core/useGeolocation/) function takes [PositionOptions](https://developer.mozilla.org/en-US/docs/Web/API/PositionOptions) object as an optional parameter.

## Component Usage

> This function also provides a renderless component version via the `@vueuse/components` package. [Learn more about the usage](https://vueuse.org/guide/components).

```vue
<template>
  <UseGeolocation v-slot="{ coords: { latitude, longitude } }">
    Latitude: {{ latitude }}
    Longitude: {{ longitude }}
  </UseGeolocation>
</template>
```

## Type Declarations

```ts
export interface UseGeolocationOptions
  extends Partial<PositionOptions>,
    ConfigurableNavigator {
  immediate?: boolean
}

/**
 * Reactive Geolocation API.
 *
 * @see https://vueuse.org/useGeolocation
 * @param options
 */
export declare function useGeolocation(
  options?: UseGeolocationOptions
): {
  isSupported: Ref<boolean>
  coords: Ref<
    {
      readonly accuracy: number
      readonly latitude: number | null
      readonly longitude: number | null
      readonly altitude: number | null
      readonly altitudeAccuracy: number
      readonly heading: number
      readonly speed: number | null
    },
    | Omit<GeolocationCoordinates, "toJSON">
    | {
        readonly accuracy: number
        readonly latitude: number | null
        readonly longitude: number | null
        readonly altitude: number | null
        readonly altitudeAccuracy: number
        readonly heading: number
        readonly speed: number | null
      }
  >
  locatedAt: Ref<number | null, number | null>
  error: Ref<
    GeolocationPositionError | null,
    GeolocationPositionError | null
  >
  resume: () => void
  pause: () => void
}

export type UseGeolocationReturn = ReturnType<typeof useGeolocation>
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useGeolocation/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useGeolocation/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useGeolocation/index.md)
