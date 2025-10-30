# Common Search Patterns

## By Technology

### Vue Composables
```bash
# Find all composables
grep -r "export.*use[A-Z]" src/composables/

# Specific functionality
grep -r "useState\|useEffect\|useRef" src/  # React-style hooks
grep -r "computed\|ref\|reactive" src/      # Vue composition
```

### TypeScript Interfaces/Types
```bash
# Find type definitions
grep -r "export type" src/
grep -r "export interface" src/
grep -r "type.*=" src/
```

### Zod Schemas
```bash
# Find all schemas
grep -r "z.object\|z.array\|z.string" src/schemas/
grep -r "Schema.*=.*z\." src/

# Find schema by model
grep -r "UserSchema\|PostSchema" src/
```

### Appwrite Patterns
```bash
# Database operations
grep -r "databases.createDocument" src/
grep -r "databases.listDocuments" src/
grep -r "databases.getDocument" src/
grep -r "databases.updateDocument" src/

# Auth operations
grep -r "account.get\|account.create" src/
grep -r "createEmailSession\|createOAuth2Session" src/

# Storage operations
grep -r "storage.createFile\|storage.getFile" src/
```

## By Pattern

### State Management
```bash
# Nanostores
grep -r "atom\|map\|computed" src/stores/
grep -r "extends BaseStore" src/stores/

# Store usage in components
grep -r "useStore\|import.*from.*stores" src/
```

### Form Handling
```bash
# Form components
find src/components -name "*Form*.vue"
find src/components -name "*Input*.vue"

# Validation
grep -r "validate\|validation" src/
grep -r "errors.*=.*ref" src/components/
```

### Dark Mode
```bash
# Find dark mode usage
grep -r "dark:" src/ | grep -v node_modules
grep -r "dark:bg-\|dark:text-" src/

# Theme management
grep -r "theme\|darkMode" src/stores/
grep -r "useColorMode\|useDark" src/
```

### SSR Safety
```bash
# Find SSR-safe patterns
grep -r "useMounted\|onMounted" src/
grep -r "import.*from.*@vueuse/core" src/

# Find potential SSR issues
grep -r "localStorage\|sessionStorage" src/
grep -r "window\.\|document\." src/
```

## By Feature Domain

### Authentication
```bash
grep -r "auth\|login\|logout\|session" src/stores/
grep -r "protected\|requireAuth" src/
find src/components -name "*Auth*.vue" -o -name "*Login*.vue"
```

### User Management
```bash
grep -r "user\|profile\|account" src/stores/
find src/components -name "*User*.vue" -o -name "*Profile*.vue"
grep -r "UserSchema\|ProfileSchema" src/schemas/
```

### Notifications/Toasts
```bash
find src/components -name "*Toast*.vue" -o -name "*Notification*.vue"
grep -r "notify\|toast\|alert" src/stores/
grep -r "Teleport" src/components/  # Often used for toasts
```

### Modals/Dialogs
```bash
find src/components -name "*Modal*.vue" -o -name "*Dialog*.vue"
grep -r "Teleport\|portal" src/components/
grep -r "onClickOutside" src/  # Common modal pattern
```

## Advanced Patterns

### Find Usage of Specific Pattern
```bash
# Find all usages of a composable
grep -r "useFormValidation" src/

# Find all usages of a component
grep -r "FormInput" src/

# Find all usages of a store
grep -r "\$user\|userStore" src/
```

### Find Similar Implementations
```bash
# Find all API calls
grep -r "fetch\|axios" src/

# Find all error handling patterns
grep -r "try.*catch" src/
grep -r "\.catch\|catch(" src/

# Find all loading states
grep -r "isLoading\|loading.*ref\|loading.*=" src/
```

### Cross-Reference Patterns
```bash
# Find components using specific composables
grep -l "useFormValidation" src/components/**/*.vue

# Find stores used by components
grep -l "useStore\|import.*stores" src/components/**/*.vue

# Find schemas used by stores
grep -l "Schema" src/stores/*.ts
```
