# Best Practices

### ✅ DO:

1. **Use Symbol-based InjectionKey:**
   ```typescript
   const MyKey = Symbol() as InjectionKey<MyContext>
   ```

2. **Validate required context:**
   ```typescript
   const ctx = inject(MyKey)
   if (!ctx) throw new Error('Must be used within Provider')
   ```

3. **Document context requirements:**
   ```vue
   <!-- @requires AccordionRoot -->
   <script setup lang="ts">
   ```

4. **Use readonly for unidirectional flow:**
   ```typescript
   provide('count', readonly(count))
   ```

5. **Split large contexts:**
   ```typescript
   provide('ui-state', uiState)
   provide('data-state', dataState)
   ```

6. **Colocate state close to usage:**
   ```vue
   <!-- State in feature wrapper, not App.vue -->
   ```

7. **Apply "200 Lines" rule for composables**

8. **Apply "3 Unrelated Components" rule for stores**

9. **Split when 2+ triggers present** (size, SRP, reusability)

10. **Create orchestrator when splitting**

### ❌ DON'T:

1. **Don't use string keys in reusable components** - Risk collisions
2. **Don't provide non-reactive primitives** - Won't update
3. **Don't over-nest provide/inject** - 2-3 levels max
4. **Don't mix props and inject for same data** - Choose one
5. **Don't forget cleanup** - Unregister items on unmount
6. **Don't over-split** - Only split when 2+ triggers present
7. **Don't lift state prematurely** - Start local, lift when needed
8. **Don't create stores for 1-2 components** - Use local/composable
9. **Don't split without orchestrator** - Coordinate split units
10. **Don't ignore size thresholds** - 500+ lines must split
