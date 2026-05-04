# FAQ

## Why start with utilities instead of UI components?

Utilities provide immediate value across platforms without requiring design decisions or framework-specific implementations. They establish the foundation for cross-platform parity and can be used in any codebase. UI components will be considered in future phases once the utility layer is stable.

## What utilities are available?

KompKit Core `0.4.1-alpha.0` currently provides:

- **`debounce`** — Delay function execution until after a wait period
- **`isEmail`** — Validate email addresses with a regex pattern
- **`formatCurrency`** — Format numbers as localized currency strings
- **`clamp`** — Constrain a number within an inclusive `[min, max]` range
- **`throttle`** — Limit a function to execute at most once per wait period

All utilities are available on Web (TypeScript), Android (Kotlin), and Flutter (Dart) with identical APIs.

## What is the difference between `debounce` and `throttle`?

Both limit how often a function runs, but in different ways:

- **`debounce`** waits until calls have _stopped_ for the wait period before executing. Useful for search inputs — you only want to fire after the user stops typing.
- **`throttle`** executes immediately on the first call, then ignores further calls until the wait period has elapsed. Useful for scroll or resize handlers — you want regular updates but not on every single event.

## Do `debounce` and `throttle` support cancellation?

Yes. Both return an object with a `cancel()` method that resets internal state immediately — no pending execution will fire after `cancel()` is called. Always call `cancel()` on component unmount or when the handler is no longer needed to avoid stale callbacks.

## What happens if I pass `wait <= 0`?

Both `debounce` and `throttle` throw immediately:

- **TypeScript**: `Error`
- **Kotlin**: `IllegalArgumentException`
- **Dart**: `ArgumentError`

`clamp` throws a `RangeError` (TS) / `IllegalArgumentException` (Kotlin) / `ArgumentError` (Dart) if `min > max` or any argument is `NaN` / `Infinity`.

## Is it tree-shakable?

Yes. The web package is built with `tsup` and exports individual functions. Modern bundlers like Webpack, Vite, and Rollup will only include the utilities you import.

## Does it support multiple locales?

Yes. The `formatCurrency` utility accepts a `locale` parameter (e.g., `"en-US"`, `"es-ES"`, `"ja-JP"`). It uses `Intl.NumberFormat` on web, `NumberFormat` on Android, and the `intl` package on Flutter — all of which support standard BCP 47 locale tags.

## Does the Kotlin package require coroutines?

Yes. `debounce` and `throttle` both require a `CoroutineScope` to manage their internal timing. This is a deliberate design choice — it integrates with Kotlin's structured concurrency so that pending work is automatically cancelled when the scope is cancelled (e.g., a `viewModelScope` or `lifecycleScope`). `isEmail`, `formatCurrency`, and `clamp` have no coroutine dependency.

## Will there be wrappers for React/Vue later?

Possibly. The current utilities are framework-agnostic and work directly in React, Vue, or vanilla JS. If specific hooks or composables would add value (e.g., `useDebounce`, `useThrottle`), they may be added as optional packages in the future.

## Is it production-ready?

Not yet. The library is at `0.4.1-alpha.0`. APIs may change, and the test coverage is still expanding. Use it in experimental projects, but avoid production deployments until a stable `1.0.0` release.
