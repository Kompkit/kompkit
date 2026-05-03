# Getting started

KompKit Core is a small cross-platform utility library for Web (TypeScript), Android (Kotlin), and Flutter (Dart).

Status: `0.4.0-alpha.0`.

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
  kompkit_core: ^0.4.0-alpha.0
```

Then run:

```bash
flutter pub get
```

> [pub.dev/packages/kompkit_core](https://pub.dev/packages/kompkit_core)

### Android / Kotlin (Maven Central)

Add to your `app/build.gradle.kts`:

```kotlin
dependencies {
    implementation("com.kompkit:kompkit-core:0.4.0-alpha.0")
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.10.2")
}
```

> See [packages/core/android/README.md](../packages/core/android/README.md) for full setup.

## Build and test locally

Run from the repository root:

```bash
# Build web package
npm run build

# Run web tests
npm run test:web

# Run Android/Kotlin tests
cd packages/core/android && ./gradlew test

# Run Flutter tests
cd packages/core/flutter && flutter test
```

## Utilities

| Utility          | Description                                               |
| ---------------- | --------------------------------------------------------- |
| `debounce`       | Debounce a function call by a delay.                      |
| `isEmail`        | Validate a string with a basic email regex.               |
| `formatCurrency` | Format numbers into a localized currency string.          |
| `clamp`          | Constrain a number within an inclusive [min, max] range.  |
| `throttle`       | Limit a function to execute at most once per wait period. |

---

> **⚠️ Alpha**: APIs may change before `1.0.0`. Pin to an exact version in production.

Next: read the detailed guides for [Web](./web.md), [Android](./android.md), [Flutter](./flutter.md), and the [Recipes](./recipes.md).
