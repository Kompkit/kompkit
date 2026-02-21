# Getting started

KompKit Core is a small cross-platform utility library for Web (TypeScript), Android (Kotlin), and Flutter (Dart).

Status: `V0.3.1-alpha`.

## Install

### Web (npm)

```bash
npm i kompkit-core
```

> [npmjs.com/package/kompkit-core](https://www.npmjs.com/package/kompkit-core)

### Flutter / Dart (pub.dev)

Add to your `pubspec.yaml`:

```yaml
dependencies:
  kompkit_core: ^0.3.1-alpha.0
```

Then run:

```bash
flutter pub get
```

> [pub.dev/packages/kompkit_core](https://pub.dev/packages/kompkit_core)

### Android (Gradle) — Local only

> Not yet published to Maven. Use a local project reference for now.

```kotlin
dependencies {
    implementation(project(":kompkit-core"))
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-core:1.10.2")
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

| Utility          | Description                                              |
| ---------------- | -------------------------------------------------------- |
| `debounce`       | Debounce a function call by a delay.                     |
| `isEmail`        | Validate a string with a basic email regex.              |
| `formatCurrency` | Format numbers into a localized currency string.         |
| `clamp`          | Constrain a number within an inclusive [min, max] range. |

Next: read the detailed guides for [Web](./web.md), [Android](./android.md), [Flutter](./flutter.md), and the [Recipes](./recipes.md).
