# KompKit

[![Version](https://img.shields.io/badge/version-0.3.1--alpha.0-orange.svg)](https://github.com/Kompkit/KompKit/releases)
[![Web CI](https://github.com/Kompkit/KompKit/actions/workflows/web.yml/badge.svg?branch=develop)](https://github.com/Kompkit/KompKit/actions/workflows/web.yml)
[![Kotlin CI](https://github.com/Kompkit/KompKit/actions/workflows/android.yml/badge.svg?branch=develop)](https://github.com/Kompkit/KompKit/actions/workflows/android.yml)
[![Flutter CI](https://github.com/Kompkit/KompKit/actions/workflows/flutter.yml/badge.svg?branch=develop)](https://github.com/Kompkit/KompKit/actions/workflows/flutter.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![TypeScript](https://img.shields.io/badge/TypeScript-007ACC?logo=typescript&logoColor=white)](https://www.typescriptlang.org/)
[![Kotlin](https://img.shields.io/badge/Kotlin-0095D5?logo=kotlin&logoColor=white)](https://kotlinlang.org/)
[![Dart](https://img.shields.io/badge/Dart-0175C2?logo=dart&logoColor=white)](https://dart.dev/)

> **⚠️ Alpha Release**: This is an early alpha version. APIs may change before stable release. See [Stability Policy](#stability-policy) below.

A lightweight cross-platform utility kit providing essential functions for Web (TypeScript), Android (Kotlin), and Flutter (Dart) development. Built as a monorepo with conceptual API parity across platforms.

## Why KompKit?

Most utility libraries are platform-specific. When you build a product across Web, Android, and Flutter, you end up with three different utility ecosystems, three different mental models, and three different sets of edge-case behaviors.

KompKit solves this by providing the same utilities — with the same names, the same defaults, and the same behavioral semantics — across all three platforms. You learn the API once. You use it everywhere.

**What it is:**

- A small, focused set of production-safe utility functions
- Conceptually identical across TypeScript, Kotlin, and Dart
- Idiomatic per platform — no forced unnatural APIs
- Minimal dependencies, no runtime bloat

**What it is not:**

- A replacement for lodash, Kotlin stdlib, or Dart's core libraries
- A UI component library
- A framework or abstraction layer

## Target Audience

KompKit is for teams and developers who:

- Build products across **multiple platforms simultaneously** (e.g., a web app + Android app + Flutter app)
- Want **consistent utility behavior** without maintaining separate implementations per platform
- Value **minimal dependencies** and **predictable APIs**
- Are comfortable with alpha software and want to shape the API before 1.0

## Overview

KompKit provides essential utility functions that work seamlessly across Web (TypeScript), Android (Kotlin), and Flutter (Dart) platforms. Built with developer experience in mind, it offers identical APIs across platforms while leveraging platform-specific optimizations.

### Monorepo Structure

| Module                  | Platform      | Description                               | Status    |
| ----------------------- | ------------- | ----------------------------------------- | --------- |
| `packages/core/web`     | TypeScript    | Web utilities with Node.js support        | ✅ Alpha  |
| `packages/core/android` | Kotlin JVM    | Android utilities with coroutines         | ✅ Alpha  |
| `packages/core/flutter` | Dart          | Flutter/Dart utilities with async support | ✅ Alpha  |
| `docs/`                 | Documentation | API docs, guides, and examples            | ✅ Alpha  |
| `.github/workflows/`    | CI/CD         | Automated testing and validation          | ✅ Active |

### Core Utilities

- **🕐 debounce** - Delay function execution until after a wait period (prevents excessive API calls)
- **📧 isEmail** - Validate email addresses with robust regex patterns
- **💰 formatCurrency** - Format numbers as currency with full locale support
- **📐 clamp** - Constrain a number within an inclusive [min, max] range

### Key Features

- ✅ **Cross-platform compatibility** - Identical APIs for Web, Android, and Flutter
- ✅ **TypeScript support** - Full type safety and IntelliSense
- ✅ **Zero dependencies** - Lightweight with no external dependencies
- ✅ **Comprehensive testing** - 100% test coverage across platforms
- ✅ **Modern tooling** - Built with latest TypeScript 5.7+ and Kotlin 2.3+
- ✅ **Rich documentation** - Auto-generated API docs with examples
- ✅ **CI/CD Ready** - Automated testing with GitHub Actions

## Getting Started

### Prerequisites

- **Web**: Node.js 20+ and npm/yarn
- **Android**: JDK 17+ and Kotlin 2.3+
- **Flutter**: Flutter 3.0+ and Dart 3.0+

### Installation

#### Web (npm)

```bash
npm i kompkit-core
```

> Published on [npmjs.com/package/kompkit-core](https://www.npmjs.com/package/kompkit-core)

#### Flutter / Dart (pub.dev)

Add to your `pubspec.yaml`:

```yaml
dependencies:
  kompkit_core: ^0.3.1-alpha.0
```

Then run:

```bash
flutter pub get
```

> Published on [pub.dev/packages/kompkit_core](https://pub.dev/packages/kompkit_core)

#### Android (Kotlin) — Local only

> **Note**: The Android/Kotlin package is not yet published to Maven. Use a local project reference for now.

```kotlin
// settings.gradle.kts
include(":kompkit-core")
project(":kompkit-core").projectDir = file("path/to/KompKit/packages/core/android")

// app/build.gradle.kts
dependencies {
    implementation(project(":kompkit-core"))
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.10.2")
}
```

### Quick Start

Once installed, you can import and use KompKit utilities:

**TypeScript/JavaScript:**

```typescript
import { debounce, isEmail, formatCurrency } from "kompkit-core";

const search = debounce((query: string) => {
  console.log("Searching:", query);
}, 300);

console.log(isEmail("user@example.com")); // true
console.log(formatCurrency(1234.56)); // "1.234,56 €"
```

**Kotlin:**

```kotlin
import com.kompkit.core.*

val search = debounce<String>(300L, scope) { query ->
    println("Searching: $query")
}

println(isEmail("user@example.com")) // true
println(formatCurrency(1234.56)) // "1.234,56 €"
```

**Dart/Flutter:**

```dart
import 'package:kompkit_core/kompkit_core.dart';

final search = debounce<String>((String query) {
  print('Searching: $query');
}, const Duration(milliseconds: 300));

print(isEmail('user@example.com')); // true
print(formatCurrency(1234.56)); // "1.234,56 €"
```

## Documentation

### 📚 Detailed Guides

- **[Getting Started Guide](./docs/getting-started.md)** - Complete setup and first steps
- **[API Reference](./docs/api/)** - Auto-generated API documentation
  - [Web/TypeScript API](./docs/api/web/) - TypeDoc generated docs
  - [Android/Kotlin API](./docs/api/android/) - Dokka generated docs
- **[Architecture Overview](./docs/ARCHITECTURE.md)** - Monorepo structure and design
- **[Contributing Guide](./docs/CONTRIBUTING.md)** - Development workflow and guidelines
- **[CI/CD Documentation](./docs/README_CI.md)** - Build and deployment processes

### 🔧 Development

- **[Changelog](./docs/CHANGELOG.md)** - Version history and breaking changes
- **[Roadmap](./docs/roadmap.md)** - Planned features and improvements

## Project Structure

```
KompKit/
├── .github/workflows/          # CI/CD pipelines
│   ├── web.yml                # Web package testing
│   ├── android.yml            # Kotlin package testing
│   └── flutter.yml            # Flutter/Dart package testing
├── packages/core/
│   ├── web/                   # TypeScript package
│   │   ├── src/              # Source files
│   │   ├── tests/            # Test files
│   │   └── package.json
│   ├── android/              # Kotlin JVM package
│   │   ├── src/main/kotlin/  # Source files
│   │   ├── src/test/kotlin/  # Test files
│   │   └── build.gradle.kts
│   └── flutter/              # Dart package
│       ├── src/              # Source files
│       ├── test/             # Test files
│       └── pubspec.yaml
├── docs/                     # Documentation
│   ├── api/                  # Generated API docs
│   └── *.md                  # Guides and references
└── package.json             # Root configuration
```

## Version Information

- **Current Version**: `0.3.1-alpha`
- **Minimum Requirements**:
  - Node.js 20+ (Web)
  - JDK 17+ (Android)
  - Flutter 3.0+ (Flutter)
  - TypeScript 5.7+
  - Kotlin 2.3+
  - Dart 3.0+

## Stability Policy

KompKit is currently in **alpha**. This means:

- **APIs may change** between alpha versions without a deprecation period.
- **Pin to exact versions** in production: `"kompkit-core": "0.3.1-alpha.0"` / `kompkit_core: 0.3.1-alpha.0`.
- **Breaking changes** will be documented in [CHANGELOG.md](./docs/CHANGELOG.md) with migration notes.
- Once `1.0.0` is released, the project will follow strict [Semantic Versioning](https://semver.org/): breaking changes only in major versions.

## Platform Differences

KompKit aims for **conceptual parity**, not syntactic identity. The following differences are intentional and documented:

| Utility          | Platform | Difference                                                     | Reason                                                      |
| ---------------- | -------- | -------------------------------------------------------------- | ----------------------------------------------------------- |
| `debounce`       | Kotlin   | Requires `CoroutineScope` parameter                            | Structured concurrency — no global timer API on JVM         |
| `debounce`       | Kotlin   | Action is first parameter, scope is last                       | Enables idiomatic trailing lambda syntax                    |
| `formatCurrency` | Kotlin   | Accepts `String` locale, converts to `Locale` internally       | JVM `NumberFormat` requires `java.util.Locale`              |
| `formatCurrency` | Dart     | Accepts BCP 47 locale, normalizes hyphen→underscore internally | `intl` package uses underscore-separated locale identifiers |

All platforms accept BCP 47 locale strings (e.g., `"en-US"`). All platforms throw on invalid `currency` or `locale` inputs.

## Contributing

We welcome contributions! Please see our [Contributing Guide](./docs/CONTRIBUTING.md) for details on:

- Development setup
- Code style and conventions
- Testing requirements
- Pull request process

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

- 📖 **Documentation**: [./docs/](./docs/)
- 🐛 **Issues**: [GitHub Issues](https://github.com/Kompkit/KompKit/issues)
- 💬 **Discussions**: [GitHub Discussions](https://github.com/Kompkit/KompKit/discussions)

---

> **Alpha Notice**: This project is in active development. APIs may change before the stable 1.0 release. We recommend pinning to specific versions in production applications.
