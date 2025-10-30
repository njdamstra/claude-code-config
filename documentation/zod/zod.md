# Zod

Zod is a TypeScript-first schema declaration and validation library. It's designed to be as developer-friendly as possible.

## Basic Usage

### Schemas

To use Zod, you first need to create a schema. A schema is a definition of a data structure. For example, to define a schema for a string, you can use `z.string()`.

```javascript
import { z } from 'zod';

const mySchema = z.string();
```

### Parsing

Once you have a schema, you can use it to parse data. The `parse` method will throw an error if the data is invalid.

```javascript
mySchema.parse("hello world"); // => "hello world"
mySchema.parse(12); // => throws ZodError
```

If you want to handle errors gracefully, you can use the `safeParse` method, which returns an object with a `success` property.

```javascript
mySchema.safeParse("hello world"); // => { success: true, data: "hello world" }
mySchema.safeParse(12); // => { success: false, error: ZodError }
```

### Type Inference

You can use `z.infer` to infer the TypeScript type of a schema.

```javascript
import { z } from 'zod';

const mySchema = z.string();

type MyType = z.infer<typeof mySchema>; // string
```

## Primitives

Zod provides a variety of primitive schemas:

*   `z.string()`: strings
*   `z.number()`: numbers
*   `z.bigint()`: bigints
*   `z.boolean()`: booleans
*   `z.date()`: dates
*   `z.symbol()`: symbols
*   `z.undefined()`: undefined
*   `z.null()`: null
*   `z.void()`: `void` (accepts `undefined`)
*   `z.any()`: any type
*   `z.unknown()`: any type, but requires validation before use
*   `z.never()`: never

## Object Schemas

To define an object schema, use `z.object()` and pass in an object with the desired properties.

```javascript
import { z } from 'zod';

const User = z.object({
  username: z.string(),
  age: z.number(),
});
```

### ` .shape`

You can access the schemas for the properties of an object schema using the `.shape` property.

```javascript
User.shape.username; // => z.string()
User.shape.age; // => z.number()
```

### ` .extend()`

You can extend an object schema with additional properties using the `.extend()` method.

```javascript
const UserWithPassword = User.extend({
  password: z.string(),
});
```

### ` .merge()`

You can merge two object schemas using the `.merge()` method.

```javascript
const UserWithAddress = User.merge(z.object({ address: z.string() }));
```

### ` .pick()` and ` .omit()`

You can pick or omit properties from an object schema using the `.pick()` and `.omit()` methods.

```javascript
const JustName = User.pick({ username: true });
const WithoutAge = User.omit({ age: true });
```

### ` .partial()` and ` .required()`

You can make all properties of an object schema optional using `.partial()`, or all properties required using `.required()`.

```javascript
const PartialUser = User.partial();
const RequiredUser = PartialUser.required();
```

### ` .strict()`

By default, Zod will strip out any unknown keys from an object. You can prevent this by using `.strict()`.

```javascript
const-strictUser = User.strict();
```

### ` .catchall()`

You can allow unknown keys by using `.catchall()`.

```javascript
const UserWithCatchall = User.catchall(z.any());
```

## Array Schemas

To define an array schema, use `z.array()` and pass in the schema for the elements of the array.

```javascript
import { z } from 'zod';

const stringArray = z.array(z.string());
```

You can also use the `.array()` method on any schema to create an array of that schema.

```javascript
const stringArray = z.string().array();
```

### Array-specific validations

Zod provides a number of array-specific validations:

*   `.min(number)`: must contain at least `number` items
*   `.max(number)`: must contain at most `number` items
*   `.length(number)`: must contain exactly `number` items
*   `.nonempty()`: must contain at least one item

## Modifiers

### `.optional()`

Marks a schema as optional, meaning the value can be `undefined`.

```javascript
const optionalString = z.string().optional();

optionalString.parse(undefined); // => undefined
```

### `.nullable()`

Marks a schema as nullable, meaning the value can be `null`.

```javascript
const nullableString = z.string().nullable();

nullableString.parse(null); // => null
```

### `.nullish()`

Marks a schema as nullish, meaning the value can be `null` or `undefined`.

```javascript
const nullishString = z.string().nullish();

nullishString.parse(null); // => null
nullishString.parse(undefined); // => undefined
```

### `.default()`

Provides a default value if the input is `undefined`.

```javascript
const stringWithDefault = z.string().default("hello");

stringWithDefault.parse(undefined); // => "hello"
```

## Custom Error Messages

You can provide custom error messages for your schemas.

### For specific validations

You can pass a custom error message as the second argument to most validation methods.

```javascript
import { z } from 'zod';

const name = z.string().min(5, { message: "Name must be at least 5 characters long" });
```

### For object properties

You can provide custom error messages for object properties.

```javascript
import { z } from 'zod';

const User = z.object({
  username: z.string({
    required_error: "Username is required",
    invalid_type_error: "Username must be a string",
  }),
});
```

### Using `refine`

For more complex validations, you can use the `.refine()` method to provide a custom validation function and error message.

```javascript
import { z } from 'zod';

const password = z.string().refine(val => val.length >= 8, {
  message: "Password must be at least 8 characters long",
});
```
