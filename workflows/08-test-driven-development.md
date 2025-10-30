---
name: Test-Driven Component Development
type: testing
status: production-ready
updated: 2025-10-16
---

# Workflow: Test-Driven Component Development

**Goal**: Create a new, fully tested Vue component using test-driven development (TDD)

**Duration**: 1-2 hours
**Complexity**: Medium
**Benefits**: Higher code quality, better design, fewer bugs, better documentation

---

## Steps

### 1. Scout for Reusable Code
Invoke `code-reuser-scout`

**Agent**: `code-reuser-scout` checks for existing components

**Find:**
- Does component already exist?
- Similar components that could be extended?
- Base components to compose from?

**Action:**
- If exact match found: Use as-is
- If near match: Extend with new props/slots
- If base exists: Compose from base
- If nothing: Safe to create new

### 2. Write Failing Tests
Use `vue-testing-specialist`

**Agent**: `vue-testing-specialist` creates test file with failing tests

**What to test:**
- Primary functionality
- Props and emits
- Slots and fallback content
- Edge cases
- Error states
- User interactions

**Test Template:**
```typescript
import { describe, it, expect } from 'vitest';
import { mount } from '@vue/test-utils';
import MyComponent from './MyComponent.vue';

describe('MyComponent', () => {
  it('renders with default props', () => {
    const wrapper = mount(MyComponent);
    expect(wrapper.exists()).toBe(true);
  });

  it('accepts and displays title prop', () => {
    const wrapper = mount(MyComponent, {
      props: { title: 'Test Title' },
    });
    expect(wrapper.find('h2').text()).toBe('Test Title');
  });

  it('emits select event when item clicked', async () => {
    const wrapper = mount(MyComponent, {
      props: { items: [{ id: 1, name: 'Item 1' }] },
    });
    await wrapper.find('li').trigger('click');
    expect(wrapper.emitted('select')).toBeTruthy();
  });

  it('uses slot when provided', () => {
    const wrapper = mount(MyComponent, {
      slots: { default: 'Custom content' },
    });
    expect(wrapper.text()).toContain('Custom content');
  });

  it('handles disabled state', () => {
    const wrapper = mount(MyComponent, {
      props: { disabled: true },
    });
    expect(wrapper.find('button').attributes('disabled')).toBeDefined();
  });
});
```

**Run tests** (they should all fail):
```bash
npm run test
# ✗ MyComponent.test.ts - 5 failed
```

### 3. Implement Component
Use `vue-architect`

**Agent**: `vue-architect` creates minimal component to pass tests

**Implement just enough to make tests pass:**
```vue
<script setup lang="ts">
import type { Item } from '@/types';

interface Props {
  title?: string;
  items?: Item[];
  disabled?: boolean;
}

withDefaults(defineProps<Props>(), {
  title: 'Default Title',
  items: () => [],
  disabled: false,
});

const emit = defineEmits<{
  (e: 'select', item: Item): void;
}>();

function handleSelect(item: Item) {
  if (!disabled) {
    emit('select', item);
  }
}
</script>

<template>
  <div class="component">
    <h2 v-if="title">{{ title }}</h2>
    <ul v-if="items.length">
      <li
        v-for="item in items"
        :key="item.id"
        @click="handleSelect(item)"
      >
        <slot name="item" :item="item">
          {{ item.name }}
        </slot>
      </li>
    </ul>
    <slot />
    <button :disabled="disabled">Action</button>
  </div>
</template>
```

**Run tests again:**
```bash
npm run test
# ✓ MyComponent.test.ts - 5 passed
```

### 4. Run Tests
Use `vue-testing-specialist`

**Agent**: `vue-testing-specialist` verifies all tests pass

**Command:**
```bash
npm run test
# ✓ MyComponent.test.ts - 5 passed
# Coverage: 95% statements
```

### 5. Refactor & Add More Tests
Iterate on the implementation:

**Add integration tests:**
```typescript
it('works with parent store', () => {
  const wrapper = mount(MyComponent, {
    props: { items: storeItems },
    global: {
      stubs: { ParentComponent: true },
    },
  });
  // Test store integration
});

it('handles async data loading', async () => {
  const wrapper = mount(MyComponent, {
    props: { loading: true },
  });
  expect(wrapper.find('[data-testid="loader"]').exists()).toBe(true);

  await wrapper.setProps({ loading: false });
  expect(wrapper.find('[data-testid="loader"]').exists()).toBe(false);
});
```

**Run full test suite:**
```bash
npm run test:coverage
# ✓ 12 tests passed
# Coverage: 98% statements
```

### 6. Type Validation
Use `typescript-validator`

**Agent**: `typescript-validator` ensures type safety

**Run type check:**
```bash
npm run typecheck
# ✓ No type errors
```

**Verify:**
- Props properly typed
- Emits properly typed
- No `any` types
- Return types correct

---

## Agent Orchestration

```
code-reuser-scout (check for existing) →
vue-testing-specialist (write failing tests) →
vue-architect (implement component) →
vue-testing-specialist (verify tests pass) →
typescript-validator (ensure type safety)
```

---

## Example: User Card Component with TDD

### Test File First (02-test.ts)
```typescript
import { describe, it, expect } from 'vitest';
import { mount } from '@vue/test-utils';
import UserCard from './UserCard.vue';
import type { User } from '@/types';

describe('UserCard', () => {
  const mockUser: User = {
    id: '1',
    name: 'John Doe',
    email: 'john@example.com',
    avatar: 'https://example.com/avatar.jpg',
  };

  it('renders user card with data', () => {
    const wrapper = mount(UserCard, {
      props: { user: mockUser },
    });
    expect(wrapper.text()).toContain('John Doe');
    expect(wrapper.text()).toContain('john@example.com');
  });

  it('emits click event when card clicked', async () => {
    const wrapper = mount(UserCard, {
      props: { user: mockUser },
    });
    await wrapper.find('[data-testid="card"]').trigger('click');
    expect(wrapper.emitted('click')).toBeTruthy();
  });

  it('shows role badge when provided', () => {
    const wrapper = mount(UserCard, {
      props: { user: mockUser, role: 'admin' },
    });
    expect(wrapper.find('[data-testid="role-badge"]').text()).toBe('admin');
  });

  it('displays loading state', () => {
    const wrapper = mount(UserCard, {
      props: { user: mockUser, loading: true },
    });
    expect(wrapper.find('[data-testid="loader"]').exists()).toBe(true);
  });

  it('uses default avatar if not provided', () => {
    const userNoAvatar = { ...mockUser, avatar: undefined };
    const wrapper = mount(UserCard, {
      props: { user: userNoAvatar },
    });
    expect(wrapper.find('[data-testid="default-avatar"]').exists()).toBe(true);
  });
});
```

### Component Implementation (UserCard.vue)
```vue
<script setup lang="ts">
import { computed } from 'vue';
import { Icon } from '@iconify/vue';
import type { User } from '@/types';

interface Props {
  user: User;
  role?: string;
  loading?: boolean;
}

const props = defineProps<Props>();

const emit = defineEmits<{
  (e: 'click'): void;
}>();

const initials = computed(() => {
  const names = props.user.name.split(' ');
  return names.map(n => n[0]).join('').toUpperCase();
});

const avatarSrc = computed(() =>
  props.user.avatar || `https://avatar.placeholder.com/${props.user.id}`
);
</script>

<template>
  <div
    data-testid="card"
    class="p-4 bg-white dark:bg-gray-800 rounded-lg shadow cursor-pointer hover:shadow-lg transition"
    @click="emit('click')"
  >
    <div v-if="loading" data-testid="loader" class="animate-pulse">
      <div class="h-8 w-8 bg-gray-300 rounded-full mb-2" />
      <div class="h-4 bg-gray-300 rounded mb-2" />
    </div>

    <div v-else class="flex items-center gap-4">
      <!-- Avatar -->
      <img
        v-if="user.avatar"
        :src="avatarSrc"
        :alt="user.name"
        class="h-12 w-12 rounded-full object-cover"
      />
      <div
        v-else
        data-testid="default-avatar"
        class="h-12 w-12 rounded-full bg-gray-300 dark:bg-gray-600 flex items-center justify-center text-sm font-bold"
      >
        {{ initials }}
      </div>

      <!-- Info -->
      <div class="flex-1">
        <div class="flex items-center gap-2">
          <h3 class="font-semibold">{{ user.name }}</h3>
          <span
            v-if="role"
            data-testid="role-badge"
            class="px-2 py-1 text-xs bg-blue-100 dark:bg-blue-900 text-blue-800 dark:text-blue-200 rounded"
          >
            {{ role }}
          </span>
        </div>
        <p class="text-sm text-gray-600 dark:text-gray-400">{{ user.email }}</p>
      </div>
    </div>
  </div>
</template>

<style scoped>
/* Styles */
</style>
```

---

## TDD Cycle

```
1. Write Failing Test ──→ Test fails ✗
        ↓
2. Write Implementation ──→ Test passes ✓
        ↓
3. Refactor Code ──→ Tests still pass ✓
        ↓
4. Add More Tests ──→ Repeat
```

---

## Testing Best Practices

### ✅ Good Tests
```typescript
// Specific, focused
it('emits select event with correct item', async () => {
  const wrapper = mount(MyComponent, {
    props: { items: [{ id: 1, name: 'Item' }] },
  });
  await wrapper.find('li').trigger('click');
  expect(wrapper.emitted('select')[0]).toEqual([{ id: 1, name: 'Item' }]);
});
```

### ❌ Bad Tests
```typescript
// Vague, tests implementation details
it('works', () => {
  const wrapper = mount(MyComponent);
  expect(wrapper.vm.internalState).toBe(true);
});
```

---

## Coverage Goals

| Metric | Target |
|--------|--------|
| Statements | 90%+ |
| Branches | 85%+ |
| Functions | 90%+ |
| Lines | 90%+ |

---

## Related Workflows

- [Create Feature Page](./01-create-feature-page.md)
- [Debug Existing Feature](./07-debug-existing-feature.md)
- [Enhance Existing Feature](./06-enhance-existing-feature.md)

---

**Time Estimate**: 1-2 hours | **Complexity**: Medium | **Status**: ✅ Production Ready
