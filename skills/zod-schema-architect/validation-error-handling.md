# Validation Error Handling

Complete guide to handling Zod validation errors.

## Error Handling Patterns

### 1. Try-Catch
**See SKILL.md Section 4 Pattern 1** for exception-based handling.

### 2. SafeParse
**See SKILL.md Section 4 Pattern 2** for no-exception handling.

### 3. API Routes
**See SKILL.md Section 4 Pattern 3** for API error responses.

### 4. User-Friendly Messages
**See SKILL.md Section 4 Pattern 4** for custom error messages.

## Best Practices

✅ Always handle `ZodError` specifically
✅ Return structured error objects
✅ Include field paths in errors
✅ Use custom messages for user-facing validation

❌ Don't expose internal error details to users
❌ Don't ignore validation errors

## Error Response Format

```typescript
{
  success: false,
  errors: [
    { field: 'email', message: 'Invalid email' },
    { field: 'age', message: 'Must be 18+' }
  ]
}
```
