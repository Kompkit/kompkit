# Roadmap

## Current State — `0.4.1-alpha.0` ✅ Released

KompKit Core is in early alpha. The current release includes:

| Item                                                                      | Status       |
| ------------------------------------------------------------------------- | ------------ |
| 5 utilities: `debounce`, `isEmail`, `formatCurrency`, `clamp`, `throttle` | ✅ Completed |
| TypeScript package published to npm                                       | ✅ Completed |
| Flutter/Dart package published to pub.dev                                 | ✅ Completed |
| Android/Kotlin Maven Central publishing config                            | ✅ Completed |
| Conceptual API parity across all platforms with documented divergences    | ✅ Completed |
| Full CI/CD with path-based workflow optimization                          | ✅ Completed |
| `cancel()` support on `debounce` and `throttle` across all platforms      | ✅ Completed |

## Next: `0.5.0-alpha`

Focus: async utilities.

| Item                                                                      | Status     |
| ------------------------------------------------------------------------- | ---------- |
| `sleep` — Promise/Future/suspend-based delay utility                      | 📋 Planned |
| `retry` — Retry failed async operations with configurable backoff         | 📋 Planned |
| Add `exports` subpath entries for individual utilities (web tree-shaking) | 📋 Planned |
| Dedicated documentation site                                              | 📋 Planned |

## After: `0.6.0-alpha`

Focus: data utilities and deeper platform integration.

| Item                                                                                | Status     |
| ----------------------------------------------------------------------------------- | ---------- |
| `deepEqual` — Deep equality comparison for plain objects/maps                       | 📋 Planned |
| React hooks companion package (`kompkit-react`) — thin wrappers over core utilities | 📋 Planned |

## Toward `1.0.0`

Before a stable 1.0 release, the following must be true:

| Requirement                                                                | Status         |
| -------------------------------------------------------------------------- | -------------- |
| All three platform packages published to their respective registries       | 🔄 In Progress |
| API contract frozen with a documented migration guide for breaking changes | 📋 Planned     |
| Behavioral test coverage for all edge cases across all platforms           | 🔄 In Progress |
| Dedicated documentation site with live examples                            | 📋 Planned     |
| No known behavioral divergences between platforms                          | 📋 Planned     |

## Long-term (post-1.0)

- Vue composables package (`kompkit-vue`)
- iOS/Swift implementation following the same API contract
- Design token utilities (color, spacing, typography) — separate package

---

Timelines are not fixed. Priorities are driven by community feedback and real-world usage.
