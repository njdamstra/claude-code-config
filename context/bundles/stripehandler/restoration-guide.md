# Restoration Guide: Stripe Integration Context

## Quick Context Summary
This bundle captures the **starting point** for Stripe payment integration in the Socialaize social media management platform. No implementation work has begun yet.

## Restoration Confidence: 95%
This bundle represents a clean starting state with full project context established.

## Current State Analysis
- **Working Directory**: `/Users/natedamstra/socialaize`
- **Git Branch**: `nate-stripe-2`
- **Git Status**: Clean (no uncommitted changes)
- **Last Commit**: `72974910 fixed update usage`

## Project Architecture Refresher
- **Frontend**: Astro 5.8 + Vue 3 + TypeScript + Tailwind
- **Backend**: Appwrite with 25+ serverless functions
- **Runtime**: Node.js 21 for functions, Python FastAPI for AI
- **Deployment**: Cloudflare Pages with SSR

## Immediate Next Steps Upon Restoration

### 1. Research Phase (30 minutes)
```bash
# Investigate existing payment/billing structure
find . -name "*.ts" -o -name "*.js" | xargs grep -l -i "payment\|billing\|subscription\|stripe"
grep -r "subscription\|billing" src/appwrite/
ls functions/ | grep -i "payment\|billing\|subscription"
```

### 2. Analysis Phase (15 minutes)
- Check if any payment processing already exists
- Review database schemas for user accounts and teams
- Identify integration points for Stripe webhooks

### 3. Design Phase (45 minutes)
- Plan StripeHandler function architecture
- Design database schema for subscriptions/payments
- Plan frontend payment component integration

### 4. Implementation Phase
- Create StripeHandler Appwrite function
- Add payment-related database collections
- Implement Stripe webhook handling
- Create frontend payment UI components

## Key Development Commands to Remember
```bash
# Function development
cd functions/[FunctionName] && npm run build

# Frontend development
npm run dev              # Start dev server
npm run build:full       # Build with type checking

# Python API
cd api && uv run dev     # AI services
```

## Recommended Agent Usage
- **typescript-master**: For Stripe SDK type definitions
- **minimal-change-analyzer**: For surgical integration into existing flows
- **problem-decomposer-orchestrator**: For complex payment workflow orchestration

## Context Files to Review First
1. `appwrite.json` - Function configurations
2. `src/appwrite/schemas.ts` - Existing database schemas
3. `functions/*/types/` - Function-specific type definitions
4. `package.json` - Available dependencies

## Success Criteria
- Stripe payments integrated without breaking existing functionality
- Type-safe payment processing with proper error handling
- Webhook handling for subscription lifecycle events
- Frontend payment UI following project patterns