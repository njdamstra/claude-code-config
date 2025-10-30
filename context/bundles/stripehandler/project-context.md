# Project Context: Socialaize Stripe Integration

## Project Overview
Socialaize is a comprehensive social media management platform built with:
- **Frontend**: Astro 5.8 + Vue 3 + TypeScript + Tailwind CSS
- **Backend**: Appwrite (BaaS) with 25+ serverless functions
- **Deployment**: Cloudflare Pages with SSR via Workers
- **AI Services**: Python FastAPI backend for content generation

## Current Session Focus
Working on Stripe payment integration within the Appwrite serverless function architecture.

## Key Project Structure
```
/Users/natedamstra/socialaize/
├── src/                    # Frontend Astro/Vue application
├── functions/              # 25+ Appwrite serverless functions
│   ├── PostManager/       # Core post management logic
│   ├── WorkflowManager/   # Automation workflows
│   ├── SyncManager/       # Social platform syncing
│   └── [Platform]Api/     # Social media API integrations
├── api/                   # Python FastAPI AI services
├── appwrite.json          # Function configurations
└── package.json           # Frontend dependencies
```

## Database Architecture
- **Appwrite Database**: Primary data storage
- **TypeScript Schemas**: Full type safety across frontend/functions
- **Event-Driven**: Functions triggered by database events
- **Team-based**: Multi-user permission system

## Development Environment
- **Branch**: nate-stripe-2 (clean working directory)
- **Recent Commits**: Fixed update usage functionality
- **Build Commands**:
  - Frontend: `npm run dev`, `npm run build`
  - Functions: Individual `npm run build` in each function directory
  - Python API: `uv run dev`

## Appwrite Integration Patterns
- Functions use `node-appwrite` SDK
- Consistent error handling and logging
- JWT authentication via Appwrite
- OAuth for social platform connections