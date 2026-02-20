# kompkit-core

[![Version](https://img.shields.io/badge/version-0.3.0--alpha.0-orange.svg)](https://github.com/Kompkit/KompKit/releases)
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
import { debounce } from 'kompkit-core';

const search = debounce((query: string) => {
  fetchResults(query);
}, 300);

input.addEventListener('input', (e) => search.call(e.target.value));

// Cancel a pending call (e.g. on component unmount)
search.cancel();
```

**Signature:**
```ts
function debounce<T>(action: (value: T) => void, wait?: number): Debounced<T>

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
import { isEmail } from 'kompkit-core';

isEmail('user@example.com') // true
isEmail('not-an-email')     // false
isEmail('  user@test.io ') // true (trims whitespace)
```

**Signature:**
```ts
function isEmail(value: string): boolean
```

---

### `formatCurrency`

Formats a number as a localized currency string using `Intl.NumberFormat`.

```ts
import { formatCurrency } from 'kompkit-core';

formatCurrency(1234.56)                          // "$1,234.56" (en-US, EUR default)
formatCurrency(1234.56, 'USD', 'en-US')          // "$1,234.56"
formatCurrency(1234.56, 'EUR', 'de-DE')          // "1.234,56 €"
formatCurrency(1234.56, 'JPY', 'ja-JP')          // "￥1,235"
```

**Signature:**
```ts
function formatCurrency(amount: number, currency?: string, locale?: string): string
```

- `currency` defaults to `"EUR"`
- `locale` defaults to `"en-US"` (BCP 47 format)
- Throws `RangeError` for invalid currency codes

---

## Requirements

- Node.js `>=20`
- TypeScript `>=5.7` (if using types)

## Cross-platform

| Platform | Package |
|---|---|
| Web (TypeScript) | `npm install kompkit-core` |
| Flutter (Dart) | `flutter pub add kompkit_core` |
| Android (Kotlin) | Local project reference (Maven publish coming soon) |

## Links

- [GitHub](https://github.com/Kompkit/KompKit)
- [Changelog](https://github.com/Kompkit/KompKit/blob/release/docs/CHANGELOG.md)
- [Contributing](https://github.com/Kompkit/KompKit/blob/release/docs/CONTRIBUTING.md)
- [Flutter package on pub.dev](https://pub.dev/packages/kompkit_core)

## License

MIT © [KompKit](https://github.com/Kompkit)
