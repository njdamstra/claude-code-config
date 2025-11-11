# useNetwork

**Category:** Sensors
**Export Size:** 964 B
**Last Changed:** 2 months ago

Reactive [Network status](https://developer.mozilla.org/en-US/docs/Web/API/Network_Information_API). The Network Information API provides information about the system's connection in terms of general connection type (e.g., 'wifi', 'cellular', etc.). This can be used to select high definition content or low definition content based on the user's connection. The entire API consists of the addition of the NetworkInformation interface and a single property to the Navigator interface: Navigator.connection.

## Demo

```
isSupported: true
isOnline: true
saveData: false
onlineAt: 1759355276301
downlink: 10
effectiveType: 4g
rtt: 0
```

## Usage

```ts
import { useNetwork } from '@vueuse/core'

const { isOnline, offlineAt, downlink, downlinkMax, effectiveType, saveData, type } = useNetwork()

console.log(isOnline.value)
```

To use as an object, wrap it with `reactive()`

```ts
import { reactive } from 'vue'

const network = reactive(useNetwork())

console.log(network.isOnline)
```

## Component Usage

> This function also provides a renderless component version via the `@vueuse/components` package. [Learn more about the usage](https://vueuse.org/guide/components).

```vue
<template>
  <UseNetwork v-slot="{ isOnline, type }">
    Is Online: {{ isOnline }}
    Type: {{ type }}
  </UseNetwork>
</template>
```

## Type Declarations

```ts
export type NetworkType =
  | "bluetooth"
  | "cellular"
  | "ethernet"
  | "none"
  | "wifi"
  | "wimax"
  | "other"
  | "unknown"

export type NetworkEffectiveType = "slow-2g" | "2g" | "3g" | "4g" | undefined

export interface NetworkState {
  isSupported: Ref<boolean>
  /**
   * If the user is currently connected.
   */
  isOnline: Ref<Ref<boolean>>
  /**
   * The time since the user was last connected.
   */
  offlineAt: Ref<Ref<number | undefined>>
  /**
   * At this time, if the user is offline and reconnects
   */
  onlineAt: Ref<Ref<number | undefined>>
  /**
   * The download speed in Mbps.
   */
  downlink: Ref<Ref<number | undefined>>
  /**
   * The max reachable download speed in Mbps.
   */
  downlinkMax: Ref<Ref<number | undefined>>
  /**
   * The detected effective speed type.
   */
  effectiveType: Ref<Ref<NetworkEffectiveType | undefined>>
  /**
   * The estimated effective round-trip time of the current connection.
   */
  rtt: Ref<Ref<number | undefined>>
  /**
   * If the user activated data saver mode.
   */
  saveData: Ref<Ref<boolean | undefined>>
  /**
   * The detected connection/network type.
   */
  type: Ref<Ref<NetworkType>>
}

/**
 * Reactive Network status.
 *
 * @see https://vueuse.org/useNetwork
 * @param options
 *
 * @__NO_SIDE_EFFECTS__
 */
export declare function useNetwork(
  options?: ConfigurableWindow,
): Readonly<NetworkState>

export type UseNetworkReturn = ReturnType<typeof useNetwork>
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useNetwork/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useNetwork/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useNetwork/index.md)
