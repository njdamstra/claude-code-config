# Nanostores Core Concepts

This document explains the core concepts of Nanostores: `atom` and `map`.

## atom

An atom is a store that holds a single value. It can be a string, number, boolean, array, or object.

### Usage

```javascript
import { atom } from 'nanostores';

export const isAuthenticated = atom(false);
```

### Updating the store

To update the store, you can use the `set` method:

```javascript
isAuthenticated.set(true);
```

### Subscribing to changes

You can subscribe to changes in the store using the `subscribe` method:

```javascript
const unsubscribe = isAuthenticated.subscribe(value => {
  console.log('isAuthenticated changed to', value);
});
```

## map

A map is a store that holds an object. It's useful for storing related data in a single store.

### Usage

```javascript
import { map } from 'nanostores';

export const user = map({
  name: 'John Doe',
  email: 'john.doe@example.com',
});
```

### Updating the store

To update the store, you can use the `setKey` method:

```javascript
user.setKey('name', 'Jane Doe');
```

### Subscribing to changes

You can subscribe to changes in the store using the `subscribe` method:

```javascript
const unsubscribe = user.subscribe(value => {
  console.log('user changed to', value);
});
```
