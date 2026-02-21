# Web guide

KompKit Core provides small, framework-agnostic utilities for web applications written in TypeScript.

Status: `V0.3.1-alpha`.

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
formatCurrency(1234.56, "EUR", "es-ES"); // "1.234,56 €"
```

### clamp

```ts
import { clamp } from "kompkit-core";

clamp(5, 0, 10); // 5
clamp(-3, 0, 10); // 0
clamp(15, 0, 10); // 10
```

### throttle

```ts
import { throttle } from "kompkit-core";

const onScroll = throttle(() => {
  console.log("scroll");
}, 200);

window.addEventListener("scroll", onScroll);
onScroll.cancel(); // reset state (e.g. on unmount)
```

## React snippet

```tsx
import { useState } from "react";
import { debounce } from "kompkit-core";

export function SearchBox() {
  const [value, setValue] = useState("");
  const run = debounce((v: string) => console.log("search", v), 250);
  return (
    <input
      value={value}
      onChange={(e) => {
        setValue(e.target.value);
        run(e.target.value);
      }}
      placeholder="Search"
    />
  );
}
```

## Vue snippet

```vue
<script setup lang="ts">
import { ref } from "vue";
import { debounce } from "kompkit-core";

const value = ref("");
const run = debounce((v: string) => console.log("search", v), 250);
</script>

<template>
  <input v-model="value" @input="run(value)" placeholder="Search" />
</template>
```

## Notes

- Framework-agnostic: works with React, Vue, or any TS/JS app.
- Module formats: ESM and CJS are provided.
- Zero runtime dependencies.
- Types included (`.d.ts`).
