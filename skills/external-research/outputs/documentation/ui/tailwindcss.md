# Tailwind CSS

Tailwind CSS is a utility-first CSS framework for rapidly building custom user interfaces.

## Core Concepts

### Utility-First

Instead of writing custom CSS to style your components, you use pre-existing classes directly in your HTML. This allows you to build complex components from a constrained set of primitive utilities.

**Advantages:**

*   **Faster UI development:** No need to switch between HTML and CSS files.
*   **Safer changes:** Changes are local to the component you are working on.
*   **Easier maintenance:** No need to worry about breaking changes in other parts of the application.
*   **Smaller CSS bundles:** CSS doesn't grow with every new feature.

### Hover, Focus, and Other States

To style an element on hover, focus, or other states, you can prefix a utility with the state you want to target. For example, to change the background color on hover, you can use `hover:bg-sky-700`.

```html
<button class="bg-sky-500 hover:bg-sky-700 ...">Save changes</button>
```

### Responsive Design

You can style elements at different breakpoints by prefixing a utility with the breakpoint name. For example, to apply a different grid layout on small screens, you can use `sm:grid-cols-3`.

```html
<div class="grid grid-cols-2 sm:grid-cols-3">...</div>
```

### Dark Mode

To style an element in dark mode, you can use the `dark:` prefix. For example, to change the background color in dark mode, you can use `dark:bg-gray-800`.

```html
<div class="bg-white dark:bg-gray-800 ...">...</div>
```

### Arbitrary Values

When you need to use a one-off value that is not part of your theme, you can use square bracket notation to generate a class with a custom value on the fly.

```html
<div class="top-[117px]">...</div>
```

## Layout

### Display

Utilities for controlling the display box type of an element.

*   `block`
*   `inline-block`
*   `inline`
*   `flex`
*   `inline-flex`
*   `grid`
*   `inline-grid`
*   `hidden` (sets `display: none`)

### Position

Utilities for controlling how an element is positioned in the DOM.

*   `static`
*   `relative`
*   `absolute`
*   `fixed`
*   `sticky`

### Top / Right / Bottom / Left

Utilities for controlling the placement of positioned elements.

*   `top-{amount}`
*   `right-{amount}`
*   `bottom-{amount}`
*   `left-{amount}`
*   `inset-{amount}` (sets all four sides)
*   `inset-x-{amount}` (sets left and right)
*   `inset-y-{amount}` (sets top and bottom)

## Flexbox & Grid

### Flex Direction

Utilities for controlling the direction of flex items.

*   `flex-row`
*   `flex-row-reverse`
*   `flex-col`
*   `flex-col-reverse`

### Justify Content

Utilities for controlling how flex and grid items are positioned along a container's main axis.

*   `justify-start`
*   `justify-end`
*   `justify-center`
*   `justify-between`
*   `justify-around`
*   `justify-evenly`

### Align Items

Utilities for controlling how flex and grid items are positioned along a container's cross axis.

*   `items-start`
*   `items-end`
*   `items-center`
*   `items-baseline`
*   `items-stretch`

### Gap

Utilities for controlling the gap between grid and flexbox items.

*   `gap-{size}`
*   `gap-x-{size}`
*   `gap-y-{size}`

### Grid Template Columns

Utilities for specifying the columns in a grid layout.

*   `grid-cols-{number}`
*   `grid-cols-none`
*   `grid-cols-subgrid`

### Grid Template Rows

Utilities for specifying the rows in a grid layout.

*   `grid-rows-{number}`
*   `grid-rows-none`
*   `grid-rows-subgrid`

## Spacing

### Padding

Utilities for controlling an element's padding.

*   `p-{size}`
*   `px-{size}`
*   `py-{size}`
*   `pt-{size}`
*   `pr-{size}`
*   `pb-{size}`
*   `pl-{size}`

### Margin

Utilities for controlling an element's margin.

*   `m-{size}`
*   `mx-{size}`
*   `my-{size}`
*   `mt-{size}`
*   `mr-{size}`
*   `mb-{size}`
*   `ml-{size}`

## Sizing

### Width

Utilities for setting the width of an element.

*   `w-{size}`
*   `w-full`
*   `w-screen`
*   `w-min`
*   `w-max`
*   `w-fit`

### Height

Utilities for setting the height of an element.

*   `h-{size}`
*   `h-full`
*   `h-screen`
*   `h-min`
*   `h-max`
*   `h-fit`

## Typography

### Font Size

Utilities for controlling the font size of an element.

*   `text-xs`
*   `text-sm`
*   `text-base`
*   `text-lg`
*   `text-xl`
*   `text-2xl` ... `text-9xl`

### Font Weight

Utilities for controlling the font weight of an element.

*   `font-thin`
*   `font-extralight`
*   `font-light`
*   `font-normal`
*   `font-medium`
*   `font-semibold`
*   `font-bold`
*   `font-extrabold`
*   `font-black`

### Text Align

Utilities for controlling the alignment of text.

*   `text-left`
*   `text-center`
*   `text-right`
*   `text-justify`
*   `text-start`
*   `text-end`

### Text Color

Utilities for controlling the text color of an element.

*   `text-{color}-{shade}` (e.g., `text-blue-600`)
*   `text-black`
*   `text-white`
*   `text-transparent`
*   `text-current`

## Backgrounds

### Background Color

Utilities for controlling an element's background color.

*   `bg-{color}-{shade}` (e.g., `bg-blue-600`)
*   `bg-black`
*   `bg-white`
*   `bg-transparent`
*   `bg-current`

### Background Image

Utilities for controlling an element's background image.

*   `bg-none`
*   `bg-gradient-to-{direction}`
*   `from-{color}`
*   `via-{color}`
*   `to-{color}`

## Borders

### Border Width

Utilities for controlling the width of an element's borders.

*   `border`
*   `border-{width}`
*   `border-x-{width}`
*   `border-y-{width}`
*   `border-t-{width}`
*   `border-r-{width}`
*   `border-b-{width}`
*   `border-l-{width}`

### Border Color

Utilities for controlling the color of an element's borders.

*   `border-{color}-{shade}` (e.g., `border-blue-600`)
*   `border-black`
*   `border-white`
*   `border-transparent`
*   `border-current`

### Border Radius

Utilities for controlling the border radius of an element.

*   `rounded`
*   `rounded-{size}` (e.g., `rounded-lg`)
*   `rounded-t-{size}`
*   `rounded-r-{size}`
*   `rounded-b-{size}`
*   `rounded-l-{size}`
*   `rounded-tl-{size}`
*   `rounded-tr-{size}`
*   `rounded-br-{size}`
*   `rounded-bl-{size}`
*   `rounded-full`

## Effects

### Box Shadow

Utilities for controlling the box shadow of an element.

*   `shadow-{size}` (e.g., `shadow-lg`)
*   `shadow-inner`
*   `shadow-none`

### Opacity

Utilities for controlling the opacity of an element.

*   `opacity-{amount}` (e.g., `opacity-50`)

## Transitions & Animation

### Transition Property

Utilities for controlling which CSS properties transition.

*   `transition`
*   `transition-all`
*   `transition-colors`
*   `transition-opacity`
*   `transition-shadow`
*   `transition-transform`

### Transition Duration

Utilities for controlling the duration of CSS transitions.

*   `duration-{amount}`

### Transition Timing Function

Utilities for controlling the easing of CSS transitions.

*   `ease-linear`
*   `ease-in`
*   `ease-out`
*   `ease-in-out`

### Animation

Utilities for animating elements with CSS animations.

*   `animate-spin`
*   `animate-ping`
*   `animate-pulse`
*   `animate-bounce`
