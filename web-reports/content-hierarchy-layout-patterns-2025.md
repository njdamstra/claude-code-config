# Modern Content Hierarchy & Layout Patterns 2024-2025
**Research Date:** October 24, 2025
**Status:** Comprehensive guide with code examples and best practices

---

## Executive Summary

This report synthesizes modern content hierarchy and layout patterns for 2024-2025, covering card design, lists, empty states, navigation, spacing, status indicators, information architecture, and cutting-edge CSS techniques. Key findings: **container queries are replacing media query dependencies**, **CSS Grid auto-fit patterns dominate 2D layouts**, **virtual scrolling enables performance-first list implementations**, and **empty states transform from blank slates to conversion opportunities**.

---

## 1. Card Design Patterns

### 1.1 Why Cards Dominate 2025

Cards have evolved from trends to core UI patterns. Modern applications use cards because they:
- Chunk content into bite-sized, scannable pieces
- Adapt flexibly to responsive layouts
- Support multiple content types (media, text, actions)
- Enable grid or masonry layouts seamlessly

**Use Cases:** SaaS dashboards, media feeds, e-commerce, real estate, profile-based apps

### 1.2 Card Anatomy (Standard)

```html
<div class="card">
  <!-- Header (optional) -->
  <div class="card-header">
    <h3 class="card-title">Card Title</h3>
    <span class="card-meta">Posted 2 hours ago</span>
  </div>

  <!-- Visual (optional) -->
  <img src="image.jpg" alt="Card image" class="card-visual" />

  <!-- Body -->
  <div class="card-body">
    <p class="card-description">Main content goes here</p>
  </div>

  <!-- Footer (optional) -->
  <div class="card-footer">
    <button class="btn btn-primary">Action</button>
    <button class="btn btn-secondary">Secondary</button>
  </div>
</div>
```

### 1.3 Card Variants

#### Vertical Card (Default)
```css
.card {
  display: flex;
  flex-direction: column;
  gap: 1rem;
  padding: 1.5rem;
  border-radius: 0.5rem;
  background: var(--surface-secondary);
  box-shadow: var(--shadow-md);
}

.card-visual {
  aspect-ratio: 16 / 9;
  object-fit: cover;
  border-radius: 0.375rem;
}
```

#### Horizontal Card
```css
.card--horizontal {
  flex-direction: row;
  gap: 1.5rem;
}

.card--horizontal .card-visual {
  width: 200px;
  min-width: 200px;
  aspect-ratio: auto;
  height: 150px;
  object-fit: cover;
}
```

#### Overlay Card (Image with text overlay)
```css
.card--overlay {
  position: relative;
  overflow: hidden;
}

.card--overlay .card-visual {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.card--overlay .card-body {
  position: relative;
  z-index: 1;
  background: linear-gradient(
    to top,
    rgba(0, 0, 0, 0.8) 0%,
    transparent 100%
  );
  color: white;
  padding: 2rem 1.5rem 1.5rem;
  margin-top: auto;
}
```

#### Featured Card (Prominent, larger)
```css
.card--featured {
  grid-column: span 2;
  grid-row: span 2;
  padding: 2rem;
}

@media (max-width: 640px) {
  .card--featured {
    grid-column: span 1;
    grid-row: span 1;
  }
}
```

### 1.4 Card Hover States & Micro-interactions

```css
.card {
  transition: all 200ms cubic-bezier(0.4, 0, 0.2, 1);
  cursor: pointer;
  border: 1px solid var(--border-subtle);
}

.card:hover {
  transform: translateY(-4px);
  box-shadow: var(--shadow-lg);
  border-color: var(--primary-300);
}

/* Focus state for accessibility */
.card:focus-within {
  outline: 2px solid var(--primary-500);
  outline-offset: 2px;
}

/* Disabled state */
.card:disabled,
.card[aria-disabled="true"] {
  opacity: 0.6;
  cursor: not-allowed;
  pointer-events: none;
}

/* Loading state */
.card.is-loading .card-body {
  opacity: 0.6;
  pointer-events: none;
}

.card.is-loading::after {
  content: "";
  position: absolute;
  inset: 0;
  background: linear-gradient(
    90deg,
    transparent 0%,
    rgba(255, 255, 255, 0.2) 50%,
    transparent 100%
  );
  animation: shimmer 2s infinite;
}

@keyframes shimmer {
  0% {
    transform: translateX(-100%);
  }
  100% {
    transform: translateX(100%);
  }
}
```

### 1.5 Card Grid Systems

#### Equal Height Grid (Auto-fit)
```css
.card-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 1.5rem;
}

/* All cards stretch to container height */
.card-grid .card {
  height: 100%;
}
```

#### Masonry-like Layout (CSS Grid)
```css
.card-grid--masonry {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  grid-auto-rows: max-content;
  gap: 1.5rem;
}

/* No artificial height constraints */
```

#### Flexible 3-Column (Desktop) → 2-Column (Tablet) → 1-Column (Mobile)
```css
.card-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 1.5rem;
}

@media (max-width: 1024px) {
  .card-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 640px) {
  .card-grid {
    grid-template-columns: 1fr;
  }
}
```

#### Container Query Responsive Cards (2025 Best Practice)
```css
.card-grid {
  container-type: inline-size;
}

.card {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

/* At narrow container width: stack vertically, hide description */
.card .card-description {
  display: none;
}

/* At 350px+ container width: horizontal layout, show description */
@container (min-width: 350px) {
  .card {
    display: grid;
    grid-template-columns: 40% 1fr;
    align-items: center;
    gap: 1rem;
  }

  .card .card-description {
    display: block;
  }
}

/* At 500px+ container width: add more content */
@container (min-width: 500px) {
  .card-footer {
    display: flex;
    gap: 0.5rem;
  }
}
```

### 1.6 Card Types by Content

#### Product Card
```html
<div class="card card--product">
  <img src="product.jpg" alt="Product" class="card-visual" />
  <div class="card-body">
    <div class="card-badge">New</div>
    <h3 class="card-title">Product Name</h3>
    <p class="card-price">$99.99</p>
    <div class="card-rating" aria-label="4.5 out of 5 stars">
      ★★★★☆ (128 reviews)
    </div>
  </div>
  <div class="card-footer">
    <button class="btn btn-primary">Add to Cart</button>
    <button class="btn btn-ghost" aria-label="Save to wishlist">
      ♡
    </button>
  </div>
</div>
```

#### Article Card
```html
<article class="card card--article">
  <img src="article.jpg" alt="Article" class="card-visual" />
  <div class="card-body">
    <span class="card-category">Category</span>
    <h2 class="card-title">Article Headline</h2>
    <p class="card-excerpt">Brief summary of the article...</p>
    <div class="card-meta">
      <span>By John Doe</span>
      <time datetime="2025-10-24">Oct 24</time>
    </div>
  </div>
</article>
```

#### Profile Card
```html
<div class="card card--profile">
  <img src="avatar.jpg" alt="User avatar" class="card-avatar" />
  <div class="card-body">
    <h3 class="card-title">User Name</h3>
    <p class="card-subtitle">@username</p>
    <p class="card-bio">Brief bio or description</p>
  </div>
  <div class="card-footer">
    <button class="btn btn-primary">Follow</button>
    <button class="btn btn-secondary">Message</button>
  </div>
</div>
```

---

## 2. List Patterns

### 2.1 Simple Lists

#### Unordered List (Default)
```html
<ul class="list">
  <li class="list-item">
    <span class="list-icon">✓</span>
    <span class="list-label">Item 1</span>
  </li>
  <li class="list-item">
    <span class="list-icon">✓</span>
    <span class="list-label">Item 2</span>
  </li>
</ul>
```

```css
.list {
  list-style: none;
  padding: 0;
  margin: 0;
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.list-item {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.75rem;
  border-radius: 0.375rem;
  transition: background-color 200ms;
}

.list-item:hover {
  background-color: var(--surface-tertiary);
}

.list-icon {
  flex-shrink: 0;
  width: 1.25rem;
  height: 1.25rem;
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--success-500);
}
```

### 2.2 Detailed Lists with Actions

```html
<ul class="list list--detailed">
  <li class="list-item">
    <div class="list-content">
      <h4 class="list-title">Item Title</h4>
      <p class="list-description">Supporting description</p>
    </div>
    <div class="list-actions">
      <button class="btn btn-ghost btn-sm" aria-label="Edit">
        ✎
      </button>
      <button class="btn btn-ghost btn-sm" aria-label="Delete">
        ✕
      </button>
    </div>
  </li>
</ul>
```

```css
.list--detailed .list-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 1rem;
  padding: 1rem;
  border: 1px solid var(--border-subtle);
  border-radius: 0.5rem;
}

.list-content {
  flex: 1;
  min-width: 0; /* Enable text truncation */
}

.list-title {
  margin: 0 0 0.25rem 0;
  font-size: 1rem;
  font-weight: 600;
}

.list-description {
  margin: 0;
  font-size: 0.875rem;
  color: var(--text-secondary);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.list-actions {
  display: flex;
  gap: 0.5rem;
  flex-shrink: 0;
}
```

### 2.3 Avatar Lists (User Lists, Contacts)

```html
<ul class="avatar-list">
  <li class="avatar-list-item">
    <img
      src="avatar1.jpg"
      alt="User 1"
      class="avatar"
      title="User 1"
    />
  </li>
  <li class="avatar-list-item">
    <img
      src="avatar2.jpg"
      alt="User 2"
      class="avatar"
      title="User 2"
    />
  </li>
  <li class="avatar-list-item">
    <span class="avatar avatar--count" title="2 more">+2</span>
  </li>
</ul>
```

```css
.avatar-list {
  list-style: none;
  display: flex;
  margin: -0.5rem;
  padding: 0;
}

.avatar-list-item {
  margin: 0.5rem;
}

.avatar {
  display: block;
  width: 2.5rem;
  height: 2.5rem;
  border-radius: 50%;
  object-fit: cover;
  border: 2px solid var(--surface-primary);
  transition: transform 200ms, box-shadow 200ms;
}

.avatar:hover {
  transform: scale(1.1);
  box-shadow: 0 0 0 3px var(--primary-100);
}

.avatar--count {
  display: flex;
  align-items: center;
  justify-content: center;
  background: var(--primary-100);
  color: var(--primary-600);
  font-size: 0.875rem;
  font-weight: 600;
}
```

### 2.4 Grouped Lists with Section Headers

```html
<div class="list-group">
  <h3 class="list-group-title">Group 1</h3>
  <ul class="list">
    <li class="list-item">Item 1</li>
    <li class="list-item">Item 2</li>
  </ul>

  <h3 class="list-group-title">Group 2</h3>
  <ul class="list">
    <li class="list-item">Item 3</li>
    <li class="list-item">Item 4</li>
  </ul>
</div>
```

```css
.list-group-title {
  margin: 1.5rem 0 0.75rem 0;
  padding: 0 1rem;
  font-size: 0.875rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: var(--text-secondary);
}

.list-group-title:first-child {
  margin-top: 0;
}
```

### 2.5 Drag-and-Drop List Ordering

```html
<ul class="list list--sortable" role="listbox">
  <li
    class="list-item list-item--draggable"
    draggable="true"
    role="option"
  >
    <span class="drag-handle" aria-label="Drag to reorder">
      ⋮⋮
    </span>
    <span class="list-label">Item 1</span>
  </li>
  <li
    class="list-item list-item--draggable"
    draggable="true"
    role="option"
  >
    <span class="drag-handle" aria-label="Drag to reorder">
      ⋮⋮
    </span>
    <span class="list-label">Item 2</span>
  </li>
</ul>
```

```css
.drag-handle {
  cursor: grab;
  color: var(--text-secondary);
  flex-shrink: 0;
  padding: 0.5rem;
  transition: color 200ms;
}

.drag-handle:hover {
  color: var(--primary-500);
}

.drag-handle:active {
  cursor: grabbing;
}

/* Dragging state */
.list-item--dragging {
  opacity: 0.5;
  background-color: var(--primary-50);
}

/* Drop target */
.list-item--drop-target {
  border-top: 2px solid var(--primary-500);
  padding-top: calc(0.75rem - 2px);
}
```

### 2.6 Virtual Scrolling for Large Lists (React Example)

```jsx
import { useVirtualizer } from "@tanstack/react-virtual";
import { useRef } from "react";

export function VirtualList({ items }) {
  const parentRef = useRef(null);

  const virtualizer = useVirtualizer({
    count: items.length,
    getScrollElement: () => parentRef.current,
    estimateSize: () => 50, // Estimated height of each item
    overscan: 10, // Render 10 items outside viewport for smoothness
  });

  return (
    <ul
      ref={parentRef}
      className="list list--virtual"
      style={{
        height: "600px",
        overflow: "auto",
      }}
    >
      <li
        style={{
          height: `${virtualizer.getTotalSize()}px`,
          position: "relative",
        }}
      >
        {virtualizer.getVirtualItems().map((virtualItem) => (
          <li
            key={virtualItem.key}
            className="list-item"
            style={{
              transform: `translateY(${virtualItem.start}px)`,
              position: "absolute",
              top: 0,
              left: 0,
              width: "100%",
              height: `${virtualItem.size}px`,
            }}
          >
            {items[virtualItem.index].label}
          </li>
        ))}
      </li>
    </ul>
  );
}
```

### 2.7 Infinite Scroll Pattern

```jsx
import { useEffect, useRef, useCallback } from "react";

export function InfiniteScrollList({ onLoadMore }) {
  const observerTarget = useRef(null);

  useEffect(() => {
    const observer = new IntersectionObserver(
      (entries) => {
        if (entries[0].isIntersecting) {
          onLoadMore();
        }
      },
      { rootMargin: "100px" } // Start loading 100px before end
    );

    if (observerTarget.current) {
      observer.observe(observerTarget.current);
    }

    return () => observer.disconnect();
  }, [onLoadMore]);

  return (
    <>
      <ul className="list">
        {/* Items render here */}
      </ul>
      {/* Sentinel element to detect scroll end */}
      <div
        ref={observerTarget}
        className="list-sentinel"
        role="status"
        aria-live="polite"
        aria-label="Loading more items"
      >
        {/* Loading indicator */}
      </div>
    </>
  );
}
```

### 2.8 Pagination Patterns

```html
<nav class="pagination" aria-label="Pagination">
  <button class="pagination-btn" aria-label="Previous page">
    ← Prev
  </button>

  <ol class="pagination-list">
    <li>
      <button class="pagination-number" aria-label="Go to page 1">
        1
      </button>
    </li>
    <li>
      <button
        class="pagination-number pagination-number--active"
        aria-label="Current page, page 2"
        aria-current="page"
      >
        2
      </button>
    </li>
    <li>
      <button class="pagination-number" aria-label="Go to page 3">
        3
      </button>
    </li>
    <li aria-hidden="true">…</li>
    <li>
      <button class="pagination-number" aria-label="Go to page 10">
        10
      </button>
    </li>
  </ol>

  <button class="pagination-btn" aria-label="Next page">
    Next →
  </button>
</nav>
```

```css
.pagination {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  margin: 2rem 0;
}

.pagination-list {
  list-style: none;
  display: flex;
  gap: 0.25rem;
  padding: 0;
  margin: 0;
}

.pagination-number,
.pagination-btn {
  min-width: 2.5rem;
  height: 2.5rem;
  padding: 0 0.5rem;
  border: 1px solid var(--border-subtle);
  border-radius: 0.375rem;
  background: var(--surface-secondary);
  cursor: pointer;
  font-size: 0.875rem;
  font-weight: 500;
  transition: all 200ms;
}

.pagination-number:hover,
.pagination-btn:hover {
  border-color: var(--primary-300);
  background: var(--primary-50);
}

.pagination-number--active {
  background: var(--primary-500);
  color: white;
  border-color: var(--primary-500);
  cursor: default;
}

.pagination-number--active:hover {
  background: var(--primary-600);
  border-color: var(--primary-600);
}
```

---

## 3. Empty States & Error States

### 3.1 Empty State Structure

Empty states transition from blank screens to conversion opportunities. Best practice structure:

```html
<div class="empty-state">
  <!-- Visual: illustration, icon, or gif -->
  <div class="empty-state-visual">
    <svg class="empty-state-icon" aria-hidden="true">
      <!-- Icon content -->
    </svg>
  </div>

  <!-- Content -->
  <div class="empty-state-content">
    <!-- Heading: Clear, concise (max 5 words for error states) -->
    <h2 class="empty-state-heading">You haven't created any posts yet</h2>

    <!-- Description: Full context and guidance -->
    <p class="empty-state-description">
      Get started by creating your first post. Posts help you share
      updates with your audience.
    </p>

    <!-- CTA: Primary action to resolve state -->
    <button class="btn btn-primary">Create Your First Post</button>

    <!-- Secondary action: Alternative path -->
    <button class="btn btn-secondary">View Examples</button>
  </div>
</div>
```

### 3.2 Empty State CSS

```css
.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 3rem 2rem;
  text-align: center;
  min-height: 400px;
  background: var(--surface-secondary);
  border-radius: 0.5rem;
}

.empty-state-visual {
  margin-bottom: 2rem;
}

.empty-state-icon {
  width: 6rem;
  height: 6rem;
  color: var(--primary-200);
  opacity: 0.8;
}

.empty-state-heading {
  margin: 0 0 1rem 0;
  font-size: 1.25rem;
  font-weight: 700;
  color: var(--text-primary);
}

.empty-state-description {
  margin: 0 0 2rem 0;
  max-width: 400px;
  font-size: 1rem;
  color: var(--text-secondary);
  line-height: 1.5;
}

.empty-state > .btn + .btn {
  margin-left: 0.5rem;
}

@media (max-width: 640px) {
  .empty-state {
    padding: 2rem 1.5rem;
    min-height: 300px;
  }

  .empty-state-icon {
    width: 4rem;
    height: 4rem;
  }

  .empty-state-heading {
    font-size: 1.125rem;
  }
}
```

### 3.3 Empty State Types

#### First-Time User (Onboarding)
```html
<div class="empty-state empty-state--onboarding">
  <div class="empty-state-visual">
    <img src="onboarding.svg" alt="" />
  </div>
  <h2 class="empty-state-heading">Welcome to your dashboard</h2>
  <p class="empty-state-description">
    Let's get you set up. Start by connecting your first account.
  </p>
  <button class="btn btn-primary">Connect Account</button>
  <a href="#help" class="link">Learn more</a>
</div>
```

#### All Cleared (Completed Tasks)
```html
<div class="empty-state empty-state--success">
  <div class="empty-state-visual">
    ✓ <!-- Or celebratory icon -->
  </div>
  <h2 class="empty-state-heading">All caught up!</h2>
  <p class="empty-state-description">
    You've completed all your tasks. Great work!
  </p>
  <button class="btn btn-secondary">View completed tasks</button>
</div>
```

#### Search No Results
```html
<div class="empty-state empty-state--search">
  <div class="empty-state-visual">
    🔍
  </div>
  <h2 class="empty-state-heading">No results for "xyz"</h2>
  <p class="empty-state-description">
    Try different keywords or adjust your filters.
  </p>
  <button class="btn btn-secondary" onclick="clearSearch()">
    Clear search
  </button>
</div>
```

### 3.4 Error State Patterns

Error states must communicate:
1. **What went wrong** (specific error)
2. **Why it happened** (prevent future occurrences)
3. **What to do next** (actionable recovery path)

```html
<div class="error-state" role="alert">
  <div class="error-state-icon">
    ⚠️
  </div>
  <div class="error-state-content">
    <h2 class="error-state-heading">Payment Failed</h2>
    <p class="error-state-description">
      Your card was declined due to insufficient funds.
    </p>
    <p class="error-state-code">Error code: ERR_402</p>
    <div class="error-state-actions">
      <button class="btn btn-primary">Update Payment Method</button>
      <a href="#support" class="link">Contact support</a>
    </div>
  </div>
</div>
```

```css
.error-state {
  display: flex;
  gap: 1rem;
  padding: 1.5rem;
  background: var(--error-50);
  border: 1px solid var(--error-200);
  border-left: 4px solid var(--error-500);
  border-radius: 0.5rem;
}

.error-state-icon {
  flex-shrink: 0;
  width: 2rem;
  height: 2rem;
  font-size: 1.5rem;
  display: flex;
  align-items: center;
  justify-content: center;
}

.error-state-heading {
  margin: 0 0 0.5rem 0;
  font-size: 1rem;
  font-weight: 600;
  color: var(--error-600);
}

.error-state-description {
  margin: 0 0 0.5rem 0;
  color: var(--error-700);
  font-size: 0.95rem;
}

.error-state-code {
  margin: 0.5rem 0;
  padding: 0.75rem;
  background: rgba(0, 0, 0, 0.05);
  border-radius: 0.25rem;
  font-family: monospace;
  font-size: 0.85rem;
  color: var(--error-600);
}

.error-state-actions {
  display: flex;
  gap: 1rem;
  margin-top: 1rem;
}
```

### 3.5 HTTP Error States

```html
<!-- 404 Not Found -->
<div class="error-page error-page--404">
  <div class="error-page-content">
    <h1 class="error-page-code">404</h1>
    <h2 class="error-page-heading">Page Not Found</h2>
    <p class="error-page-description">
      The page you're looking for doesn't exist or has been moved.
    </p>
    <button class="btn btn-primary" onclick="history.back()">
      Go Back
    </button>
    <a href="/" class="link">Go to Home</a>
  </div>
</div>

<!-- 500 Server Error -->
<div class="error-page error-page--500">
  <div class="error-page-content">
    <h1 class="error-page-code">500</h1>
    <h2 class="error-page-heading">Something Went Wrong</h2>
    <p class="error-page-description">
      We're working to fix this. Please try again later.
    </p>
    <button class="btn btn-secondary" onclick="location.reload()">
      Refresh Page
    </button>
    <a href="/status" class="link">Check Status</a>
  </div>
</div>
```

---

## 4. Navigation Patterns

### 4.1 Tab Navigation

#### Pill Tabs (Inline)
```html
<div role="tablist" class="tabs tabs--pill">
  <button
    role="tab"
    class="tab tab--active"
    aria-selected="true"
    aria-controls="panel1"
  >
    Overview
  </button>
  <button
    role="tab"
    class="tab"
    aria-selected="false"
    aria-controls="panel2"
  >
    Analytics
  </button>
  <button
    role="tab"
    class="tab"
    aria-selected="false"
    aria-controls="panel3"
  >
    Settings
  </button>
</div>

<div id="panel1" role="tabpanel" tabindex="0" aria-labelledby="tab1">
  Overview content
</div>
<div id="panel2" role="tabpanel" tabindex="0" aria-labelledby="tab2" hidden>
  Analytics content
</div>
<div id="panel3" role="tabpanel" tabindex="0" aria-labelledby="tab3" hidden>
  Settings content
</div>
```

```css
.tabs {
  display: flex;
  gap: 0.5rem;
  border-bottom: 1px solid var(--border-subtle);
}

.tabs--pill {
  border-bottom: none;
  gap: 0.5rem;
  background: var(--surface-secondary);
  padding: 0.5rem;
  border-radius: 0.5rem;
}

.tab {
  padding: 0.75rem 1rem;
  border: none;
  background: transparent;
  cursor: pointer;
  font-weight: 500;
  color: var(--text-secondary);
  border-radius: 0.375rem;
  transition: all 200ms;
  position: relative;
}

.tabs--pill .tab {
  background: transparent;
}

.tabs--pill .tab--active {
  background: var(--surface-primary);
  color: var(--primary-600);
  box-shadow: var(--shadow-sm);
}

.tab:hover {
  color: var(--text-primary);
}

.tab--active {
  color: var(--primary-600);
}

.tabs:not(.tabs--pill) .tab--active::after {
  content: "";
  position: absolute;
  bottom: -1px;
  left: 0;
  right: 0;
  height: 2px;
  background: var(--primary-500);
}
```

### 4.2 Breadcrumbs

```html
<nav aria-label="Breadcrumb">
  <ol class="breadcrumb">
    <li class="breadcrumb-item">
      <a href="/">Home</a>
    </li>
    <li class="breadcrumb-item">
      <a href="/products">Products</a>
    </li>
    <li class="breadcrumb-item" aria-current="page">
      Laptop Pro
    </li>
  </ol>
</nav>
```

```css
.breadcrumb {
  list-style: none;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0;
  margin: 0;
  font-size: 0.875rem;
}

.breadcrumb-item {
  display: flex;
  align-items: center;
}

.breadcrumb-item::after {
  content: "/";
  margin: 0 0.5rem;
  color: var(--text-tertiary);
}

.breadcrumb-item:last-child::after {
  content: "";
}

.breadcrumb-item a {
  color: var(--primary-500);
  text-decoration: none;
  transition: color 200ms;
}

.breadcrumb-item a:hover {
  color: var(--primary-600);
  text-decoration: underline;
}

.breadcrumb-item[aria-current="page"] {
  color: var(--text-primary);
  font-weight: 500;
}
```

### 4.3 Progress Steps

```html
<div class="steps">
  <div class="step step--completed">
    <div class="step-indicator">
      <span class="step-number">✓</span>
    </div>
    <div class="step-label">Account Setup</div>
  </div>

  <div class="step-connector step--completed"></div>

  <div class="step step--active">
    <div class="step-indicator">
      <span class="step-number">2</span>
    </div>
    <div class="step-label">Verify Email</div>
  </div>

  <div class="step-connector"></div>

  <div class="step">
    <div class="step-indicator">
      <span class="step-number">3</span>
    </div>
    <div class="step-label">Done</div>
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

.step-indicator {
  width: 2.5rem;
  height: 2.5rem;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  background: var(--surface-tertiary);
  border: 2px solid var(--border-subtle);
  flex-shrink: 0;
  font-weight: 600;
  font-size: 0.875rem;
  color: var(--text-secondary);
  transition: all 200ms;
}

.step--active .step-indicator {
  background: var(--primary-500);
  border-color: var(--primary-500);
  color: white;
  box-shadow: 0 0 0 4px var(--primary-100);
}

.step--completed .step-indicator {
  background: var(--success-500);
  border-color: var(--success-500);
  color: white;
}

.step-label {
  font-size: 0.875rem;
  font-weight: 500;
  color: var(--text-secondary);
  margin-top: 0.5rem;
}

.step--active .step-label {
  color: var(--primary-600);
  font-weight: 600;
}

.step-connector {
  flex: 1;
  height: 2px;
  background: var(--border-subtle);
  margin: 0 -0.5rem;
}

.step-connector--completed {
  background: var(--success-500);
}
```

---

## 5. Content Density & Spacing

### 5.1 Spacing Scale System

```css
/* Standardized spacing (0.25rem increments) */
:root {
  --space-0: 0;
  --space-1: 0.25rem; /* 4px */
  --space-2: 0.5rem; /* 8px */
  --space-3: 0.75rem; /* 12px */
  --space-4: 1rem; /* 16px - default */
  --space-6: 1.5rem; /* 24px */
  --space-8: 2rem; /* 32px */
  --space-12: 3rem; /* 48px */
  --space-16: 4rem; /* 64px */
}

/* Avoid arbitrary spacing values - use scale */
/* Bad: padding: 23px */
/* Good: padding: var(--space-6) */
```

### 5.2 Content Density Variants

#### Comfortable (Default - Most common)
```css
.card--comfortable {
  padding: var(--space-6);
  gap: var(--space-4);
}

.card--comfortable .card-title {
  font-size: 1.125rem;
  margin-bottom: var(--space-2);
}

.card--comfortable .card-description {
  font-size: 1rem;
  line-height: 1.5;
  margin-bottom: var(--space-4);
}
```

#### Compact (For data-heavy interfaces)
```css
.card--compact {
  padding: var(--space-3);
  gap: var(--space-2);
}

.card--compact .card-title {
  font-size: 0.95rem;
  margin-bottom: var(--space-1);
}

.card--compact .card-description {
  font-size: 0.875rem;
  line-height: 1.4;
  margin-bottom: var(--space-2);
}
```

#### Spacious (For premium feel)
```css
.card--spacious {
  padding: var(--space-8);
  gap: var(--space-6);
}

.card--spacious .card-title {
  font-size: 1.375rem;
  margin-bottom: var(--space-4);
}

.card--spacious .card-description {
  font-size: 1.05rem;
  line-height: 1.6;
  margin-bottom: var(--space-6);
}
```

### 5.3 Dividers & Separators

```html
<!-- Solid divider -->
<div class="divider"></div>

<!-- Dashed divider -->
<div class="divider divider--dashed"></div>

<!-- With label -->
<div class="divider-with-label">
  <span class="divider-label">Or continue with</span>
</div>

<!-- Gradient divider -->
<div class="divider divider--gradient"></div>
```

```css
.divider {
  height: 1px;
  background: var(--border-subtle);
  margin: var(--space-6) 0;
}

.divider--dashed {
  border-top: 1px dashed var(--border-subtle);
  background: none;
  height: 0;
}

.divider-with-label {
  display: flex;
  align-items: center;
  margin: var(--space-6) 0;
  gap: var(--space-4);
}

.divider-with-label::before,
.divider-with-label::after {
  content: "";
  flex: 1;
  height: 1px;
  background: var(--border-subtle);
}

.divider-label {
  font-size: 0.875rem;
  color: var(--text-secondary);
  white-space: nowrap;
  padding: 0 var(--space-2);
}

.divider--gradient {
  background: linear-gradient(
    to right,
    transparent,
    var(--border-subtle),
    transparent
  );
}
```

### 5.4 Visual Rhythm - Line Height & Letter Spacing

```css
/* Display headings - more spacious */
.text-display {
  font-size: 3rem;
  line-height: 1.2;
  letter-spacing: -0.02em;
}

/* Body text - comfortable reading */
.text-body {
  font-size: 1rem;
  line-height: 1.6;
  letter-spacing: 0;
}

/* Small text - tighter spacing */
.text-small {
  font-size: 0.875rem;
  line-height: 1.4;
  letter-spacing: 0.01em;
}
```

---

## 6. Status Indicators & Badges

### 6.1 Notification Badges

```html
<!-- Numeric badge -->
<span class="badge badge--numeric">5</span>

<!-- Dot badge (unread indicator) -->
<span class="badge badge--dot"></span>

<!-- Status badge -->
<span class="badge badge--success">Active</span>
<span class="badge badge--warning">Pending</span>
<span class="badge badge--error">Failed</span>
```

```css
.badge {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-width: 1.5rem;
  height: 1.5rem;
  padding: 0 0.5rem;
  border-radius: 999px;
  background: var(--error-500);
  color: white;
  font-size: 0.75rem;
  font-weight: 700;
  white-space: nowrap;
}

.badge--dot {
  width: 0.5rem;
  height: 0.5rem;
  min-width: 0.5rem;
  padding: 0;
  background: var(--error-500);
}

.badge--success {
  background: var(--success-500);
}

.badge--warning {
  background: var(--warning-500);
  color: var(--warning-900);
}

.badge--error {
  background: var(--error-500);
}

/* Positioned on element */
.notification-icon {
  position: relative;
}

.notification-icon .badge {
  position: absolute;
  top: -0.25rem;
  right: -0.25rem;
}
```

### 6.2 Status Indicators (Online, Offline, Busy)

```html
<div class="status-indicator status-indicator--online"></div>
<div class="status-indicator status-indicator--offline"></div>
<div class="status-indicator status-indicator--busy"></div>
<div class="status-indicator status-indicator--away"></div>
```

```css
.status-indicator {
  display: inline-block;
  width: 0.75rem;
  height: 0.75rem;
  border-radius: 50%;
  background: var(--success-500);
  border: 2px solid white;
  box-shadow: 0 0 0 1px var(--border-subtle);
}

.status-indicator--offline {
  background: var(--text-tertiary);
}

.status-indicator--busy {
  background: var(--error-500);
}

.status-indicator--away {
  background: var(--warning-500);
}

/* Pulsing animation for online status */
.status-indicator--online::after {
  content: "";
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 100%;
  height: 100%;
  border-radius: 50%;
  background: var(--success-500);
  opacity: 0.75;
  animation: pulse 2s ease-in-out infinite;
}

@keyframes pulse {
  0%,
  100% {
    transform: translate(-50%, -50%) scale(1);
    opacity: 0.75;
  }
  50% {
    transform: translate(-50%, -50%) scale(1.3);
    opacity: 0.25;
  }
}
```

### 6.3 Contextual Badges

```html
<!-- Tag/label with icon -->
<span class="tag tag--primary">
  <svg class="tag-icon" aria-hidden="true"></svg>
  New Feature
</span>

<!-- Product status -->
<span class="status-badge status-badge--sale">Sale</span>
<span class="status-badge status-badge--new">New</span>
<span class="status-badge status-badge--featured">Featured</span>
```

```css
.tag {
  display: inline-flex;
  align-items: center;
  gap: 0.375rem;
  padding: 0.375rem 0.75rem;
  border-radius: 999px;
  font-size: 0.8rem;
  font-weight: 600;
  background: var(--primary-100);
  color: var(--primary-600);
  white-space: nowrap;
}

.tag-icon {
  width: 0.875rem;
  height: 0.875rem;
}

.status-badge {
  display: inline-block;
  padding: 0.5rem 0.75rem;
  border-radius: 0.25rem;
  font-size: 0.7rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  background: var(--error-500);
  color: white;
}

.status-badge--sale {
  background: var(--error-500);
}

.status-badge--new {
  background: var(--primary-500);
}

.status-badge--featured {
  background: linear-gradient(135deg, var(--primary-500), var(--primary-400));
}
```

---

## 7. Information Architecture & Visual Hierarchy

### 7.1 F-Pattern Layout (Text-Heavy)

Optimal for content-rich pages. Users scan in "F" shape: horizontal at top, vertical down left side.

```html
<article class="f-pattern">
  <!-- Header: Eye-catching visual or headline (horizontal scan) -->
  <header class="f-header">
    <h1>Main Headline (Large, clear)</h1>
  </header>

  <!-- First subheading (horizontal pause) -->
  <h2 class="f-subheading">Section 1: Critical Information</h2>
  <p class="f-body">Content for first section...</p>

  <!-- Vertical scan begins (left side) -->
  <h2 class="f-subheading">Section 2: Important Details</h2>
  <p class="f-body">Content for second section...</p>

  <h2 class="f-subheading">Section 3: Supporting Information</h2>
  <p class="f-body">Content for third section...</p>
</article>
```

```css
.f-pattern {
  max-width: 800px;
}

.f-header {
  margin-bottom: 3rem;
  padding-bottom: 2rem;
  border-bottom: 2px solid var(--border-subtle);
}

.f-header h1 {
  font-size: 2.5rem;
  line-height: 1.2;
  margin: 0;
}

.f-subheading {
  font-size: 1.5rem;
  font-weight: 700;
  margin: 2rem 0 1rem 0;
  color: var(--primary-600);
}

.f-body {
  font-size: 1rem;
  line-height: 1.8;
  color: var(--text-primary);
  margin: 0 0 1.5rem 0;
}
```

### 7.2 Z-Pattern Layout (Visual-Heavy)

Optimal for visual-first pages. Users scan in "Z" shape: top horizontal → diagonal → bottom horizontal.

```html
<section class="z-pattern">
  <!-- Top left: Main hook -->
  <div class="z-top-left">
    <h1>Compelling Headline</h1>
  </div>

  <!-- Top right: Supporting visual -->
  <div class="z-top-right">
    <img src="feature.jpg" alt="Feature image" />
  </div>

  <!-- Diagonal: Features/benefits -->
  <div class="z-diagonal">
    <div class="z-feature">
      <h3>Feature 1</h3>
      <p>Description</p>
    </div>
    <div class="z-feature">
      <h3>Feature 2</h3>
      <p>Description</p>
    </div>
  </div>

  <!-- Bottom right: CTA -->
  <div class="z-bottom-right">
    <button class="btn btn-primary">Get Started</button>
  </div>
</section>
```

```css
.z-pattern {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 3rem;
  align-items: center;
}

.z-top-left {
  grid-column: 1 / 2;
  grid-row: 1 / 2;
}

.z-top-right {
  grid-column: 2 / 3;
  grid-row: 1 / 2;
}

.z-diagonal {
  grid-column: 1 / -1;
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 2rem;
}

.z-bottom-right {
  grid-column: 2 / 3;
  text-align: right;
}

@media (max-width: 768px) {
  .z-pattern {
    grid-template-columns: 1fr;
  }

  .z-top-right {
    grid-column: 1 / 2;
  }

  .z-bottom-right {
    grid-column: 1 / 2;
    text-align: left;
  }
}
```

### 7.3 Size & Weight Hierarchy

```css
/* Display sizes: 3rem, 2.5rem (announcements, hero headlines) */
.text-display-lg {
  font-size: 3rem;
  font-weight: 700;
  letter-spacing: -0.02em;
  line-height: 1.2;
}

.text-display-md {
  font-size: 2.5rem;
  font-weight: 700;
  letter-spacing: -0.01em;
  line-height: 1.25;
}

/* Heading sizes: 1.875rem - 1.25rem */
.text-heading-1 {
  font-size: 1.875rem;
  font-weight: 700;
  line-height: 1.3;
}

.text-heading-2 {
  font-size: 1.5rem;
  font-weight: 700;
  line-height: 1.4;
}

.text-heading-3 {
  font-size: 1.25rem;
  font-weight: 600;
  line-height: 1.4;
}

/* Body: 1rem (default) */
.text-body {
  font-size: 1rem;
  font-weight: 400;
  line-height: 1.6;
}

/* Small: 0.875rem */
.text-small {
  font-size: 0.875rem;
  font-weight: 400;
  line-height: 1.5;
}

/* Tiny: 0.75rem */
.text-tiny {
  font-size: 0.75rem;
  font-weight: 500;
  line-height: 1.4;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}
```

### 7.4 Contrast & Emphasis

```css
/* High contrast: Primary action */
.emphasis--primary {
  background: var(--primary-500);
  color: white;
  font-weight: 700;
}

/* Medium contrast: Secondary action */
.emphasis--secondary {
  background: var(--surface-secondary);
  color: var(--text-primary);
  font-weight: 600;
}

/* Low contrast: Tertiary action */
.emphasis--tertiary {
  background: transparent;
  color: var(--text-secondary);
  font-weight: 500;
}

/* Accessibility: Ensure sufficient contrast */
/* WCAG AA: 4.5:1 minimum for normal text, 3:1 for large text */
/* Use color contrast checkers: WebAIM, Contrast Ratio */
```

### 7.5 Proximity & Grouping

```css
/* Related items close together */
.group {
  display: flex;
  flex-direction: column;
  gap: 0.5rem; /* Close grouping */
}

/* Separate groups with more space */
.group + .group {
  margin-top: 2rem;
}

/* Visual separator for distinct sections */
.section {
  padding: 2rem;
  border: 1px solid var(--border-subtle);
  border-radius: 0.5rem;
}

.section + .section {
  margin-top: 2rem;
}
```

---

## 8. Modern Layout Techniques (2025)

### 8.1 CSS Grid Auto-Responsive Pattern

This single CSS rule replaces multiple media queries:

```css
.grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(min_width, 1fr));
  gap: 1.5rem;
}

/* Example: Cards never smaller than 280px */
.card-grid {
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
}

/* Responsive without media queries:
   - 6+ items on large screens (6 × 280px = 1680px+)
   - 4 items on 1366px+ screens
   - 3 items on 1024px+ screens
   - 2 items on 768px+ screens
   - 1 item on mobile */
```

### 8.2 Container Queries (2025 Standard)

Container queries enable component-level responsiveness:

```css
/* Parent: Define container context */
.sidebar {
  container-type: inline-size;
}

/* Child: Respond to parent container width, not viewport */
.card {
  display: flex;
  flex-direction: column;
}

/* Narrow container: Stack layout */
@container (max-width: 300px) {
  .card {
    flex-direction: column;
    gap: 0.5rem;
  }
}

/* Medium container: Side-by-side */
@container (min-width: 300px) and (max-width: 500px) {
  .card {
    display: grid;
    grid-template-columns: 40% 1fr;
    gap: 1rem;
  }
}

/* Large container: Full layout */
@container (min-width: 500px) {
  .card {
    display: grid;
    grid-template-columns: 100px 1fr 150px;
    gap: 1.5rem;
  }
}
```

**Key Advantage:** Same `.card` component reuses different layouts in sidebar vs. main content vs. modal.

### 8.3 Aspect Ratio Boxes

```css
/* 16:9 aspect ratio (video) */
.aspect-video {
  aspect-ratio: 16 / 9;
  width: 100%;
}

/* 1:1 aspect ratio (square) */
.aspect-square {
  aspect-ratio: 1 / 1;
}

/* 4:3 aspect ratio (photo) */
.aspect-photo {
  aspect-ratio: 4 / 3;
}

/* Usage with images */
.aspect-video img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}
```

### 8.4 Sticky Positioning Patterns

```css
/* Sticky header that stays visible on scroll */
.sticky-header {
  position: sticky;
  top: 0;
  z-index: 10;
  background: var(--surface-primary);
  border-bottom: 1px solid var(--border-subtle);
  padding: 1rem;
}

/* Sticky sidebar (requires parent with overflow) */
.sidebar {
  position: sticky;
  top: 1rem;
  max-height: calc(100vh - 2rem);
  overflow-y: auto;
}

/* Sticky table headers */
.table thead {
  position: sticky;
  top: 0;
  background: var(--surface-secondary);
  z-index: 1;
}
```

### 8.5 Overflow Handling Patterns

#### Text Truncation (Single Line)
```css
.truncate {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
```

#### Text Truncation (Multi-line)
```css
.truncate-lines-3 {
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 3;
  overflow: hidden;
  text-overflow: ellipsis;
}
```

#### Scroll Container (Horizontal)
```css
.scroll-container {
  display: flex;
  gap: 1rem;
  overflow-x: auto;
  overflow-y: hidden;
  scroll-behavior: smooth;
  /* Hide scrollbar but keep functionality */
  scrollbar-width: none;
}

.scroll-container::-webkit-scrollbar {
  display: none;
}
```

#### Expandable Content
```html
<details class="expandable">
  <summary class="expandable-trigger">
    Click to expand
  </summary>
  <div class="expandable-content">
    Hidden content goes here...
  </div>
</details>
```

```css
.expandable {
  border: 1px solid var(--border-subtle);
  border-radius: 0.5rem;
  overflow: hidden;
}

.expandable-trigger {
  cursor: pointer;
  padding: 1rem;
  background: var(--surface-secondary);
  font-weight: 600;
  user-select: none;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.expandable-trigger::after {
  content: "▼";
  transition: transform 300ms;
}

.expandable[open] .expandable-trigger::after {
  transform: rotate(180deg);
}

.expandable-content {
  padding: 1rem;
  background: var(--surface-primary);
}
```

---

## 9. Accessibility Patterns

### 9.1 Keyboard Navigation

All interactive elements must be keyboard accessible:

```html
<!-- Native interactive elements (auto-accessible) -->
<button class="btn">Click me</button>
<a href="#" class="link">Link</a>
<input type="text" placeholder="Input" />

<!-- Custom interactive elements need ARIA & tabindex -->
<div
  role="button"
  tabindex="0"
  aria-pressed="false"
  onclick="toggleState()"
  onkeydown="if(event.key==='Enter'||event.key===' ') toggleState()"
  class="custom-btn"
>
  Custom Button
</div>
```

### 9.2 ARIA Labels & Descriptions

```html
<!-- Button with icon needs label -->
<button aria-label="Close dialog" onclick="closeDialog()">✕</button>

<!-- Form fields need labels -->
<label for="email">Email Address</label>
<input id="email" type="email" />

<!-- Lists with context -->
<ul role="listbox" aria-label="Select an option">
  <li role="option" aria-selected="false">Option 1</li>
  <li role="option" aria-selected="true">Option 2</li>
</ul>

<!-- Modals need ARIA -->
<div role="dialog" aria-modal="true" aria-labelledby="dialog-title">
  <h2 id="dialog-title">Confirm Action</h2>
  <p id="dialog-description">Are you sure?</p>
</div>

<!-- Live regions for dynamic updates -->
<div aria-live="polite" aria-atomic="true">
  <!-- Updated content announces to screen readers -->
</div>

<!-- Skip to main content link -->
<a href="#main-content" class="skip-link">Skip to main content</a>
```

### 9.3 Focus Management

```css
/* Visible focus indicator */
.btn:focus-visible {
  outline: 2px solid var(--primary-500);
  outline-offset: 2px;
}

/* Custom focus ring for buttons -->
.btn:focus-within {
  box-shadow: 0 0 0 3px var(--primary-100), 0 0 0 5px var(--primary-500);
}

/* Remove default outline only when custom focus is applied */
.btn:focus:not(:focus-visible) {
  outline: none;
}

/* High contrast mode support */
@media (prefers-contrast: more) {
  .btn:focus-visible {
    outline-width: 3px;
  }
}
```

### 9.4 Reduced Motion Support

```css
/* Respect user's motion preferences */
@media (prefers-reduced-motion: reduce) {
  *,
  *::before,
  *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}

/* Safe animations that degrade gracefully */
.fade-in {
  animation: fadeIn 300ms ease-out;
}

@media (prefers-reduced-motion: reduce) {
  .fade-in {
    animation: none;
    opacity: 1;
  }
}
```

---

## 10. Dark Mode Considerations

### 10.1 CSS Custom Properties for Dark Mode

```css
:root {
  --surface-primary: #ffffff;
  --surface-secondary: #f5f5f5;
  --text-primary: #1a1a1a;
  --text-secondary: #666666;
  --border-subtle: #e0e0e0;
}

[data-theme="dark"] {
  --surface-primary: #1a1a1a;
  --surface-secondary: #2d2d2d;
  --text-primary: #ffffff;
  --text-secondary: #b0b0b0;
  --border-subtle: #404040;
}

/* Or use prefers-color-scheme media query */
@media (prefers-color-scheme: dark) {
  :root {
    --surface-primary: #1a1a1a;
    --surface-secondary: #2d2d2d;
    --text-primary: #ffffff;
    --text-secondary: #b0b0b0;
  }
}
```

### 10.2 Dark Mode Best Practices

```css
/* Avoid pure white (#ffffff) in dark mode - use off-white */
.surface-primary-dark {
  background: #1a1a1a; /* Not pure #000000 */
}

/* Increase contrast in dark mode */
[data-theme="dark"] {
  --text-secondary: #a0a0a0; /* Lighter than light mode */
}

/* Reduce opacity-based layers in dark mode */
[data-theme="dark"] .backdrop {
  background: rgba(0, 0, 0, 0.8); /* Darker backdrop */
}

/* Images may need adjustment for dark mode */
[data-theme="dark"] img {
  filter: brightness(0.95);
}

/* Code blocks with dark mode support */
.code-block {
  background: var(--surface-secondary);
  color: var(--text-primary);
  border: 1px solid var(--border-subtle);
}
```

---

## 11. Performance Best Practices

### 11.1 Layout Shift Prevention

Prevent CLS (Cumulative Layout Shift) by reserving space:

```css
/* Reserve space for ads, images, embeds */
.ad-container {
  min-height: 250px; /* Standard ad height */
  background: var(--surface-secondary);
}

.image-container {
  aspect-ratio: 16 / 9;
  background: var(--surface-secondary);
  overflow: hidden;
}

/* Reserve space for loading states */
.skeleton {
  background: linear-gradient(
    90deg,
    var(--surface-secondary) 0%,
    var(--surface-tertiary) 50%,
    var(--surface-secondary) 100%
  );
  background-size: 200% 100%;
  animation: loading 1.5s infinite;
}

@keyframes loading {
  0% {
    background-position: 200% 0;
  }
  100% {
    background-position: -200% 0;
  }
}
```

### 11.2 CSS Grid Performance

```css
/* ✅ Efficient: Auto-fit reduces reflow */
.grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 1.5rem;
}

/* ❌ Inefficient: Auto-fill recalculates on resize */
.grid-bad {
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
}
```

### 11.3 Container Query Performance

Container queries are more efficient than multiple media queries:

```css
/* One container query replaces multiple viewport media queries */
@container (min-width: 500px) {
  .card {
    /* Styles apply regardless of viewport size */
  }
}

/* Avoids: Querying viewport dimensions on every resize */
```

### 11.4 Virtual Scrolling for Lists

Large lists should implement virtualization to avoid DOM bloat:

```jsx
// Use libraries like react-window, react-virtual, or TanStack Virtual
import { useVirtualizer } from "@tanstack/react-virtual";

export function OptimizedList({ items }) {
  const virtualizer = useVirtualizer({
    count: items.length,
    estimateSize: () => 50,
    overscan: 10, // Render 10 items outside viewport
  });

  return (
    <div style={{ height: "600px", overflow: "auto" }}>
      {/* Only visible items + buffer rendered to DOM */}
    </div>
  );
}
```

---

## 12. Design System Examples & Resources

### Top Design Systems Implementing These Patterns

1. **Stripe (stripe.com/design)**
   - Container query-based card layouts
   - Premium spacing system
   - Extensive documentation

2. **Linear (linear.app)**
   - Minimal card designs with hover states
   - Keyboard shortcuts & accessibility focus
   - Dark mode as first-class feature

3. **Vercel (vercel.com)**
   - Grid-based layouts
   - Gradient utilization
   - Performance-focused patterns

4. **Shopify Polaris (polaris.shopify.com)**
   - Comprehensive card system
   - Empty/loading/error states
   - Accessibility audit tools

5. **GitHub Primer (primer.style)**
   - Blankslate empty state component
   - Octicon integration
   - Focus ring patterns

6. **GitLab Pajamas (design.gitlab.com)**
   - Empty state guidelines
   - Typography hierarchy
   - Accessibility checklist

---

## Key Takeaways for 2025

1. **Container Queries > Media Queries** - Components now respond to their container, not viewport
2. **CSS Grid auto-fit** - Single rule replaces multiple breakpoints
3. **Empty States are CRO** - Turn blank screens into engagement opportunities
4. **Virtual Scrolling** - Mandatory for large lists (1000+ items)
5. **Dark Mode First** - Design for dark mode, adapt for light
6. **Accessibility by Default** - ARIA labels, keyboard nav, focus management
7. **Spacing Scale** - Never use arbitrary values; maintain design system consistency
8. **Cards Dominate** - From dashboards to feeds, cards chunk content effectively
9. **Motion Respectful** - Always check `prefers-reduced-motion`
10. **Type Hierarchy** - Use display/heading/body/small/tiny system consistently

---

## Research Sources

- web.dev - Container Query Card Patterns
- DEV Community - 2025 CSS Grid vs Flexbox vs Container Queries
- UXPin - Empty State UX Best Practices
- Nielsen Norman Group - Visual Hierarchy & Information Architecture
- Carbon Design System - Empty States Pattern
- Interaction Design Foundation - Visual Hierarchy & Infinite Scrolling
- Medium - Virtual Lists & Infinite Scroll (2025 articles)

**Report Generated:** October 24, 2025
**Research Focus:** Production-ready patterns with code examples and accessibility compliance
