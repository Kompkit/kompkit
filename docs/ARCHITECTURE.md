# Architecture Overview

This document describes the architecture and design decisions behind KompKit, a cross-platform utility library for TypeScript, Kotlin, and Dart.

## Design Philosophy

### Cross-Platform First

KompKit is designed with cross-platform compatibility as the primary goal. Every utility function must:

1. **Maintain API parity** across TypeScript, Kotlin, and Dart implementations
2. **Provide identical behavior** regardless of platform
3. **Use platform-native patterns** while maintaining consistency
4. **Minimize dependencies** to reduce bundle size and complexity

### Monorepo Structure

We use a monorepo approach to ensure consistency and simplify development:

```
KompKit/
├── packages/core/              # Core utility packages
│   ├── web/                   # TypeScript/JavaScript implementation
│   ├── android/               # Kotlin JVM implementation
│   └── flutter/               # Dart/Flutter implementation
├── docs/                      # Documentation and guides
├── .github/workflows/         # CI/CD pipelines
└── [root configuration]       # Lerna, npm, Git configuration
```

## Module Architecture

### Core Modules

| Module                  | Platform     | Purpose              | Technology Stack                 |
| ----------------------- | ------------ | -------------------- | -------------------------------- |
| `packages/core/web`     | Web/Node.js  | TypeScript utilities | TypeScript 5.7+, Vitest, TypeDoc |
| `packages/core/android` | JVM/Android  | Kotlin utilities     | Kotlin 2.3.0, JUnit, Dokka       |
| `packages/core/flutter` | Flutter/Dart | Dart utilities       | Dart 3.0+, Flutter Test, DartDoc |

### Shared Concepts

All modules implement identical functionality:

- **debounce**: Function execution delay with cancellation
- **isEmail**: Email validation using regex patterns
- **formatCurrency**: Localized currency formatting

## API Parity Contract

This section defines the formal contract for cross-platform API consistency in KompKit.

### What is Guaranteed

- **Function names** are identical across all platforms (`debounce`, `isEmail`, `formatCurrency`).
- **Behavioral semantics** are identical: given the same inputs, all platforms produce the same observable output.
- **Default values** are identical: `wait = 250ms`, `currency = "EUR"`, `locale = "en-US"`.
- **Error handling philosophy** is consistent: invalid inputs that cannot produce a meaningful result throw/throw-equivalent errors. Silent fallbacks are not permitted.
- **Cancel capability**: `debounce` returns an object with a `cancel()` method on all platforms, allowing callers to discard pending executions (required for safe use in component lifecycles).

### What May Differ

- **Parameter style**: Named parameters (Dart), trailing lambdas (Kotlin), and positional parameters (TypeScript) are idiomatic per language and are not forced to match syntactically.
- **Coroutine scope (Kotlin)**: `debounce` requires a `CoroutineScope` because Kotlin's async model mandates structured concurrency. This is a platform constraint, not an API inconsistency. The scope is the last parameter to allow trailing lambda syntax.
- **Type system expression**: Dart uses `void Function(T)` return types, Kotlin uses `(T) -> Unit`, TypeScript uses a typed wrapper object. All three express the same concept.
- **Locale string format**: All platforms accept BCP 47 locale strings (e.g., `"en-US"`). Kotlin converts internally to `java.util.Locale` as required by the JVM.

### Conceptual Mental Model

Every utility follows the same mental model regardless of platform:

```
debounce(action, options)  → Debounced<T>  (with .cancel())
isEmail(value)             → Boolean
formatCurrency(amount, options) → String
```

A developer familiar with the TypeScript API should be able to use the Kotlin or Dart API with only idiomatic adjustments — not conceptual re-learning.

### Platform Divergence Documentation

Any unavoidable divergence between platforms must be:

1. Documented in this section.
2. Explained with the platform constraint that necessitates it.
3. Kept minimal — divergence is a cost, not a feature.

**Current documented divergences:**

| Function         | Divergence                                                      | Reason                                                           |
| ---------------- | --------------------------------------------------------------- | ---------------------------------------------------------------- |
| `debounce`       | Kotlin requires `CoroutineScope` parameter                      | Structured concurrency — no global timer API                     |
| `debounce`       | Kotlin uses trailing lambda for `action`                        | Idiomatic Kotlin; improves call-site readability                 |
| `formatCurrency` | Kotlin accepts `String` locale, converts to `Locale` internally | JVM `NumberFormat` API requires `java.util.Locale`               |
| `formatCurrency` | TypeScript (V8) does not throw on unrecognized locale strings   | `Intl.NumberFormat` in V8 silently falls back; Kotlin/Dart throw |

---

## Implementation Strategy

### API Design

We maintain conceptual API parity across platforms:

**TypeScript:**

```typescript
interface Debounced<T extends (...args: any[]) => void> {
  (...args: Parameters<T>): void;
  cancel(): void;
}

export function debounce<T extends (...args: any[]) => void>(
  fn: T,
  wait?: number, // default: 250
): Debounced<T>;

export function isEmail(value: string): boolean;

export function formatCurrency(
  amount: number,
  currency?: string, // default: "EUR"
  locale?: string, // default: "en-US"
): string;
```

**Kotlin:**

```kotlin
class Debounced<T>(private val action: (T) -> Unit) {
  operator fun invoke(value: T): Unit
  fun cancel(): Unit
}

fun <T> debounce(
  action: (T) -> Unit,
  waitMs: Long = 250L,
  scope: CoroutineScope,  // platform constraint: structured concurrency
): Debounced<T>

fun isEmail(value: String): Boolean

fun formatCurrency(
  amount: Double,
  currency: String = "EUR",
  locale: String = "en-US",  // converted internally to java.util.Locale
): String
```

**Dart:**

```dart
class Debounced<T> {
  void call(T arg);
  void cancel();
}

Debounced<T> debounce<T>(
  void Function(T) action, [
  Duration wait = const Duration(milliseconds: 250),
]);

bool isEmail(String value);

String formatCurrency(
  num amount, {
  String currency = "EUR",
  String locale = "en-US",
});
```

### Platform-Specific Adaptations

While maintaining API consistency, we leverage platform strengths:

#### TypeScript Implementation

- **Closures** for debounce state management
- **setTimeout/clearTimeout** for timing control
- **Intl.NumberFormat** for currency formatting
- **RegExp** for email validation

#### Kotlin Implementation

- **Coroutines** for asynchronous debounce operations
- **Job cancellation** for timing control
- **NumberFormat/Currency** for localized formatting
- **Regex** for email validation

#### Dart/Flutter Implementation

- **Timer** for debounce scheduling and cancellation
- **intl package** (`NumberFormat.currency`) for localized formatting
- **RegExp** for email validation
- **Null safety** with full type-safe APIs

## Build System Architecture

### Monorepo Management

**Lerna + npm workspaces** for unified dependency management:

```json
{
  "workspaces": ["packages/core/web"],
  "devDependencies": {
    "lerna": "^8.2.4",
    "tsup": "^8.5.0",
    "typescript": "^5.7.0",
    "typedoc": "^0.28.16",
    "vitest": "^3.0.0"
  }
}
```

### Build Targets

| Platform | Build Tool   | Output            | Documentation                 |
| -------- | ------------ | ----------------- | ----------------------------- |
| Web      | tsup         | ESM + CJS + Types | TypeDoc → `docs/api/web/`     |
| Kotlin   | Gradle       | JAR               | Dokka → `docs/api/android/`   |
| Flutter  | Flutter/Dart | Dart package      | DartDoc → `docs/api/flutter/` |

### Dependency Strategy

**Zero Runtime Dependencies:**

- Web utilities use only browser/Node.js built-ins
- Kotlin utilities use only JDK/Kotlin stdlib
- Development dependencies isolated to build process

## CI/CD Architecture

### Workflow Separation

**Path-based optimization** to minimize build times:

```yaml
# Web CI - packages/core/web/**
web.yml:
  - Node.js 20 setup
  - npm ci (with caching)
  - Lerna build/test
  - TypeDoc generation
  - Artifact upload

# Kotlin CI - packages/core/android/**
android.yml:
  - JDK 17 setup
  - Gradle build (with caching)
  - ktlint + detekt
  - JAR generation
  - Dokka documentation
```

### Quality Gates

**Automated quality assurance:**

1. **Code formatting**: ktlint (Kotlin), Prettier (TypeScript)
2. **Static analysis**: detekt (Kotlin), ESLint (TypeScript)
3. **Testing**: JUnit (Kotlin), Vitest (TypeScript)
4. **Documentation**: Auto-generated API docs
5. **Build verification**: Cross-platform compatibility

## Testing Strategy

### Test Structure

**Platform-specific test suites** with identical test cases:

```
packages/core/web/tests/
└── core.test.ts              # All utility tests

packages/core/android/src/test/kotlin/com/kompkit/core/
└── CoreTests.kt              # All utility tests

packages/core/flutter/test/
├── kompkit_core_test.dart     # Integration tests
├── debounce_test.dart         # Debounce unit tests
├── validate_test.dart         # Validation unit tests
└── format_test.dart           # Formatting unit tests
```

### Test Coverage

**100% coverage requirement** across both platforms:

- Unit tests for all public APIs
- Edge case validation
- Error condition handling
- Performance benchmarks

## Documentation Architecture

### Multi-Platform Documentation

**Unified documentation strategy:**

```
docs/
├── README_CI.md           # CI/CD processes
├── CONTRIBUTING.md        # Development guidelines
├── CHANGELOG.md          # Version history
├── ARCHITECTURE.md       # This document
└── api/                  # Generated API docs
    ├── web/              # TypeDoc output
    ├── android/          # Dokka output
    └── flutter/          # DartDoc output
```

### Documentation Generation

**Automated documentation pipeline:**

1. **Source comments**: JSDoc (TypeScript) + KDoc (Kotlin) + DartDoc (Dart)
2. **Build process**: TypeDoc + Dokka + DartDoc generation
3. **CI integration**: Docs updated on every build
4. **Artifact storage**: 30-day retention for documentation

## Scalability Considerations

### Adding New Utilities

**Standardized process** for expanding the library:

1. **Design phase**: Define cross-platform API contract
2. **Implementation**: Parallel development in both platforms
3. **Testing**: Comprehensive test coverage
4. **Documentation**: API docs and usage examples
5. **Integration**: Update exports and build processes

### Future Platform Support

**Extensible architecture** for additional platforms:

- **React Native**: Potential TypeScript reuse
- **iOS**: Swift implementation following same patterns
- **Python**: Additional server-side support

### Performance Optimization

**Built-in performance considerations:**

- **Tree-shaking support** for minimal bundle sizes
- **Lazy loading** capabilities for large utility sets
- **Caching strategies** for expensive operations
- **Memory management** in long-running applications

## Security Architecture

### Dependency Security

**Minimal attack surface:**

- Zero runtime dependencies
- Pinned development dependencies
- Regular security audits via Dependabot
- Automated vulnerability scanning

### Code Security

**Secure coding practices:**

- Input validation in all utilities
- No eval() or dynamic code execution
- Sanitized regex patterns
- Memory-safe operations

## Deployment Strategy

### Release Process

**Controlled release pipeline:**

1. **Development**: Feature branches → `develop`
2. **Integration**: CI validation on `develop`
3. **Release preparation**: Version bump + changelog
4. **Stable release**: `develop` → `release`
5. **Distribution**: Package registry publication

### Version Management

**Semantic versioning** with clear upgrade paths:

- **Major**: Breaking API changes
- **Minor**: New features (backward compatible)
- **Patch**: Bug fixes and improvements
- **Alpha/Beta**: Pre-release versions

---

This architecture provides a solid foundation for cross-platform utility development while maintaining simplicity, performance, and developer experience.
