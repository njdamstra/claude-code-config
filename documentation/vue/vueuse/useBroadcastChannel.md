# useBroadcastChannel

Category: Browser

Export Size: 917 B

Reactive [BroadcastChannel API](https://developer.mozilla.org/en-US/docs/Web/API/BroadcastChannel).

Closes a broadcast channel automatically when component unmounted.

## Usage

The BroadcastChannel interface represents a named channel that any browsing context of a given origin can subscribe to. It allows communication between different documents (in different windows, tabs, frames, or iframes) of the same origin.

Messages are broadcasted via a message event fired at all BroadcastChannel objects listening to the channel.

```ts
import { useBroadcastChannel } from '@vueuse/core'
import { ref } from 'vue'

const { isSupported, channel, data, post, close, error, isClosed } = useBroadcastChannel({
  name: 'vueuse-demo-channel'
})

const message = ref('')

message.value = 'Hello, VueUse World!'

// Post the message to the broadcast channel:
post(message.value)

// Option to close the channel if you wish:
close()
```

## Type Declarations

```ts
export interface UseBroadcastChannelOptions extends ConfigurableWindow {
  /**
   * The name of the channel.
   */
  name: string
}

/**
 * Reactive BroadcastChannel
 *
 * @see https://vueuse.org/useBroadcastChannel
 * @see https://developer.mozilla.org/en-US/docs/Web/API/BroadcastChannel
 * @param options
 */
export declare function useBroadcastChannel<D, P>(
  options: UseBroadcastChannelOptions,
): UseBroadcastChannelReturn<D, P>

export interface UseBroadcastChannelReturn<D, P> {
  isSupported: Ref<boolean>
  channel: Ref<BroadcastChannel | undefined>
  data: Ref<D>
  post: (data: P) => void
  close: () => void
  error: Ref<Event | null>
  isClosed: Ref<boolean>
}
```
