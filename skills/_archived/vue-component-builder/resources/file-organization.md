# File Naming & Organization

### File Names
- **PascalCase** for component files: `UserProfile.vue`, `LoginForm.vue`
- **Descriptive names**: Component name should indicate purpose

### Directory Structure
```
src/components/vue/
├── ui/                  # Reusable UI primitives (buttons, inputs, cards)
│   ├── Button.vue
│   ├── Input.vue
│   ├── Card.vue
│   └── Modal.vue
├── forms/               # Form-specific components
│   ├── LoginForm.vue
│   ├── SignupForm.vue
│   └── FormInput.vue
├── layout/              # Layout components
│   ├── Header.vue
│   ├── Footer.vue
│   └── Sidebar.vue
└── [domain]/            # Domain-specific components
    ├── auth/            # Auth-related
    ├── profile/         # Profile-related
    └── messaging/       # Messaging-related
```
