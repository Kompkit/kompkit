# Web guide

KompKit Core provides small, framework-agnostic utilities for web applications written in TypeScript.

Status: `V0.2.0-alpha`.

## Installation

```bash
npm i @kompkit/core
```

## Imports

ESM:

```ts
import { debounce, isEmail, formatCurrency } from "@kompkit/core";
```

CommonJS:

```js
const { debounce, isEmail, formatCurrency } = require("@kompkit/core");
```

## Usage examples

### debounce

```ts
import { debounce } from "@kompkit/core";

const onType = debounce((value: string) => {
  console.log("Search:", value);
}, 300);

onType("k");
onType("ko");
onType("kompkit"); // only this call will execute after ~300ms
```

### isEmail

```ts
import { isEmail } from "@kompkit/core";

isEmail("test@example.com"); // true
isEmail("invalid@"); // false
```

### formatCurrency

```ts
import { formatCurrency } from "@kompkit/core";

formatCurrency(1234.56); // "1.234,56 €" (es-ES by default)
formatCurrency(1234.56, "USD", "en-US"); // "$1,234.56"
```

## React snippet

```tsx
import { useState } from "react";
import { debounce } from "@kompkit/core";

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
import { debounce } from "@kompkit/core";

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
