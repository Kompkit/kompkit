# Contributing to KompKit

We welcome contributions to KompKit! This document provides guidelines for contributing to our cross-platform utility library.

## Getting Started

### Prerequisites

- **Node.js** 20+ and npm
- **JDK** 17+ (for Kotlin development)
- **Flutter** 3.0+ and Dart 3.0+ (for Flutter development)
- **Git** for version control

### Development Setup

1. **Fork and clone the repository**

   ```bash
   git clone https://github.com/YOUR_USERNAME/KompKit.git
   cd KompKit
   ```

2. **Install dependencies**

   ```bash
   npm install
   ```

3. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

## Development Workflow

### Branch Strategy

- **`develop`**: Active development branch (target for PRs)
- **`release`**: Stable release branch (production)
- **Feature branches**: `feature/feature-name` or `fix/bug-name`

### Commit Convention

We use [Conventional Commits](https://www.conventionalcommits.org/) for consistent commit messages:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

**Types:**

- `feat`: New features
- `fix`: Bug fixes
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks
- `ci`: CI/CD changes

**Examples:**

```bash
feat(web): add throttle utility function
fix(kotlin): resolve debounce memory leak
docs: update API reference for formatCurrency
test(web): add edge cases for email validation
```

### Code Guidelines

1. **Cross-platform API parity**: Maintain identical APIs across TypeScript, Kotlin, and Dart implementations
2. **Zero dependencies**: Avoid adding runtime dependencies unless absolutely necessary
3. **Comprehensive testing**: Every feature must include tests for all platforms
4. **Documentation**: Update API docs and examples for new features
5. **Type safety**: Use TypeScript and Kotlin type systems effectively

## Development Commands

### Building

```bash
# Build all packages
npm run build

# Build web package only
npm run docs:web

# Build Kotlin package only
cd packages/core/android && ./gradlew assemble
```

### Testing

```bash
# Run all tests
npm test

# Run web tests only
npm run test:web

# Run Kotlin tests only
npm run test:android

# Run Flutter tests only
cd packages/core/flutter && flutter test
```

### Documentation

```bash
# Generate all documentation
npm run docs:all

# Generate web docs (TypeDoc)
npm run docs:web

# Generate Kotlin docs (Dokka)
npm run docs:android
```

### Code Quality

```bash
# Kotlin linting
cd packages/core/android && ./gradlew ktlintCheck

# Kotlin static analysis
cd packages/core/android && ./gradlew detekt

# Auto-fix Kotlin formatting
cd packages/core/android && ./gradlew ktlintFormat
```

## Adding New Utilities

When adding a new utility function:

1. **Implement in all three platforms**:
   - TypeScript: `packages/core/web/src/`
   - Kotlin: `packages/core/android/src/main/kotlin/com/kompkit/core/`
   - Dart: `packages/core/flutter/lib/src/`

2. **Maintain API consistency**:

   ```typescript
   // TypeScript
   export function myUtility(param: string): boolean { ... }
   ```

   ```kotlin
   // Kotlin
   fun myUtility(param: String): Boolean { ... }
   ```

   ```dart
   // Dart
   bool myUtility(String param) { ... }
   ```

3. **Add comprehensive tests**:
   - Web: `packages/core/web/tests/`
   - Kotlin: `packages/core/android/src/test/kotlin/`
   - Flutter: `packages/core/flutter/test/`

4. **Update exports**:
   - Add to `packages/core/web/src/index.ts`
   - Add to `packages/core/flutter/src/kompkit_core.dart`
   - Kotlin exports are automatic via package structure

5. **Document with examples**:
   - Add JSDoc comments (TypeScript)
   - Add KDoc comments (Kotlin)
   - Add DartDoc comments (Dart)

## Code Style

### TypeScript

- Use ESLint and Prettier configurations
- Prefer `const` over `let`
- Use explicit return types for public APIs
- Follow existing naming conventions

### Kotlin

- Follow ktlint formatting rules
- Use detekt for static analysis
- Prefer `val` over `var`
- Use explicit types for public APIs
- Follow Kotlin coding conventions

### Dart/Flutter

- Follow Dart formatting rules (`dart format`)
- Use `flutter analyze` for static analysis
- Prefer `final` over `var` when possible
- Use explicit types for public APIs
- Follow Dart style guide conventions

## Pull Request Process

1. **Create a feature branch**:

   ```bash
   git checkout develop
   git pull origin develop
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes**:
   - Implement feature in all platforms (Web, Android, Flutter)
   - Add comprehensive tests
   - Update documentation

3. **Test thoroughly**:

   ```bash
   npm test
   cd packages/core/android && ./gradlew test
   cd packages/core/flutter && flutter test
   ```

4. **Commit with conventional messages**:

   ```bash
   git add .
   git commit -m "feat(core): add new utility function"
   ```

5. **Push and create PR**:

   ```bash
   git push origin feature/your-feature-name
   ```

6. **PR targets `develop` branch**

### PR Checklist

- [ ] ✅ Feature implemented in TypeScript, Kotlin, and Dart
- [ ] ✅ Tests added for all platforms with good coverage
- [ ] ✅ All existing tests pass (`npm test`)
- [ ] ✅ Code follows style guidelines (ktlint, ESLint)
- [ ] ✅ API documentation updated (JSDoc/KDoc)
- [ ] ✅ Conventional commit messages used
- [ ] ✅ No breaking changes (or clearly documented)
- [ ] ✅ PR description explains the change and motivation

## Release Process

Releases are managed by maintainers:

1. **Version bump**: Update `package.json` and create `VERSION` file
2. **Changelog**: Update `CHANGELOG.md` with new features/fixes
3. **Tag creation**: Create and push version tag
4. **Branch merge**: Merge `develop` → `release`

## Getting Help

- 📖 **Documentation**: [./docs/](../docs/)
- 🐛 **Issues**: [GitHub Issues](https://github.com/Kompkit/KompKit/issues)
- 💬 **Discussions**: [GitHub Discussions](https://github.com/Kompkit/KompKit/discussions)
- 📧 **Maintainers**: Open an issue for direct contact

## Code of Conduct

This project follows the [Contributor Covenant Code of Conduct](https://www.contributor-covenant.org/). Please be respectful and inclusive in all interactions.
