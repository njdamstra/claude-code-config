# Modern Content Hierarchy & Layout Patterns 2024-2025
**Research Date:** October 24, 2025
**Focus:** Card design, lists, empty states, navigation, spacing, and modern CSS techniques

---

## Executive Summary

Modern content hierarchy and layout patterns in 2024-2025 emphasize:
- **Hybrid layout approaches** combining CSS Grid (layout), Flexbox (alignment), and Container Queries (modular responsiveness)
- **Accessibility-first card design** with semantic HTML, keyboard navigation, and proper focus states
- **Micro-interactions** that provide delightful feedback without compromising performance
- **Content-aware spacing** using vertical rhythm and 8px-based spacing systems
- **Dark mode support** with optimized typography, contrast ratios, and reduced motion awareness
- **Empty/error states** as critical UX moments with clear copy, illustrations, and recovery paths

---

## 1. Card Design Patterns

### 1.1 Card Anatomy & Structure

**Semantic HTML Structure (Accessibility-First):**

```html
<ul>
  <li>
    <article class="card">
      <header class="card-header">
        <img src="image.jpg" alt="Card visual preview" class="card-image" />
      </header>

      <div class="card-body">
        <h2 class="card-title">
          <a href="/details">Compelling 5-7 Word Title</a>
        </h2>
        <p class="card-subtitle">Supporting metadata, ~10-15 words max</p>
        <p class="card-description">Main content, digestible chunks</p>
        <div class="card-badges">
          <span class="badge">Tag</span>
        </div>
      </div>

      <footer class="card-footer">
        <button class="button">Primary Action</button>
        <button class="button button--secondary">Secondary</button>
      </footer>
    </article>
  </li>
</ul>
```

**Key Accessibility Principles:**
- Cards should be wrapped in `<ul>` and `<li>` for semantic structure
- Screen readers announce list count and position to users
- Headings (preferably `<h2>`) should begin card sections
- Decorative images use `alt=""` (not `role="presentation"`)
- Content source order should match visual hierarchy

**Why this matters:**
- Screen readers provide shortcuts to lists and enumerate items
- Keyboard users navigate between cards and within card content
- Voice control users benefit from semantic structure
- Mobile screen reader users get predictable navigation flow

### 1.2 Interactive Card Patterns

**Pattern 1: Pseudo-Element Click Area (Recommended)**

```html
<article class="card">
  <h2><a href="/details" class="card-link">Title</a></h2>
  <p>Content...</p>
</article>
```

```css
.card {
  position: relative;
}

.card-link::after {
  content: '';
  position: absolute;
  inset: 0; /* Covers entire card */
  z-index: 1;
}

.card:hover {
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
  transform: translateY(-2px);
  transition: all 200ms ease-out;
}

.card:focus-within {
  box-shadow: 0 0 0 3px var(--focus-ring-primary);
  outline: none;
}

.card-link:focus {
  text-decoration: underline;
  text-decoration-thickness: 2px;
}
```

**Pattern 2: Card Container Click (JavaScript)**

```typescript
// Enable entire card as clickable with text selection tolerance
const card = document.querySelector('.card');
const link = card.querySelector('a');

card.addEventListener('click', (e) => {
  // Ignore if user is selecting text (>200ms interaction)
  const selection = window.getSelection()?.toString();
  if (!selection) {
    link.click();
  }
});

// Keyboard: Enter key navigates
card.addEventListener('keydown', (e) => {
  if (e.key === 'Enter') {
    link.click();
  }
});
```

### 1.3 Card Hover States & Micro-Interactions

**Modern Hover Effects (2024-2025):**

```css
.card {
  transition: all 300ms cubic-bezier(0.34, 1.56, 0.64, 1); /* bouncy */
  background: var(--surface-secondary);
  border: 1px solid var(--border-primary);
  border-radius: 12px;
  padding: 20px;
}

/* Elevation shift */
.card:hover {
  box-shadow: 0 12px 32px rgba(0, 0, 0, 0.15);
  transform: translateY(-4px);
}

/* Active state (pressed) */
.card:active {
  transform: translateY(-2px);
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.12);
}

/* Focus state (keyboard) */
.card:focus-within {
  box-shadow: 0 0 0 3px var(--focus-ring-primary);
  border-color: var(--primary-500);
}

/* Respect user preferences */
@media (prefers-reduced-motion: reduce) {
  .card {
    transition: none;
    transform: none;
  }
}

/* Reduced motion for battery-saving */
@media (prefers-reduced-motion: reduce) {
  .card:hover {
    transform: none;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  }
}
```

**Micro-Interaction Examples:**

```css
/* Image focus on hover */
.card-image {
  transition: transform 300ms ease-out;
}

.card:hover .card-image {
  transform: scale(1.05);
}

/* Button reveal on card hover */
.card-action {
  opacity: 0;
  transform: translateY(8px);
  transition: all 200ms ease-out;
  pointer-events: none;
}

.card:hover .card-action {
  opacity: 1;
  transform: translateY(0);
  pointer-events: auto;
}

/* Gradient border on hover */
.card {
  background: linear-gradient(var(--surface-secondary), var(--surface-secondary))
              padding-box,
            linear-gradient(135deg, transparent, var(--primary-500))
              border-box;
  border: 1px solid transparent;
}

.card:hover {
  background: linear-gradient(var(--surface-secondary), var(--surface-secondary))
              padding-box,
            linear-gradient(135deg, var(--primary-500), var(--primary-600))
              border-box;
}
```

### 1.4 Card Grid Systems

**CSS Grid with Auto-Fit (Recommended for 2025):**

```css
/* Container-based responsive without media queries */
.cards-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
  gap: 24px;
  padding: 24px;
}

/* Adjust based on container size, not viewport */
@container (min-width: 800px) {
  .cards-grid {
    grid-template-columns: repeat(auto-fit, minmax(380px, 1fr));
    gap: 32px;
  }
}
```

**Equal Height Cards with Flexbox:**

```html
<article class="card card--equal-height">
  <header class="card-header">
    <img src="..." alt="..." />
  </header>
  <div class="card-body">
    <h2>Title</h2>
    <p>Description can vary in length</p>
  </div>
  <footer class="card-footer card-footer--sticky">
    <button>Action</button>
  </footer>
</article>
```

```css
.card--equal-height {
  display: flex;
  flex-direction: column;
  height: 100%;
}

.card-body {
  flex: 1; /* Grows to fill available space */
}

.card-footer--sticky {
  margin-top: auto; /* Pushes footer to bottom */
}
```

**Masonry Grid (CSS only, no JavaScript):**

```css
.masonry-grid {
  column-count: 3;
  column-gap: 24px;
}

.masonry-item {
  break-inside: avoid;
  margin-bottom: 24px;
}

@media (max-width: 1024px) {
  .masonry-grid {
    column-count: 2;
  }
}

@media (max-width: 640px) {
  .masonry-grid {
    column-count: 1;
  }
}
```

### 1.5 Card Variants by Content Type

**Product Card:**

```html
<article class="card card--product">
  <div class="product-image-container">
    <img src="product.jpg" alt="Product name" />
    <span class="badge badge--sale">-20%</span>
  </div>
  <div class="card-body">
    <div class="product-rating">⭐ 4.5 (128 reviews)</div>
    <h3>Product Name</h3>
    <p class="product-price">$49.99 <s>$62.99</s></p>
  </div>
  <footer class="card-footer">
    <button class="button button--primary">Add to Cart</button>
  </footer>
</article>
```

**Article Card:**

```html
<article class="card card--article">
  <header class="card-header">
    <img src="article.jpg" alt="" />
  </header>
  <div class="card-body">
    <span class="article-category">Design</span>
    <h2><a href="/article">10 Modern Card Patterns</a></h2>
    <p class="article-excerpt">A deep dive into card design...</p>
    <div class="article-meta">
      <span>By Jane Doe</span>
      <span>5 min read</span>
    </div>
  </div>
</article>
```

**Profile Card:**

```html
<article class="card card--profile">
  <img src="avatar.jpg" alt="Jane Doe" class="profile-avatar" />
  <h3>Jane Doe</h3>
  <p class="profile-title">Product Designer</p>
  <p class="profile-bio">Creating delightful experiences.</p>
  <div class="card-footer">
    <button class="button button--secondary">Follow</button>
    <button class="button button--secondary">Message</button>
  </div>
</article>
```

---

## 2. List Patterns

### 2.1 Simple vs Detailed Lists

**Simple List (Compact):**

```html
<ul class="list list--simple">
  <li><a href="/item">Item Title</a></li>
  <li><a href="/item">Item Title</a></li>
  <li><a href="/item">Item Title</a></li>
</ul>
```

```css
.list--simple {
  list-style: none;
  padding: 0;
  margin: 0;
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.list--simple a {
  padding: 0.5rem;
  border-radius: 6px;
  transition: background-color 150ms ease-out;
  display: block;
}

.list--simple a:hover {
  background-color: var(--surface-secondary);
}

.list--simple a:focus {
  outline: 2px solid var(--primary-500);
  outline-offset: 2px;
}
```

**Detailed List (Rich Content):**

```html
<ul class="list list--detailed">
  <li class="list-item">
    <div class="list-item-start">
      <img src="avatar.jpg" alt="Jane Doe" class="list-avatar" />
    </div>
    <div class="list-item-content">
      <h3 class="list-item-title">Jane Doe</h3>
      <p class="list-item-subtitle">jane@example.com</p>
      <p class="list-item-meta">Last active 2 hours ago</p>
    </div>
    <div class="list-item-end">
      <button class="button button--icon">•••</button>
    </div>
  </li>
</ul>
```

```css
.list--detailed {
  list-style: none;
  padding: 0;
  margin: 0;
}

.list-item {
  display: flex;
  align-items: center;
  padding: 1rem;
  border-bottom: 1px solid var(--border-secondary);
  gap: 1rem;
  transition: background-color 150ms ease-out;
}

.list-item:hover {
  background-color: var(--surface-secondary);
}

.list-item-start {
  flex-shrink: 0;
}

.list-item-content {
  flex: 1;
  min-width: 0; /* Enable text truncation */
}

.list-item-end {
  flex-shrink: 0;
}

.list-avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  object-fit: cover;
}

.list-item-title {
  margin: 0;
  font-size: 0.95rem;
  font-weight: 600;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.list-item-subtitle {
  margin: 0.25rem 0 0;
  font-size: 0.85rem;
  color: var(--text-secondary);
}
```

### 2.2 Action Lists (Clickable, Icon-Based)

```html
<ul class="action-list">
  <li>
    <button class="action-list-item" aria-label="Edit post">
      <span class="action-icon">✏️</span>
      <span>Edit</span>
    </button>
  </li>
  <li>
    <button class="action-list-item" aria-label="Delete post">
      <span class="action-icon">🗑️</span>
      <span>Delete</span>
    </button>
  </li>
</ul>
```

```css
.action-list {
  list-style: none;
  padding: 0;
  margin: 0;
  background: var(--surface-secondary);
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.action-list-item {
  width: 100%;
  padding: 1rem;
  border: none;
  background: none;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 0.75rem;
  font-size: 0.95rem;
  color: var(--text-primary);
  transition: all 150ms ease-out;
  border-bottom: 1px solid var(--border-secondary);
}

.action-list-item:last-child {
  border-bottom: none;
}

.action-list-item:hover {
  background-color: var(--surface-tertiary);
}

.action-list-item:focus {
  outline: 2px solid var(--primary-500);
  outline-offset: -2px;
}

.action-list-item[aria-current="page"] {
  background-color: var(--surface-tertiary);
  font-weight: 600;
}

.action-icon {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 24px;
  height: 24px;
  flex-shrink: 0;
}
```

### 2.3 Avatar Lists (User Collections)

```html
<div class="avatar-list">
  <img src="user1.jpg" alt="John Doe" class="avatar" title="John Doe" />
  <img src="user2.jpg" alt="Jane Smith" class="avatar" title="Jane Smith" />
  <img src="user3.jpg" alt="Bob Johnson" class="avatar" title="Bob Johnson" />
  <span class="avatar avatar--overflow">+5</span>
</div>
```

```css
.avatar-list {
  display: flex;
  align-items: center;
  gap: -8px; /* Negative gap for overlap */
}

.avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  border: 2px solid var(--surface-primary);
  object-fit: cover;
  margin-left: -8px;
  transition: transform 200ms ease-out;
}

.avatar:first-child {
  margin-left: 0;
}

.avatar:hover {
  transform: translateY(-4px) scale(1.1);
  z-index: 10;
}

.avatar--overflow {
  background: var(--surface-secondary);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 0.75rem;
  font-weight: 600;
  color: var(--text-secondary);
}
```

### 2.4 Grouped Lists with Headers

```html
<ul class="list-grouped">
  <li class="list-group">
    <h3 class="list-group-header">Recent</h3>
    <ul class="list-group-items">
      <li><a href="#">Item 1</a></li>
      <li><a href="#">Item 2</a></li>
    </ul>
  </li>

  <li class="list-group">
    <h3 class="list-group-header">Older</h3>
    <ul class="list-group-items">
      <li><a href="#">Item 3</a></li>
      <li><a href="#">Item 4</a></li>
    </ul>
  </li>
</ul>
```

```css
.list-grouped {
  list-style: none;
  padding: 0;
  margin: 0;
}

.list-group {
  margin-bottom: 2rem;
}

.list-group-header {
  margin: 0 0 0.5rem;
  font-size: 0.75rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: var(--text-tertiary);
}

.list-group-items {
  list-style: none;
  padding: 0;
  margin: 0;
  border: 1px solid var(--border-secondary);
  border-radius: 8px;
  overflow: hidden;
}

.list-group-items li {
  border-bottom: 1px solid var(--border-secondary);
}

.list-group-items li:last-child {
  border-bottom: none;
}

.list-group-items a {
  display: block;
  padding: 0.75rem 1rem;
  color: var(--text-primary);
  text-decoration: none;
  transition: background-color 150ms ease-out;
}

.list-group-items a:hover {
  background-color: var(--surface-secondary);
}
```

### 2.5 Virtual Scrolling (Performance)

```typescript
// Intersection Observer for lazy loading
interface VirtualListProps {
  items: Item[];
  itemHeight: number;
  renderItem: (item: Item) => ReactNode;
}

export function VirtualList({ items, itemHeight, renderItem }: VirtualListProps) {
  const [visibleRange, setVisibleRange] = useState({ start: 0, end: 20 });
  const containerRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const container = containerRef.current;
    if (!container) return;

    const observer = new IntersectionObserver((entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          const index = +entry.target.id;
          setVisibleRange((prev) => ({
            start: Math.max(0, index - 5),
            end: Math.min(items.length, index + 25),
          }));
        }
      });
    });

    const sentinels = container.querySelectorAll('[data-sentinel]');
    sentinels.forEach((el) => observer.observe(el));

    return () => observer.disconnect();
  }, [items.length]);

  const visibleItems = items.slice(visibleRange.start, visibleRange.end);
  const offsetY = visibleRange.start * itemHeight;

  return (
    <div
      ref={containerRef}
      className="virtual-list"
      style={{ height: items.length * itemHeight }}
    >
      <ul
        style={{
          transform: `translateY(${offsetY}px)`,
        }}
      >
        {visibleItems.map((item, idx) => (
          <li key={visibleRange.start + idx} id={String(visibleRange.start + idx)}>
            {renderItem(item)}
          </li>
        ))}
      </ul>
    </div>
  );
}
```

---

## 3. Empty States & Error States

### 3.1 Empty State Anatomy

**Essential Structure (Headline → Description → CTA):**

```html
<div class="empty-state" role="status" aria-live="polite">
  <div class="empty-state-icon">
    <!-- SVG illustration or icon -->
    <svg>...</svg>
  </div>

  <h2 class="empty-state-headline">No posts yet</h2>

  <p class="empty-state-description">
    Start creating content to engage your audience
  </p>

  <button class="button button--primary">Create Your First Post</button>
</div>
```

```css
.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  min-height: 300px;
  padding: 2rem;
  text-align: center;
}

.empty-state-icon {
  width: 80px;
  height: 80px;
  margin-bottom: 1.5rem;
  opacity: 0.6; /* Subtle, not distracting */
  color: var(--text-secondary);
}

.empty-state-icon svg {
  width: 100%;
  height: 100%;
}

.empty-state-headline {
  margin: 0 0 0.5rem;
  font-size: 1.5rem;
  font-weight: 700;
  color: var(--text-primary);
}

.empty-state-description {
  margin: 0 0 1.5rem;
  font-size: 0.95rem;
  color: var(--text-secondary);
  max-width: 400px;
}

/* Decorative icon should be skipped by screen readers */
.empty-state-icon[aria-hidden="true"] {
  /* Ensures decorative SVGs don't get announced */
}
```

### 3.2 Empty State Variations

**First-Time User (Onboarding):**

```html
<div class="empty-state empty-state--onboarding">
  <div class="empty-state-icon">
    <svg><!-- Welcome illustration --></svg>
  </div>
  <h2>Welcome to Dashboard</h2>
  <p>Get started by completing these setup steps:</p>

  <ol class="setup-steps">
    <li class="step">
      <input type="checkbox" />
      <span>Complete your profile</span>
    </li>
    <li class="step">
      <input type="checkbox" />
      <span>Connect your first account</span>
    </li>
    <li class="step">
      <input type="checkbox" />
      <span>Create your first post</span>
    </li>
  </ol>

  <button class="button button--primary">Get Started →</button>
</div>
```

**Search with No Results:**

```html
<div class="empty-state empty-state--search">
  <div class="empty-state-icon">🔍</div>
  <h2>No results for "nonexistent"</h2>
  <p>Try adjusting your search terms or filters</p>

  <div class="search-suggestions">
    <p class="text-secondary">Suggestions:</p>
    <ul>
      <li><a href="#">Popular searches</a></li>
      <li><a href="#">View all posts</a></li>
      <li><a href="#">Clear filters</a></li>
    </ul>
  </div>
</div>
```

**Cleared State (Task Completed):**

```html
<div class="empty-state empty-state--success">
  <div class="empty-state-icon animated">
    <!-- Animated checkmark -->
    <svg class="checkmark-animation">...</svg>
  </div>
  <h2>All done!</h2>
  <p>You've completed all your tasks</p>
  <button class="button">Create New Task</button>
</div>
```

### 3.3 Error States

**Error State with Recovery Path:**

```html
<div class="error-state" role="alert" aria-live="assertive">
  <div class="error-icon">⚠️</div>

  <h2>Unable to load posts</h2>

  <div class="error-details">
    <p class="error-message">
      We couldn't connect to the server. Please check your connection and try again.
    </p>
    <details class="error-details-technical">
      <summary>Technical details</summary>
      <code>Error: 503 Service Unavailable</code>
    </details>
  </div>

  <div class="error-actions">
    <button class="button button--primary" onclick="location.reload()">
      Try Again
    </button>
    <a href="/help" class="button button--secondary">Get Help</a>
  </div>
</div>
```

```css
.error-state {
  padding: 2rem;
  background-color: var(--error-surface, #fff5f5);
  border-left: 4px solid var(--error-500);
  border-radius: 8px;
  margin: 2rem;
}

.error-state[role="alert"] {
  /* Ensures screen readers announce immediately */
}

.error-icon {
  font-size: 2rem;
  margin-bottom: 1rem;
  display: flex;
  justify-content: center;
}

.error-message {
  color: var(--text-primary);
  margin: 0.5rem 0;
}

.error-details-technical {
  margin-top: 1rem;
  padding: 1rem;
  background-color: var(--surface-secondary);
  border-radius: 6px;
  font-family: monospace;
  font-size: 0.85rem;
}

.error-actions {
  display: flex;
  gap: 1rem;
  margin-top: 1.5rem;
}
```

**404 Error Page:**

```html
<div class="error-page error-page--404">
  <div class="error-page-content">
    <h1 class="error-code">404</h1>
    <h2>Page not found</h2>
    <p>The page you're looking for doesn't exist or has been moved.</p>

    <nav class="error-page-nav">
      <a href="/" class="button button--primary">Back to Home</a>
      <a href="/help" class="button button--secondary">Contact Support</a>
    </nav>
  </div>
</div>
```

---

## 4. Navigation Patterns

### 4.1 Tab Navigation

**Underlined Tabs (Simple):**

```html
<nav class="tabs" role="tablist">
  <button
    role="tab"
    aria-selected="true"
    aria-controls="panel-posts"
    id="tab-posts"
  >
    Posts
  </button>
  <button
    role="tab"
    aria-selected="false"
    aria-controls="panel-comments"
    id="tab-comments"
  >
    Comments
  </button>
  <button
    role="tab"
    aria-selected="false"
    aria-controls="panel-analytics"
    id="tab-analytics"
  >
    Analytics
  </button>
</nav>

<div id="panel-posts" role="tabpanel" aria-labelledby="tab-posts">
  <!-- Content -->
</div>
```

```css
.tabs {
  display: flex;
  border-bottom: 1px solid var(--border-secondary);
  gap: 0; /* Tabs touch each other */
}

.tabs button {
  padding: 0.75rem 1rem;
  border: none;
  background: none;
  cursor: pointer;
  font-weight: 500;
  color: var(--text-secondary);
  border-bottom: 2px solid transparent;
  transition: all 200ms ease-out;
  margin-bottom: -1px; /* Overlap bottom border */
  position: relative;
}

.tabs button:hover {
  color: var(--text-primary);
  background-color: var(--surface-secondary);
}

.tabs button[aria-selected="true"] {
  color: var(--primary-600);
  border-bottom-color: var(--primary-600);
}

.tabs button:focus-visible {
  outline: 2px solid var(--primary-500);
  outline-offset: -2px;
}
```

**Pill Tabs (Rounded):**

```css
.tabs {
  display: flex;
  gap: 0.5rem;
  padding: 0.5rem;
  background-color: var(--surface-secondary);
  border-radius: 8px;
  width: fit-content;
}

.tabs button {
  padding: 0.5rem 1rem;
  border: none;
  border-radius: 6px;
  background: none;
  cursor: pointer;
  color: var(--text-secondary);
  transition: all 150ms ease-out;
}

.tabs button:hover {
  background-color: var(--surface-tertiary);
}

.tabs button[aria-selected="true"] {
  background-color: var(--primary-500);
  color: white;
  font-weight: 600;
}
```

**Segmented Control (Material Design):**

```css
.tabs {
  display: flex;
  gap: 0;
  border: 1px solid var(--border-secondary);
  border-radius: 8px;
  overflow: hidden;
  background-color: var(--surface-secondary);
}

.tabs button {
  flex: 1;
  padding: 0.75rem;
  border: none;
  border-right: 1px solid var(--border-secondary);
  background: none;
  cursor: pointer;
  color: var(--text-secondary);
  font-weight: 500;
}

.tabs button:last-child {
  border-right: none;
}

.tabs button[aria-selected="true"] {
  background-color: var(--primary-500);
  color: white;
}
```

### 4.2 Breadcrumbs

**Standard Breadcrumbs:**

```html
<nav class="breadcrumbs" aria-label="Breadcrumb">
  <ol>
    <li><a href="/">Home</a></li>
    <li><a href="/dashboard">Dashboard</a></li>
    <li><a href="/posts">Posts</a></li>
    <li aria-current="page">Edit Post</li>
  </ol>
</nav>
```

```css
.breadcrumbs ol {
  list-style: none;
  padding: 0;
  margin: 0;
  display: flex;
  gap: 0.5rem;
}

.breadcrumbs li {
  display: flex;
  align-items: center;
}

.breadcrumbs li::after {
  content: '/';
  margin: 0 0.5rem;
  color: var(--text-tertiary);
}

.breadcrumbs li:last-child::after {
  content: none;
}

.breadcrumbs a {
  color: var(--primary-600);
  text-decoration: none;
  transition: color 150ms ease-out;
}

.breadcrumbs a:hover {
  color: var(--primary-700);
  text-decoration: underline;
}

.breadcrumbs li[aria-current="page"] {
  color: var(--text-secondary);
}
```

### 4.3 Pagination

**Numeric Pagination:**

```html
<nav class="pagination" aria-label="Pagination">
  <button aria-label="Previous page" class="pagination-prev">←</button>

  <button aria-current="page">1</button>
  <button>2</button>
  <button>3</button>
  <span class="pagination-ellipsis">...</span>
  <button>10</button>

  <button aria-label="Next page" class="pagination-next">→</button>
</nav>
```

```css
.pagination {
  display: flex;
  gap: 0.5rem;
  justify-content: center;
  align-items: center;
  margin: 2rem 0;
}

.pagination button {
  min-width: 40px;
  height: 40px;
  padding: 0.5rem;
  border: 1px solid var(--border-secondary);
  border-radius: 6px;
  background: var(--surface-secondary);
  cursor: pointer;
  font-weight: 500;
  transition: all 150ms ease-out;
}

.pagination button:hover {
  background-color: var(--surface-tertiary);
  border-color: var(--border-primary);
}

.pagination button[aria-current="page"] {
  background-color: var(--primary-500);
  color: white;
  border-color: var(--primary-600);
  cursor: default;
}

.pagination-ellipsis {
  padding: 0 0.5rem;
  color: var(--text-tertiary);
}
```

### 4.4 Steps/Progress Indicators

**Linear Steps (Horizontal):**

```html
<div class="steps">
  <div class="step step--complete">
    <div class="step-number">1</div>
    <div class="step-title">Create Account</div>
  </div>

  <div class="step-divider step-divider--complete"></div>

  <div class="step step--complete">
    <div class="step-number">2</div>
    <div class="step-title">Connect Accounts</div>
  </div>

  <div class="step-divider"></div>

  <div class="step step--active">
    <div class="step-number">3</div>
    <div class="step-title">Create Post</div>
  </div>

  <div class="step-divider"></div>

  <div class="step">
    <div class="step-number">4</div>
    <div class="step-title">Schedule</div>
  </div>
</div>
```

```css
.steps {
  display: flex;
  align-items: center;
  gap: 1rem;
  margin: 2rem 0;
}

.step {
  display: flex;
  flex-direction: column;
  align-items: center;
  flex-shrink: 0;
}

.step-number {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 700;
  background-color: var(--surface-secondary);
  border: 2px solid var(--border-secondary);
  color: var(--text-secondary);
  transition: all 200ms ease-out;
}

.step--complete .step-number {
  background-color: var(--success-500);
  border-color: var(--success-600);
  color: white;
}

.step--active .step-number {
  background-color: var(--primary-500);
  border-color: var(--primary-600);
  color: white;
  box-shadow: 0 0 0 4px var(--primary-100);
}

.step-title {
  font-size: 0.85rem;
  margin-top: 0.5rem;
  text-align: center;
  color: var(--text-secondary);
}

.step--active .step-title {
  color: var(--text-primary);
  font-weight: 600;
}

.step-divider {
  flex: 1;
  height: 2px;
  background-color: var(--border-secondary);
  margin: 0 0.5rem;
  margin-bottom: 2.5rem;
  transition: background-color 200ms ease-out;
}

.step-divider--complete {
  background-color: var(--success-500);
}
```

---

## 5. Content Density & Spacing

### 5.1 Spacing System (8px Grid)

**CSS Custom Properties (Design System):**

```css
:root {
  /* 8px base unit spacing */
  --spacing-0: 0;
  --spacing-1: 0.25rem; /* 4px */
  --spacing-2: 0.5rem;  /* 8px */
  --spacing-3: 0.75rem; /* 12px */
  --spacing-4: 1rem;    /* 16px */
  --spacing-6: 1.5rem;  /* 24px */
  --spacing-8: 2rem;    /* 32px */
  --spacing-12: 3rem;   /* 48px */
  --spacing-16: 4rem;   /* 64px */

  /* Density presets */
  --density-compact: 0.75;
  --density-normal: 1;
  --density-comfortable: 1.25;
}
```

**Responsive Spacing:**

```css
.card {
  padding: var(--spacing-4);
  gap: var(--spacing-3);
}

@media (max-width: 640px) {
  .card {
    padding: var(--spacing-3);
    gap: var(--spacing-2);
  }
}

/* Comfortable layout on desktop, compact on mobile */
.container {
  padding: var(--spacing-8);
  gap: var(--spacing-6);
}

@container (max-width: 600px) {
  .container {
    padding: var(--spacing-4);
    gap: var(--spacing-3);
  }
}
```

### 5.2 Vertical Rhythm

**Typography Baseline Grid:**

```css
:root {
  --line-height-base: 1.5;
  --font-size-body: 1rem;
  --line-height: calc(var(--font-size-body) * var(--line-height-base)); /* 24px */
}

body {
  line-height: var(--line-height-base);
  font-size: var(--font-size-body);
}

h1 {
  margin-top: calc(var(--line-height) * 2);
  margin-bottom: calc(var(--line-height) * 1);
  line-height: 1.2;
}

h2 {
  margin-top: calc(var(--line-height) * 1.5);
  margin-bottom: var(--line-height);
  line-height: 1.3;
}

p {
  margin-bottom: var(--line-height);
}

/* Ensures all text aligns to baseline grid */
blockquote,
pre,
ul,
ol {
  margin-bottom: var(--line-height);
}
```

### 5.3 Visual Grouping with Dividers

**Dividers as Separators:**

```html
<section>
  <h2>Recent Activity</h2>
  <ul class="activity-list">
    <li>User joined</li>
    <li>Post published</li>
  </ul>
</section>

<hr class="divider divider--subtle" />

<section>
  <h2>Older Activity</h2>
  <ul class="activity-list">
    <li>Comment posted</li>
  </ul>
</section>
```

```css
.divider {
  margin: 2rem 0;
  border: none;
  border-top: 1px solid var(--border-secondary);
}

.divider--subtle {
  border-color: var(--border-tertiary);
}

.divider--emphasis {
  border-color: var(--border-primary);
}

.divider--dashed {
  border-top-style: dashed;
}

/* Gradient divider */
.divider--gradient {
  background: linear-gradient(
    to right,
    transparent,
    var(--border-secondary),
    transparent
  );
  height: 1px;
  border: none;
}
```

---

## 6. Status Indicators & Badges

### 6.1 Badges & Labels

```html
<div class="badge badge--primary">Featured</div>
<div class="badge badge--success">Approved</div>
<div class="badge badge--warning">Pending</div>
<div class="badge badge--error">Rejected</div>

<!-- With count -->
<span class="badge badge--notification">5</span>

<!-- Dot indicator -->
<span class="status-dot status-dot--online"></span>
```

```css
.badge {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.25rem 0.75rem;
  border-radius: 999px;
  font-size: 0.75rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  white-space: nowrap;
  transition: all 150ms ease-out;
}

.badge--primary {
  background-color: var(--primary-100);
  color: var(--primary-700);
  border: 1px solid var(--primary-200);
}

.badge--success {
  background-color: var(--success-100);
  color: var(--success-700);
}

.badge--warning {
  background-color: var(--warning-100);
  color: var(--warning-700);
}

.badge--error {
  background-color: var(--error-100);
  color: var(--error-700);
}

/* Notification badge (numeric) */
.badge--notification {
  background-color: var(--error-500);
  color: white;
  padding: 0.25rem 0.5rem;
  min-width: 20px;
  justify-content: center;
  position: absolute;
  top: -8px;
  right: -8px;
  font-size: 0.65rem;
}

/* Status dot indicators */
.status-dot {
  display: inline-block;
  width: 8px;
  height: 8px;
  border-radius: 50%;
  animation: none;
}

.status-dot--online {
  background-color: var(--success-500);
}

.status-dot--away {
  background-color: var(--warning-500);
}

.status-dot--busy {
  background-color: var(--error-500);
}

.status-dot--offline {
  background-color: var(--text-tertiary);
}

/* Pulsing animation for online status */
.status-dot--online::after {
  content: '';
  position: absolute;
  width: 100%;
  height: 100%;
  border-radius: 50%;
  border: 2px solid var(--success-500);
  opacity: 0;
  animation: pulse 2s ease-in-out infinite;
}

@keyframes pulse {
  0%, 100% { opacity: 0; transform: scale(1); }
  50% { opacity: 0.5; }
}

/* Respect reduced motion */
@media (prefers-reduced-motion: reduce) {
  .status-dot--online::after {
    animation: none;
  }
}
```

### 6.2 Progress Indicators

**Linear Progress Bar:**

```html
<div class="progress-bar" role="progressbar" aria-valuenow="65" aria-valuemin="0" aria-valuemax="100">
  <div class="progress-bar-fill" style="width: 65%"></div>
</div>
```

```css
.progress-bar {
  width: 100%;
  height: 8px;
  border-radius: 4px;
  background-color: var(--surface-secondary);
  overflow: hidden;
}

.progress-bar-fill {
  height: 100%;
  background: linear-gradient(90deg, var(--primary-500), var(--primary-600));
  transition: width 300ms ease-out;
  border-radius: 4px;
}

/* Indeterminate state (loading) */
.progress-bar--indeterminate .progress-bar-fill {
  background: linear-gradient(90deg, transparent, var(--primary-500), transparent);
  background-size: 200% 100%;
  animation: loading 1.5s ease-in-out infinite;
}

@keyframes loading {
  0% { background-position: 200% 0; }
  100% { background-position: -200% 0; }
}

/* Circular progress (skeleton) */
.progress-circular {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  border: 3px solid var(--border-secondary);
  border-top-color: var(--primary-500);
  animation: spin 1s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}
```

---

## 7. Information Architecture

### 7.1 Visual Hierarchy Techniques

**F-Pattern (Scanning Layout):**

```html
<article class="f-pattern-layout">
  <header class="main-header">
    <h1>Main Headline</h1>
  </header>

  <div class="feature-section">
    <img src="feature.jpg" alt="" class="feature-image" />
  </div>

  <div class="subheader-section">
    <h2>Primary Subheading</h2>
    <p>Supporting text that explains the subheading.</p>
  </div>

  <section class="content-columns">
    <div>
      <h3>Left Column (Scanned First)</h3>
      <p>Users scan the left side of the page.</p>
    </div>
    <div>
      <h3>Right Column (Scanned Second)</h3>
      <p>Then move to the right for secondary content.</p>
    </div>
  </section>
</article>
```

```css
/* F-pattern: Horizontal → Down → Horizontal */
.main-header {
  margin-bottom: 3rem;
}

.main-header h1 {
  font-size: 2.5rem;
  font-weight: 800;
  color: var(--text-primary);
  margin: 0;
}

.feature-section {
  margin-bottom: 2rem;
}

.feature-image {
  width: 100%;
  height: auto;
  border-radius: 12px;
}

.subheader-section {
  margin-bottom: 2rem;
}

.subheader-section h2 {
  font-size: 1.75rem;
  font-weight: 700;
}

.content-columns {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 2rem;
}

@media (max-width: 768px) {
  .content-columns {
    grid-template-columns: 1fr;
  }
}
```

**Z-Pattern (Diagonal Scanning):**

```html
<section class="z-pattern">
  <div class="z-top-left">
    <h1>Primary Call-to-Action</h1>
  </div>

  <div class="z-top-right">
    <span class="badge">Limited Time</span>
  </div>

  <div class="z-diagonal">
    <img src="hero.jpg" alt="Hero image" />
  </div>

  <div class="z-bottom-left">
    <p>Supporting copy here</p>
  </div>

  <div class="z-bottom-right">
    <button class="button button--primary">Get Started</button>
  </div>
</section>
```

### 7.2 Grid Systems

**12-Column Grid:**

```css
.grid {
  display: grid;
  grid-template-columns: repeat(12, 1fr);
  gap: 1rem;
  max-width: 1200px;
  margin: 0 auto;
}

.grid-full { grid-column: 1 / -1; }        /* Full width */
.grid-half { grid-column: span 6; }        /* 50% */
.grid-third { grid-column: span 4; }       /* 33% */
.grid-quarter { grid-column: span 3; }     /* 25% */
.grid-two-thirds { grid-column: span 8; }  /* 67% */

/* Responsive */
@media (max-width: 768px) {
  .grid {
    grid-template-columns: repeat(6, 1fr);
  }

  .grid-third { grid-column: span 6; }
}

@media (max-width: 480px) {
  .grid {
    grid-template-columns: 1fr;
  }

  .grid-full,
  .grid-half,
  .grid-third,
  .grid-quarter {
    grid-column: 1 / -1;
  }
}
```

**CSS Subgrid (Modern):**

```css
.card-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 2rem;
}

.card {
  display: grid;
  grid-template-columns: subgrid;
  grid-column: span 1;
}

/* All cards align to same column grid */
.card-header { grid-column: 1; }
.card-body { grid-column: 1; }
.card-footer { grid-column: 1; }
```

---

## 8. Modern Layout Techniques

### 8.1 CSS Grid Auto-Fit & Minmax

**Responsive Grid without Media Queries:**

```css
/* 320px minimum card width, grows to fill available space */
.responsive-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
  gap: 24px;
  padding: 24px;
}

/* Auto-fill variant (creates empty tracks) */
.auto-fill-grid {
  grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
}

/* With max-width constraint */
.constrained-grid {
  max-width: 1400px;
  margin: 0 auto;
}
```

### 8.2 Container Queries

**Size-Based Component Styling:**

```html
<div class="card-container">
  <article class="card">
    <!-- Content adapts to container size, not viewport -->
  </article>
</div>
```

```css
.card-container {
  container-type: inline-size;
}

.card {
  padding: 1rem;
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

/* When container > 400px, switch to horizontal layout */
@container (min-width: 400px) {
  .card {
    display: grid;
    grid-template-columns: auto 1fr;
    gap: 1.5rem;
  }

  .card-image {
    grid-column: 1;
    width: 120px;
  }

  .card-body {
    grid-column: 2;
  }
}

@container (min-width: 600px) {
  .card {
    padding: 2rem;
    grid-template-columns: 1fr 1fr;
  }
}
```

### 8.3 Aspect Ratio & Overflow

**Aspect Ratio Boxes:**

```css
.image-container {
  aspect-ratio: 16 / 9;
  overflow: hidden;
  border-radius: 8px;
}

.image-container img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  object-position: center;
}

/* Video containers */
.video-container {
  aspect-ratio: 16 / 9;
  position: relative;
}

.video-container iframe {
  position: absolute;
  width: 100%;
  height: 100%;
  border: none;
}

/* Profile squares */
.avatar {
  aspect-ratio: 1;
}
```

**Text Overflow Handling:**

```css
/* Single line truncation */
.text-truncate {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

/* Multi-line truncation (3 lines max) */
.text-clamp {
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

/* Expandable text */
.text-expandable {
  max-height: 120px;
  overflow: hidden;
  transition: max-height 300ms ease-out;
}

.text-expandable.expanded {
  max-height: none;
}
```

### 8.4 Sticky Positioning Patterns

**Sticky Header:**

```css
.table-sticky {
  position: relative;
}

.table-header {
  position: sticky;
  top: 0;
  background-color: var(--surface-primary);
  z-index: 10;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
}

/* Sticky sidebar */
.sidebar {
  position: sticky;
  top: 20px;
  max-height: calc(100vh - 40px);
  overflow-y: auto;
}
```

---

## 9. Accessibility Patterns

### 9.1 ARIA & Semantic HTML

**Proper ARIA Usage:**

```html
<!-- Good: Semantic + ARIA for custom components -->
<div class="custom-select" role="combobox" aria-expanded="false" aria-haspopup="listbox">
  <input type="text" aria-label="Select an option" />
  <ul role="listbox" hidden>
    <li role="option" aria-selected="true">Option 1</li>
    <li role="option">Option 2</li>
  </ul>
</div>

<!-- Better: Use native elements -->
<select aria-label="Select an option">
  <option>Option 1</option>
  <option>Option 2</option>
</select>

<!-- Dialog with proper ARIA -->
<div class="dialog" role="dialog" aria-labelledby="dialog-title" aria-modal="true">
  <h2 id="dialog-title">Confirm Action</h2>
  <p>Are you sure?</p>
  <button autofocus>Confirm</button>
  <button>Cancel</button>
</div>
```

### 9.2 Keyboard Navigation

```typescript
// Tab order management
function setupTabbableElements() {
  const tabbables = document.querySelectorAll(
    'a, button, input, select, textarea, [tabindex]:not([tabindex="-1"])'
  );

  // First element gets focus
  const firstTabbable = tabbables[0] as HTMLElement;
  firstTabbable?.focus();

  // Trap focus in modal
  document.addEventListener('keydown', (e) => {
    if (e.key !== 'Tab') return;

    const lastTabbable = tabbables[tabbables.length - 1] as HTMLElement;

    if (e.shiftKey && document.activeElement === firstTabbable) {
      e.preventDefault();
      lastTabbable?.focus();
    } else if (!e.shiftKey && document.activeElement === lastTabbable) {
      e.preventDefault();
      firstTabbable?.focus();
    }
  });
}

// Escape key to close modal
document.addEventListener('keydown', (e) => {
  if (e.key === 'Escape') {
    closeModal();
  }
});

// Arrow keys for lists
function handleArrowKeys(container: HTMLElement) {
  const items = container.querySelectorAll('[role="option"]');
  let currentIndex = 0;

  container.addEventListener('keydown', (e) => {
    switch (e.key) {
      case 'ArrowDown':
        e.preventDefault();
        currentIndex = (currentIndex + 1) % items.length;
        (items[currentIndex] as HTMLElement).focus();
        break;
      case 'ArrowUp':
        e.preventDefault();
        currentIndex = (currentIndex - 1 + items.length) % items.length;
        (items[currentIndex] as HTMLElement).focus();
        break;
      case 'Enter':
        e.preventDefault();
        (items[currentIndex] as HTMLElement).click();
        break;
    }
  });
}
```

### 9.3 Focus Management

```css
/* Visible focus indicators */
button:focus,
a:focus,
input:focus,
select:focus,
textarea:focus {
  outline: 2px solid var(--primary-500);
  outline-offset: 2px;
}

/* Focus visible for modern browsers (keyboard only) */
button:focus-visible,
a:focus-visible {
  outline: 2px solid var(--primary-500);
  outline-offset: 2px;
}

/* Remove outline on mouse click, keep on keyboard */
button:focus:not(:focus-visible) {
  outline: none;
}

/* Focus within for grouped elements */
.input-group:focus-within {
  box-shadow: 0 0 0 3px var(--primary-100);
  border-color: var(--primary-500);
}
```

---

## 10. Dark Mode Considerations

### 10.1 Dark Mode Implementation

```css
:root {
  /* Light mode (default) */
  --bg-primary: #ffffff;
  --bg-secondary: #f5f5f5;
  --text-primary: #000000;
  --text-secondary: #666666;
  --border-color: #e0e0e0;
}

/* Dark mode with data attribute */
[data-theme="dark"] {
  --bg-primary: #121212;
  --bg-secondary: #1e1e1e;
  --text-primary: #ffffff;
  --text-secondary: #999999;
  --border-color: #333333;
  color-scheme: dark;
}

/* Or use prefers-color-scheme */
@media (prefers-color-scheme: dark) {
  :root {
    --bg-primary: #121212;
    --bg-secondary: #1e1e1e;
    --text-primary: #ffffff;
    --text-secondary: #999999;
  }
}
```

### 10.2 Dark Mode Typography

```css
/* Dark mode font sizes and weights */
body {
  font-size: 16px;
  line-height: 1.5;
}

[data-theme="dark"] body {
  font-size: 16px;
  line-height: 1.6; /* Slightly more line height in dark mode */
}

/* Avoid thin fonts in dark mode */
[data-theme="dark"] h1,
[data-theme="dark"] h2 {
  font-weight: 600; /* Not 700, prevents blur */
}

/* Reduced opacity text in dark mode */
[data-theme="dark"] .text-secondary {
  color: var(--text-secondary);
  opacity: 0.8;
}

/* Contrast ratios for dark mode */
[data-theme="dark"] {
  /* 4.5:1 for body text (AA) */
  --text-primary: hsl(0, 0%, 95%); /* Light enough */
  /* 3:1 for large text (AA) */
  --text-secondary: hsl(0, 0%, 65%);
}
```

---

## 11. Performance Best Practices

### 11.1 CSS Optimization

```css
/* Use CSS Grid for layout (performs better than absolute positioning) */
.layout {
  display: grid;
  grid-template-columns: 1fr 3fr 1fr;
  gap: 1rem;
}

/* Avoid expensive properties on hover */
.card:hover {
  /* Good - only shadow and color */
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
  background-color: var(--surface-secondary);
}

/* Bad - causes layout reflow */
.card:hover {
  width: 101%; /* Reflow! */
  height: 101%; /* Reflow! */
}

/* Use transform instead of top/left for animations */
.card--sliding {
  transition: transform 300ms ease-out;
}

.card--sliding.open {
  transform: translateX(100%);
}

/* Batch animations with will-change sparingly */
.expensive-animation {
  will-change: transform;
  animation: slide 3s ease-out forwards;
}

/* Remove will-change after animation */
@media (prefers-reduced-motion: no-preference) {
  .expensive-animation {
    animation: slide 3s ease-out forwards;
  }
}
```

### 11.2 JavaScript Performance

```typescript
// Debounce window resize with container queries
let resizeTimeout: ReturnType<typeof setTimeout>;
window.addEventListener('resize', () => {
  clearTimeout(resizeTimeout);
  resizeTimeout = setTimeout(() => {
    // Recalculate container sizes
  }, 300);
});

// Intersection Observer for lazy loading
const imageObserver = new IntersectionObserver((entries) => {
  entries.forEach((entry) => {
    if (entry.isIntersecting) {
      const img = entry.target as HTMLImageElement;
      img.src = img.dataset.src || '';
      imageObserver.unobserve(img);
    }
  });
});

document.querySelectorAll('img[data-src]').forEach((img) => {
  imageObserver.observe(img);
});

// Use requestAnimationFrame for smooth scrolling updates
let ticking = false;
window.addEventListener('scroll', () => {
  if (!ticking) {
    requestAnimationFrame(() => {
      // Update parallax, sticky elements, etc.
      ticking = false;
    });
    ticking = true;
  }
});
```

---

## 12. Real-World Design System Examples

### Stripe Design System Patterns
- **Cards:** Product cards with gradients, shadows, hover scale
- **Modals:** Centered, with overlay blur
- **Forms:** Inline validation, contextual help text
- **Navigation:** Mega menus with categorized links

### Linear Design System Patterns
- **Sidebar:** Collapsible, keyboard shortcuts displayed
- **Issues List:** Checkboxes, assignee avatars, status badges
- **Code Blocks:** Syntax highlighting, copy button
- **Minimalist cards:** Subtle borders, monochrome design

### Vercel Design System Patterns
- **Terminal-style:** Monospace fonts for code blocks
- **Deployment cards:** Status indicators, deploy buttons
- **Grid layouts:** Masonry for project showcases
- **Dark-first design:** Default dark with light mode option

### Shopify Design System Patterns
- **Product cards:** Image, price, availability, action buttons
- **Tables:** Sortable headers, pagination, bulk actions
- **Forms:** Inline help, error states, validation messages
- **Analytics:** Line charts, bar charts, data cards

---

## 13. Summary & Action Items

### Best Practices Checklist

**Card Design**
- [ ] Use semantic HTML (`<article>`, `<h2>` headings)
- [ ] Ensure entire card is clickable with pseudo-element
- [ ] Implement keyboard focus states (outline, underline)
- [ ] Add hover animations (shadow, transform)
- [ ] Respect `prefers-reduced-motion`

**Layout & Spacing**
- [ ] Use CSS Grid for page layouts
- [ ] Use Flexbox for component alignment
- [ ] Implement 8px-based spacing system
- [ ] Maintain vertical rhythm with line-height multiples
- [ ] Use container queries for responsive components

**Accessibility**
- [ ] Semantic HTML first, ARIA as enhancement
- [ ] Keyboard navigation (Tab, Arrow keys, Enter, Escape)
- [ ] Focus management with visible indicators
- [ ] 4.5:1 contrast ratio for body text
- [ ] WCAG 2.1 AA compliance minimum

**Dark Mode**
- [ ] Support `prefers-color-scheme` or data attribute
- [ ] Increase line-height by ~0.1 in dark mode
- [ ] Use font-weight 600 instead of 700
- [ ] Maintain 4.5:1 contrast in both modes

**Performance**
- [ ] Prefer CSS transforms over position changes
- [ ] Use Intersection Observer for lazy loading
- [ ] Minimize expensive animations (shadows, blur)
- [ ] Use `will-change` sparingly
- [ ] Test with reduced motion enabled

### Resources
- **Inclusive Components:** https://inclusive-components.design/
- **Modern CSS:** https://moderncss.dev/
- **WCAG 2.1 Guidelines:** https://www.w3.org/WAI/WCAG21/quickref/
- **Design System Reference:** https://www.designsystems.com/

---

**Report Generated:** October 24, 2025
**Researched By:** Web Research Agent
**Sources:** 13 high-authority design resources, 4 design system examples, WCAG specifications
