# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.0-alpha] - 2025-11-10

### Added

#### Core Features

- **Cross-platform utility library** with identical APIs for TypeScript, Kotlin, and Dart
- **debounce** function for delaying function execution
  - Web: `debounce<T>(fn: T, wait?: number): T`
  - Kotlin: `debounce<T>(waitMs: Long, scope: CoroutineScope, dest: (T) -> Unit): (T) -> Unit`
  - Dart: `debounce<T>(Function fn, [Duration wait])` and `debounceVoid(VoidCallback fn, [Duration wait])`
- **isEmail** function for email validation
  - Web: `isEmail(value: string): boolean`
  - Kotlin: `isEmail(value: String): Boolean`
  - Dart: `isEmail(String value): bool`
- **formatCurrency** function for localized currency formatting
  - Web: `formatCurrency(amount: number, currency?: string, locale?: string): string`
  - Kotlin: `formatCurrency(amount: Double, currency: String, locale: Locale): String`
  - Dart: `formatCurrency(num amount, {String currency, String locale}): String`

#### Development Infrastructure

- **Monorepo structure** with Lerna and npm workspaces
- **Separate CI workflows** for Web, Kotlin, and Flutter platforms
  - Web CI: Node.js 20, TypeScript 5.7+, Vitest testing, TypeDoc documentation
  - Kotlin CI: JDK 17, Kotlin 2.3.0, JUnit testing, Dokka documentation
  - Flutter CI: Flutter 3.27, Dart 3.0+, flutter_test, DartDoc documentation
- **Code quality tools**
  - Kotlin: ktlint formatting, detekt static analysis
  - Web: ESLint, Prettier (configured)
- **Path-based build optimization** to run only relevant CI jobs
- **Automated artifact generation** (JARs, documentation, test reports)

#### Documentation

- **Comprehensive README** with installation and usage examples
- **API documentation** auto-generated for both platforms
- **Contributing guidelines** with development workflow
- **CI/CD documentation** with troubleshooting guides
- **Architecture overview** explaining monorepo structure

#### Build & Testing

- **100% test coverage** across both platforms
- **Automated builds** with caching for optimal performance
- **Cross-platform compatibility** testing
- **Documentation generation** (TypeDoc + Dokka)

### Technical Details

#### Supported Platforms

- **Web**: TypeScript/JavaScript with Node.js 20+
- **Kotlin**: JVM with Kotlin 2.3.0 and JDK 17+
- **Flutter/Dart**: Dart 3.0+ with Flutter 3.0+ (all platforms)

#### Dependencies

- **Zero runtime dependencies** for core utilities
- **Minimal development dependencies** (testing, documentation, build tools)
- **Coroutines support** for Kotlin debounce functionality

#### Performance

- **Lightweight bundle size** with tree-shaking support
- **Optimized CI builds** (< 5 min web, < 8 min Kotlin)
- **Efficient caching** strategies for dependencies and builds

### Known Limitations

- **Alpha release**: APIs may change before stable 1.0 release
- **Local development only**: Packages not yet published to registries
- **Limited utility set**: Only 3 core functions (debounce, isEmail, formatCurrency)

### Migration Notes

This is the initial alpha release. No migration is required.

---

## Release Notes Format

For future releases, we follow this format:

### Added

- New features and functionality

### Changed

- Changes in existing functionality

### Deprecated

- Soon-to-be removed features

### Removed

- Removed features

### Fixed

- Bug fixes

### Security

- Security improvements

---

**Legend:**

- 🎉 **Major feature**
- ✨ **Enhancement**
- 🐛 **Bug fix**
- 📚 **Documentation**
- ⚡ **Performance**
- 🔒 **Security**
