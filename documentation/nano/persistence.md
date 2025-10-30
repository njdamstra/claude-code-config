# Nanostores Persistence

This document explains how to persist Nanostores state to `localStorage` or `sessionStorage`.

## persistentAtom

`persistentAtom` is used to store a single value in `localStorage` or `sessionStorage`.

### Usage

```javascript
import { persistentAtom } from '@nanostores/persistent';

export const counter = persistentAtom('counter', 0);
```

By default, `persistentAtom` uses `localStorage`. You can specify `sessionStorage` by passing it as the third argument:

```javascript
import { persistentAtom } from '@nanostores/persistent';

export const counter = persistentAtom('counter', 0, {
  storage: sessionStorage,
});
```

### Encoding and Decoding

You can also provide `encode` and `decode` functions to serialize and deserialize the value:

```javascript
import { persistentAtom } from '@nanostores/persistent';

export const user = persistentAtom('user', null, {
  encode: JSON.stringify,
  decode: JSON.parse,
});
```

## persistentMap

`persistentMap` is used to store an object in `localStorage` or `sessionStorage`. Each key-value pair is stored in a separate `localStorage` key.

### Usage

```javascript
import { persistentMap } from '@nanostores/persistent';

export const settings = persistentMap('settings:', {
  theme: 'light',
  notifications: true,
});
```

This will store the settings in `localStorage` with the keys `settings:theme` and `settings:notifications`.
