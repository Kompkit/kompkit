# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.3.1-alpha.0] - 2026-02-20

### Changed

- **`formatCurrency` default currency**: Changed from `EUR` to `USD` across all platforms (TypeScript, Kotlin, Dart)
- **`formatCurrency` finite validation**: Added validation that throws on `NaN` and `Infinity` amounts across all platforms
  - TypeScript: throws `RangeError`
  - Kotlin: throws `IllegalArgumentException`
  - Dart: throws `ArgumentError`
- **Documentation**: Corrected `formatCurrency` examples to reflect `USD` default
- **Documentation**: Added Platform Differences section to npm README documenting Dart single-argument debounce limitation and other divergences
- **Packaging**: Clarified that `kompkit-core` ships both ESM and CommonJS builds (not ESM-only)

### Fixed

- Documentation inconsistency where examples showed `USD` but default was `EUR`

## [0.3.0-alpha] - 2026-02-09

### Changed

#### Dependency Updates

- **Kotlin**: `2.1.0` → `2.3.0`
- **ktlint-gradle**: `12.1.2` → `14.0.1`
- **detekt**: `1.23.7` → `1.23.8`
- **Vitest**: `^1.6.0` → `^3.0.0`
- **tsup**: `^8.0.0` → `^8.5.0`
- **TypeDoc**: `^0.28.14` → `^0.28.16`
- **TypeScript**: `^5.6.0` → `^5.7.0`
- **intl** (Dart): `^0.19.0` → `^0.20.0`
- **flutter_lints**: `^3.0.0` → `^5.0.0`
- **codecov-action**: `v3` → `v5`
- **Flutter CI**: `3.24.0` → `3.27.4`

#### Documentation

- Added Flutter platform references across all documentation (ARCHITECTURE, CHANGELOG, README_CI, contributing, roadmap)
- Updated outdated coroutines version references (`1.8.1` → `1.10.2`) in docs
- Fixed Web CI path filter to exclude Flutter changes
- Updated API signatures and platform-specific adaptations in ARCHITECTURE.md

### Fixed

- Web CI workflow now correctly excludes `packages/core/flutter/**` from triggers
- Documentation inconsistencies where Flutter was missing from cross-platform references
- Stale version numbers across documentation files

---

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
- **Android not yet published**: Android/Kotlin package is not yet published to Maven; use local project reference
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
