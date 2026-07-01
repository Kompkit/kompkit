# kompkit-core

[![Version](https://img.shields.io/badge/version-0.4.1--alpha.0-orange.svg)](https://github.com/Kompkit/KompKit/releases)
[![Web CI](https://github.com/Kompkit/KompKit/actions/workflows/web.yml/badge.svg?branch=release)](https://github.com/Kompkit/KompKit/actions/workflows/web.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![TypeScript](https://img.shields.io/badge/TypeScript-007ACC?logo=typescript&logoColor=white)](https://www.typescriptlang.org/)

Cross-platform utility functions for web applications. Part of the [KompKit](https://github.com/Kompkit/KompKit) ecosystem.

> The same utilities — same names, same defaults, same behavior — are also available for [Android/Kotlin](https://github.com/Kompkit/KompKit/tree/release/packages/core/android) and [Flutter/Dart](https://pub.dev/packages/kompkit_core).

## Installation

```sh
npm install kompkit-core
```

## Utilities

### `debounce`

Delays invoking a function until after `wait` ms have elapsed since the last call. Returns a `Debounced` wrapper — call it exactly like the original function, and call `.cancel()` to discard any pending execution.

```ts
import { debounce } from "kompkit-core";

const search = debounce((query: string) => {
  fetchResults(query);
}, 300);

input.addEventListener("input", () => search(input.value));

// Cancel a pending call (e.g. on component unmount)
search.cancel();
```

**Signature:**

```ts
function debounce<T extends (...args: any[]) => void>(
  fn: T,
  wait?: number,
): Debounced<T>;

interface Debounced<T extends (...args: any[]) => void> {
  (...args: Parameters<T>): void;
  cancel(): void;
}
```

- `wait` defaults to `250ms`

---

### `isEmail`

Validates whether a string is a well-formed email address.

```ts
import { isEmail } from "kompkit-core";

isEmail("user@example.com"); // true
isEmail("not-an-email"); // false
isEmail("  user@test.io "); // true (trims whitespace)
```

**Signature:**

```ts
function isEmail(value: string): boolean;
```

---

### `clamp`

Constrains a number within an inclusive `[min, max]` range.

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

**Signature:**

```ts
function clamp(value: number, min: number, max: number): number;
```

- Throws `RangeError` if any argument is `NaN` or `Infinity`
- Throws `RangeError` if `min > max`

---

### `throttle`

Limits a function to execute at most once per `wait` milliseconds. The first call executes immediately; subsequent calls within the wait period are ignored.

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

Unlike `debounce` (which waits until calls stop), `throttle` fires immediately then enforces a cooldown — ideal for scroll, resize, and pointer events.

**Signature:**

```ts
function throttle<T extends (...args: any[]) => void>(
  fn: T,
  wait: number,
): T & { cancel(): void };
```

- Throws `Error` if `wait <= 0`

---

### `retry`

Executes an async function with automatic retries and exponential backoff. On each failure the delay doubles (by default), capped at `maxDelay`. If all attempts fail, the last error is rethrown.

```ts
import { retry } from "kompkit-core";

// Basic — 3 attempts, 1s base delay, ×2 multiplier (defaults)
const data = await retry(() => fetch("/api/data").then((r) => r.json()));

// Custom options
const result = await retry(() => unreliableCall(), {
  maxAttempts: 5,
  baseDelay: 500,
  multiplier: 3,
  maxDelay: 10_000,
});

// Conditional retry — skip auth errors
await retry(() => fetchWithAuth(), {
  retryIf: (err) => (err as Response)?.status !== 401,
});
```

**Signature:**

```ts
function retry<T>(
  fn: () => T | Promise<T>,
  options?: RetryOptions,
): Promise<T>;

interface RetryOptions {
  maxAttempts?: number; // default 3
  baseDelay?: number; // default 1000 (ms)
  maxDelay?: number; // default 30000 (ms)
  multiplier?: number; // default 2
  retryIf?: (error: unknown) => boolean;
}
```

- Throws `RangeError` for invalid option values
- Delay sequence: `baseDelay`, `baseDelay × multiplier`, `baseDelay × multiplier²`, … capped at `maxDelay`

---

### `formatCurrency`

Formats a number as a localized currency string using `Intl.NumberFormat`.

```ts
import { formatCurrency } from "kompkit-core";

formatCurrency(1234.56); // "$1,234.56" (en-US / USD default)
formatCurrency(1234.56, "EUR", "de-DE"); // "1.234,56 €"
formatCurrency(1234.56, "JPY", "ja-JP"); // "￥1,235"
formatCurrency(NaN); // throws RangeError
```

**Signature:**

```ts
function formatCurrency(
  amount: number,
  currency?: string,
  locale?: string,
): string;
```

- `currency` defaults to `"USD"`
- `locale` defaults to `"en-US"` (BCP 47 format)
- Throws `RangeError` if `amount` is `NaN` or `Infinity`
- Throws `RangeError` for invalid currency codes

---

## Requirements

- Node.js `>=20`
- TypeScript `>=5.7` (if using types)

## Module format

This package ships both **ESM and CommonJS** builds. The correct format is resolved automatically via the `exports` field in `package.json`.

```ts
// ESM (recommended)
import { debounce } from "kompkit-core";

// CommonJS
const { debounce } = require("kompkit-core");
```

Node.js `>=20` is required.

## Platform Differences

KompKit aims for conceptual API parity, but some differences exist due to platform constraints:

| Difference                             | Detail                                                                                                     |
| -------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| `debounce` — Dart                      | Only supports single-argument functions. TypeScript supports variadic args (`...args`).                    |
| `debounce` — Kotlin                    | Requires a `CoroutineScope` parameter (structured concurrency).                                            |
| `formatCurrency` — Kotlin              | Accepts a BCP 47 `String` locale, converts to `Locale` internally.                                         |
| `formatCurrency` — invalid locale      | TypeScript/V8 and Kotlin/JVM fall back silently; Dart (`intl`) throws.                                     |
| `formatCurrency` — currency validation | TypeScript uses `Intl.NumberFormat`; Kotlin uses `Currency.getInstance`; Dart uses a regex (`^[A-Z]{3}$`). |
| `formatCurrency` — symbol vs code      | TypeScript/Kotlin render the localized symbol (`$1,234.56`); Dart's `intl` renders the ISO 4217 code (`USD1,234.56`).       |

## Cross-platform

| Platform         | Package                                             |
| ---------------- | --------------------------------------------------- |
| Web (TypeScript) | `npm install kompkit-core`                          |
| Flutter (Dart)   | `flutter pub add kompkit_core`                      |
| Android (Kotlin) | Local project reference (Maven publish coming soon) |

## Links

- [GitHub](https://github.com/Kompkit/KompKit)
- [Changelog](https://github.com/Kompkit/KompKit/blob/release/docs/CHANGELOG.md)
- [Contributing](https://github.com/Kompkit/KompKit/blob/release/docs/CONTRIBUTING.md)
- [Flutter package on pub.dev](https://pub.dev/packages/kompkit_core)

## License

MIT © [KompKit](https://github.com/Kompkit)
