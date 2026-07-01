# Web guide

KompKit Core provides small, framework-agnostic utilities for web applications written in TypeScript.

Status: `v0.4.1-alpha.0`.

## Installation

```bash
npm i kompkit-core
```

## Imports

ESM:

```ts
import {
  debounce,
  isEmail,
  formatCurrency,
  clamp,
  throttle,
} from "kompkit-core";
```

CommonJS:

```js
const {
  debounce,
  isEmail,
  formatCurrency,
  clamp,
  throttle,
} = require("kompkit-core");
```

## Usage examples

### debounce

```ts
import { debounce } from "kompkit-core";

const onType = debounce((value: string) => {
  console.log("Search:", value);
}, 300);

onType("k");
onType("ko");
onType("kompkit"); // only this call will execute after ~300ms
```

### isEmail

```ts
import { isEmail } from "kompkit-core";

isEmail("test@example.com"); // true
isEmail("invalid@"); // false
```

### formatCurrency

```ts
import { formatCurrency } from "kompkit-core";

formatCurrency(1234.56); // "$1,234.56" (en-US / USD default)
formatCurrency(1234.56, "EUR", "de-DE"); // "1.234,56 €"
```

### clamp

```ts
import { clamp } from "kompkit-core";

clamp(5, 0, 10); // 5  — within range, returned as-is
clamp(-3, 0, 10); // 0  — below min, clamped to min
clamp(15, 0, 10); // 10 — above max, clamped to max
```

Useful for bounding any user-controlled numeric value:

```ts
const opacity = clamp(userInput, 0, 1);
const page = clamp(requestedPage, 1, totalPages);
const volume = clamp(rawVolume, 0, 100);
```

### throttle

```ts
import { throttle } from "kompkit-core";

const onScroll = throttle((e: Event) => {
  console.log("scrollY:", window.scrollY);
}, 200);

window.addEventListener("scroll", onScroll);

// Always clean up to avoid stale handlers:
onScroll.cancel();
window.removeEventListener("scroll", onScroll);
```

Unlike `debounce` (which delays until calls stop), `throttle` fires immediately then enforces a cooldown — ideal for scroll, resize, and pointer events where you want immediate feedback but not every frame.

## React snippets

### debounced search input

```tsx
import { useEffect, useRef } from "react";
import { debounce } from "kompkit-core";

export function SearchBox() {
  const onSearch = useRef(
    debounce((v: string) => console.log("search", v), 300),
  );

  useEffect(() => () => onSearch.current.cancel(), []);

  return (
    <input
      onChange={(e) => onSearch.current(e.target.value)}
      placeholder="Search"
    />
  );
}
```

### throttled scroll tracker

```tsx
import { useEffect, useRef } from "react";
import { throttle } from "kompkit-core";

export function ScrollTracker() {
  const onScroll = useRef(
    throttle(() => {
      console.log("scrollY:", window.scrollY);
    }, 200),
  );

  useEffect(() => {
    window.addEventListener("scroll", onScroll.current);
    return () => {
      onScroll.current.cancel();
      window.removeEventListener("scroll", onScroll.current);
    };
  }, []);

  return <div>Scroll the page</div>;
}
```

### bounded slider with clamp

```tsx
import { useState } from "react";
import { clamp } from "kompkit-core";

export function VolumeSlider() {
  const [volume, setVolume] = useState(50);

  return (
    <input
      type="range"
      value={volume}
      min={0}
      max={100}
      onChange={(e) => setVolume(clamp(Number(e.target.value), 0, 100))}
    />
  );
}
```

## Vue snippets

### debounced search

```vue
<script setup lang="ts">
import { ref, onUnmounted } from "vue";
import { debounce } from "kompkit-core";

const value = ref("");
const run = debounce((v: string) => console.log("search", v), 300);
onUnmounted(() => run.cancel());
</script>

<template>
  <input v-model="value" @input="run(value)" placeholder="Search" />
</template>
```

### throttled scroll handler

```vue
<script setup lang="ts">
import { onMounted, onUnmounted } from "vue";
import { throttle } from "kompkit-core";

const onScroll = throttle(() => {
  console.log("scrollY:", window.scrollY);
}, 200);

onMounted(() => window.addEventListener("scroll", onScroll));
onUnmounted(() => {
  onScroll.cancel();
  window.removeEventListener("scroll", onScroll);
});
</script>

<template>
  <div>Scroll the page</div>
</template>
```

## Notes

- Framework-agnostic: works with React, Vue, or any TS/JS app.
- Module formats: ESM and CJS are provided.
- Zero runtime dependencies.
- Types included (`.d.ts`).
