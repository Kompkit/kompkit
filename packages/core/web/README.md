# kompkit-core

[![Version](https://img.shields.io/badge/version-0.3.1--alpha.0-orange.svg)](https://github.com/Kompkit/KompKit/releases)
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

Delays invoking a function until after `wait` ms have elapsed since the last call. Returns a `Debounced` object with a `cancel()` method.

```ts
import { debounce } from "kompkit-core";

const search = debounce((query: string) => {
  fetchResults(query);
}, 300);

input.addEventListener("input", (e) => search.call(e.target.value));

// Cancel a pending call (e.g. on component unmount)
search.cancel();
```

**Signature:**

```ts
function debounce<T>(action: (value: T) => void, wait?: number): Debounced<T>;

interface Debounced<T> {
  call(value: T): void;
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

clamp(5, 0, 10); // 5
clamp(-3, 0, 10); // 0
clamp(15, 0, 10); // 10
```

**Signature:**

```ts
function clamp(value: number, min: number, max: number): number;
```

- Throws `RangeError` if any argument is `NaN` or `Infinity`
- Throws `RangeError` if `min > max`

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
