# Roadmap

## Current State — `0.3.1-alpha.0`

KompKit Core is in early alpha. The current release includes:

- **3 utilities**: `debounce`, `isEmail`, `formatCurrency`
- **3 platforms**: TypeScript (npm), Dart/Flutter (pub.dev), Kotlin/JVM (local only)
- **Conceptual API parity** across all platforms with documented divergences
- **Full CI/CD** with path-based workflow optimization
- **Cancel support** on `debounce` across all platforms

## Next: `0.3.1-alpha`

Focus: utility expansion and Android publishing.

- `throttle` — Rate-limit function calls (natural companion to `debounce`)
- `clamp` — Clamp a number between min and max
- `sleep` — Promise/Future/suspend-based delay utility
- Publish Android/Kotlin package to Maven Central
- Add `exports` subpath entries for individual utilities (tree-shaking improvement)

## After: `0.4.0-alpha`

Focus: async utilities and deeper platform integration.

- `retry` — Retry failed async operations with configurable backoff
- `deepEqual` — Deep equality comparison for plain objects/maps
- React hooks companion package (`kompkit-react`) — thin wrappers over core utilities

## Toward `1.0.0`

Before a stable 1.0 release, the following must be true:

- All three platform packages published to their respective registries
- API contract frozen with a documented migration guide for any breaking changes
- Behavioral test coverage for all edge cases across all platforms
- Dedicated documentation site with live examples
- No known behavioral divergences between platforms

## Long-term (post-1.0)

- Vue composables package (`kompkit-vue`)
- iOS/Swift implementation following the same API contract
- Design token utilities (color, spacing, typography) — separate package

---

Timelines are not fixed. Priorities are driven by community feedback and real-world usage.
