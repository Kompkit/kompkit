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

## Implementation Strategy

### API Design

We maintain strict API consistency across platforms:

**TypeScript:**

```typescript
export function debounce<T extends (...args: any[]) => any>(
  fn: T,
  wait: number = 250,
): T;

export function isEmail(value: string): boolean;

export function formatCurrency(
  amount: number,
  currency: string = "EUR",
  locale: string = "es-ES",
): string;
```

**Kotlin:**

```kotlin
fun <T> debounce(
  waitMs: Long = 250L,
  scope: CoroutineScope,
  dest: (T) -> Unit
): (T) -> Unit

fun isEmail(value: String): Boolean

fun formatCurrency(
  amount: Double,
  currency: String = "EUR",
  locale: Locale = Locale("es", "ES")
): String
```

**Dart:**

```dart
Function debounce<T>(
  Function fn,
  [Duration wait = const Duration(milliseconds: 250)]
);

VoidCallback debounceVoid(
  VoidCallback fn,
  [Duration wait = const Duration(milliseconds: 250)]
);

bool isEmail(String value);

String formatCurrency(
  num amount, {
  String currency = "EUR",
  String locale = "es_ES",
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
