# File References and Context

## Key Configuration Files
- `/Users/natedamstra/socialaize/appwrite.json` - Defines all 25+ serverless functions
- `/Users/natedamstra/socialaize/package.json` - Frontend dependencies (PNPM)
- `/Users/natedamstra/socialaize/CLAUDE.md` - Project instructions and development patterns

## Database Schema Locations
- `src/appwrite/` - Frontend TypeScript definitions for all collections
- `functions/[FunctionName]/types/` - Function-specific schemas

## Appwrite Function Architecture
Each function follows consistent pattern:
```
functions/[FunctionName]/
├── src/main.ts          # Entry point
├── package.json         # Dependencies and build scripts
├── tsconfig.json        # TypeScript configuration
└── types/              # Schema definitions
```

## Payment-Related Areas to Investigate
- User account management functions
- Subscription/billing database schemas
- Team management and permissions
- Usage tracking and limits

## No Files Modified Yet
This bundle represents the starting state before Stripe integration work begins.

## Files to Create/Modify for Stripe Integration
Likely candidates:
- `functions/StripeHandler/` - New payment processing function
- `src/appwrite/schemas.ts` - Add payment-related type definitions
- Frontend components for payment UI
- Database collections for subscriptions, invoices, etc.