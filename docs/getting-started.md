# Getting started

KompKit Core is a small cross-platform utility library for Web (TypeScript) and Android (Kotlin).

Status: `V0.1.0-alpha`.

## Install

### Web (React/Vue)
```bash
npm i @kompkit/core
```

### Android (Gradle)
Add the dependency to your module build file:
```kotlin
dependencies {
    implementation("com.kompkit:core:<version>")
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-core:1.8.1")
}
```

## Build and test locally
Run from the repository root:
```bash
# Build web package
npm run build

# Run tests for web and android
npm run test
```

## Utilities

| Utility          | Description                                      |
|------------------|--------------------------------------------------|
| `debounce`       | Debounce a function call by a delay.             |
| `isEmail`        | Validate a string with a basic email regex.      |
| `formatCurrency` | Format numbers into a localized currency string. |

Next: read the detailed guides for [Web](./web.md), [Android](./android.md), and the [Recipes](./recipes.md).
