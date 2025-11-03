[Skip to content](https://vueuse.org/core/usewebsocket/#VPContent)

Return to top

# useWebSocket [​](https://vueuse.org/core/usewebsocket/\#usewebsocket)

Category

[Network](https://vueuse.org/functions#category=Network)

Export Size

1.58 kB

Last Changed

3 months ago

Reactive [WebSocket](https://developer.mozilla.org/en-US/docs/Web/API/WebSocket/WebSocket) client.

## Usage [​](https://vueuse.org/core/usewebsocket/\#usage)

ts

```
import {
} from '@vueuse/core'

const {
,
,
,
,
} =
('ws://websocketurl')
```

See the [Type Declarations](https://vueuse.org/core/usewebsocket/#type-declarations) for more options.

### immediate [​](https://vueuse.org/core/usewebsocket/\#immediate)

Enable by default.

Establish the connection immediately when the composable is called.

### autoConnect [​](https://vueuse.org/core/usewebsocket/\#autoconnect)

Enable by default.

If url is provided as a ref, when the url changes, it will automatically reconnect to the new url.

### autoClose [​](https://vueuse.org/core/usewebsocket/\#autoclose)

Enable by default.

This will call `close()` automatically when the `beforeunload` event is triggered or the associated effect scope is stopped.

### autoReconnect [​](https://vueuse.org/core/usewebsocket/\#autoreconnect)

Reconnect on errors automatically (disabled by default).

ts

```
const {
,
,
} =
('ws://websocketurl', {

: true,
})
```

Or with more controls over its behavior:

ts

```
const {
,
,
} =
('ws://websocketurl', {

: {

: 3,

: 1000,

() {

('Failed to connect WebSocket after 3 retries')
    },
  },
})
```

Explicitly calling `close()` won't trigger the auto reconnection.

### heartbeat [​](https://vueuse.org/core/usewebsocket/\#heartbeat)

It's common practice to send a small message (heartbeat) for every given time passed to keep the connection active. In this function we provide a convenient helper to do it:

ts

```
const {
,
,
} =
('ws://websocketurl', {

: true,
})
```

Or with more controls:

ts

```
const {
,
,
} =
('ws://websocketurl', {

: {

: 'ping',

: 1000,

: 1000,
  },
})
```

### Sub-protocols [​](https://vueuse.org/core/usewebsocket/\#sub-protocols)

List of one or more subprotocols to use, in this case soap and wamp.

ts

```
const {
,
,
,
,
} =
('ws://websocketurl', {

: ['soap'], // ['soap', 'wamp']
})
```

## Type Declarations [​](https://vueuse.org/core/usewebsocket/\#type-declarations)

Show Type Declarations

ts

```
export type
= "OPEN" | "CONNECTING" | "CLOSED"
export type
= string | ArrayBuffer | Blob
export interface UseWebSocketOptions {

?: (
: WebSocket) => void

?: (
: WebSocket,
: CloseEvent) => void

?: (
: WebSocket,
: Event) => void

?: (
: WebSocket,
:
) => void
  /**
   * Send heartbeat for every x milliseconds passed
   *
   * @default false
   */

?:
    | boolean
    | {
        /**
         * Message for the heartbeat
         *
         * @default 'ping'
         */

?:
<
>
        /**
         * Response message for the heartbeat, if undefined the message will be used
         */

?:
<
>
        /**
         * Interval, in milliseconds
         *
         * @default 1000
         */

?: number
        /**
         * Heartbeat response timeout, in milliseconds
         *
         * @default 1000
         */

?: number
      }
  /**
   * Enabled auto reconnect
   *
   * @default false
   */

?:
    | boolean
    | {
        /**
         * Maximum retry times.
         *
         * Or you can pass a predicate function (which returns true if you want to retry).
         *
         * @default -1
         */

?: number | ((
: number) => boolean)
        /**
         * Delay for reconnect, in milliseconds
         *
         * @default 1000
         */

?: number
        /**
         * On maximum retry times reached.
         */

?:


      }
  /**
   * Immediately open the connection when calling this composable
   *
   * @default true
   */

?: boolean
  /**
   * Automatically connect to the websocket when URL changes
   *
   * @default true
   */

?: boolean
  /**
   * Automatically close a connection
   *
   * @default true
   */

?: boolean
  /**
   * List of one or more sub-protocol strings
   *
   * @default []
   */

?: string[]
}
export interface
<
> {
  /**
   * Reference to the latest data received via the websocket,
   * can be watched to respond to incoming messages
   */

:
<
| null>
  /**
   * The current websocket status, can be only one of:
   * 'OPEN', 'CONNECTING', 'CLOSED'
   */

:
<
>
  /**
   * Closes the websocket connection gracefully.
   */

: WebSocket["close"]
  /**
   * Reopen the websocket connection.
   * If there the current one is active, will close it before opening a new one.
   */

:


  /**
   * Sends data through the websocket connection.
   *
   * @param data
   * @param useBuffer when the socket is not yet open, store the data into the buffer and sent them one connected. Default to true.
   */

: (
: string | ArrayBuffer | Blob,
?: boolean) => boolean
  /**
   * Reference to the WebSocket instance.
   */

:
<WebSocket | undefined>
}
/**
 * Reactive WebSocket client.
 *
 * @see https://vueuse.org/useWebSocket
 * @param url
 */
export declare function
<
= any>(

:
<string | URL | undefined>,

?: UseWebSocketOptions,
):
<
>
```

## Source [​](https://vueuse.org/core/usewebsocket/\#source)

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useWebSocket/index.ts) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useWebSocket/index.md)
