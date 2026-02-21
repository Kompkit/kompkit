# KompKit Core - Flutter/Dart

Cross-platform utility functions for Flutter and Dart applications. Part of the [KompKit ecosystem](../../../README.md) with identical APIs across Web, Android, and Flutter platforms.

## Quick Start

Add to your `pubspec.yaml`:

```yaml
dependencies:
  kompkit_core: ^0.3.1-alpha.0
```

> Published on [pub.dev/packages/kompkit_core](https://pub.dev/packages/kompkit_core)

Import and use:

```dart
import 'package:kompkit_core/kompkit_core.dart';

// Debounce function calls
final search = debounce<String>((query) => print('Searching: $query'),
                                const Duration(milliseconds: 300));

// Validate emails
print(isEmail('user@example.com')); // true

// Format currency
print(formatCurrency(1234.56)); // "$1,234.56" (en-US / USD default)

// Clamp a value
print(clamp(15.0, 0.0, 10.0)); // 10.0

// Throttle a function
final onScroll = throttle<double>((offset) => print(offset),
                                  const Duration(milliseconds: 200));
onScroll.cancel(); // reset state
```

## Documentation

- **[Flutter Guide](../../../docs/flutter.md)** - Detailed usage examples and Flutter widgets
- **[Main README](../../../README.md)** - Project overview and cross-platform APIs
- **[API Reference](../../../docs/api/)** - Complete API documentation

## Testing

```bash
flutter test  # Flutter projects
dart test     # Dart-only projects
```

## Platform Support

Works on all Flutter platforms (iOS, Android, Web, Desktop) and server-side Dart.
