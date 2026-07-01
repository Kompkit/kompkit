# KompKit Core — Flutter / Dart

Cross-platform utility functions for Flutter and Dart applications. Part of the [KompKit ecosystem](../../../README.md) with identical APIs across Web (TypeScript), Android (Kotlin), and Flutter (Dart).

> **⚠️ Alpha**: APIs may change before `1.0.0`. Pin to an exact version in production.

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  kompkit_core: ^0.4.1-alpha.0
```

Then run:

```bash
flutter pub get
```

> Published on [pub.dev/packages/kompkit_core](https://pub.dev/packages/kompkit_core)

## Quick Start

```dart
import 'package:kompkit_core/kompkit_core.dart';

// Debounce — delay until calls stop
final onSearch = debounce<String>(
  (query) => print('Searching: $query'),
  const Duration(milliseconds: 300),
);

// Email validation
print(isEmail('user@example.com')); // true
print(isEmail('invalid@'));         // false

// Currency formatting (en-US / USD default; intl renders the ISO code, not a symbol)
print(formatCurrency(1234.56));                        // "USD1,234.56"
print(formatCurrency(1234.56, currency: 'EUR', locale: 'es-ES')); // "1.234,56 EUR"

// Clamp a value to a range
print(clamp(15.0, 0.0, 10.0)); // 10.0

// Throttle — at most once per interval
final onScroll = throttle<double>(
  (offset) => print('offset: $offset'),
  const Duration(milliseconds: 200),
);
```

---

## API Reference

### `debounce`

Delays execution until calls stop for the given `wait` duration. The last call within the wait period executes; all earlier ones are cancelled.

```dart
Debounced<T> debounce<T>(
  void Function(T) action, [
  Duration wait = const Duration(milliseconds: 250),
])
```

```dart
final onSearch = debounce<String>(
  (query) => fetchResults(query),
  const Duration(milliseconds: 300),
);

onSearch('k');
onSearch('ko');
onSearch('kompkit'); // only this executes, after 300ms of inactivity

onSearch.cancel();   // discard pending call — call in dispose()
```

**Flutter `StatefulWidget` example:**

```dart
class SearchWidget extends StatefulWidget {
  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  late final Debounced<String> _onSearch;

  @override
  void initState() {
    super.initState();
    _onSearch = debounce<String>(
      (query) => setState(() { /* update results */ }),
      const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _onSearch.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(onChanged: _onSearch.call);
  }
}
```

---

### `throttle`

Limits execution to at most once per `wait` duration. The first call executes immediately; subsequent calls within the cooldown are ignored.

```dart
Throttled<T> throttle<T>(void Function(T) action, Duration wait)
```

```dart
final onScroll = throttle<double>(
  (offset) => print('scroll: $offset'),
  const Duration(milliseconds: 200),
);

onScroll(0.0);   // executes immediately
onScroll(50.0);  // ignored — within 200ms cooldown
onScroll.cancel(); // reset state — call in dispose()
```

**Flutter `StatefulWidget` with `ScrollController`:**

```dart
class ScrollTracker extends StatefulWidget {
  @override
  State<ScrollTracker> createState() => _ScrollTrackerState();
}

class _ScrollTrackerState extends State<ScrollTracker> {
  final _controller = ScrollController();
  late final Throttled<double> _onScroll;
  double _offset = 0;

  @override
  void initState() {
    super.initState();
    _onScroll = throttle<double>(
      (offset) => setState(() => _offset = offset),
      const Duration(milliseconds: 200),
    );
    _controller.addListener(() => _onScroll(_controller.offset));
  }

  @override
  void dispose() {
    _onScroll.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Offset: ${_offset.toStringAsFixed(1)}'),
        Expanded(
          child: ListView.builder(
            controller: _controller,
            itemCount: 100,
            itemBuilder: (_, i) => ListTile(title: Text('Item $i')),
          ),
        ),
      ],
    );
  }
}
```

---

### `retry`

Executes an async function with automatic retries and exponential backoff. On each failure the delay grows exponentially, capped at `maxDelay`. If all attempts fail, the last error is rethrown.

```dart
Future<T> retry<T>(
  Future<T> Function() fn, [
  RetryOptions options = const RetryOptions(),
])

class RetryOptions {
  final int maxAttempts;       // default 3
  final Duration baseDelay;    // default 1s
  final Duration maxDelay;     // default 30s
  final double multiplier;     // default 2.0
  final bool Function(Object)? retryIf;
}
```

```dart
// Default: 3 attempts, 1s base delay, ×2 multiplier
final data = await retry(() => httpClient.get('/api/data'));

// Custom options
final result = await retry(
  () => unreliableCall(),
  const RetryOptions(
    maxAttempts: 5,
    baseDelay: Duration(milliseconds: 500),
  ),
);

// Conditional retry — skip auth errors
await retry(
  () => fetchWithAuth(),
  RetryOptions(retryIf: (e) => e is! AuthException),
);
```

**Flutter example — loading data with retry:**

```dart
class _DataWidgetState extends State<DataWidget> {
  Future<Data>? _future;

  @override
  void initState() {
    super.initState();
    _future = retry(
      () => repository.fetchData(),
      const RetryOptions(maxAttempts: 3, baseDelay: Duration(seconds: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Data>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasData) return DataView(data: snapshot.data!);
        if (snapshot.hasError) return ErrorView(error: snapshot.error!);
        return const CircularProgressIndicator();
      },
    );
  }
}
```

---

### `isEmail`

Validates an email address.

```dart
bool isEmail(String value)
```

```dart
isEmail('user@example.com')   // true
isEmail('invalid@')           // false
isEmail('  user@domain.org ') // true (trimmed)
```

---

### `formatCurrency`

Formats a number as a localized currency string.

```dart
String formatCurrency(double amount, {String currency = 'USD', String locale = 'en-US'})
```

```dart
formatCurrency(1234.56)                              // "USD1,234.56"
formatCurrency(1234.56, currency: 'EUR', locale: 'es-ES') // "1.234,56 EUR"
formatCurrency(1234.56, currency: 'JPY', locale: 'ja-JP') // "JPY1,235"
```

- Accepts BCP 47 locale strings; normalizes `en-US` → `en_US` for the `intl` package internally
- The `intl` package renders the **ISO 4217 code** (e.g. `USD`, `EUR`) rather than a localized symbol (`$`, `€`) — this is a documented [platform divergence](../../../docs/ARCHITECTURE.md#api-parity-contract)
- Throws on invalid `currency` codes

---

### `clamp`

Constrains a value within an inclusive `[min, max]` range.

```dart
double clamp(double value, double min, double max)
```

```dart
clamp(5.0, 0.0, 10.0)   // 5.0
clamp(-3.0, 0.0, 10.0)  // 0.0
clamp(15.0, 0.0, 10.0)  // 10.0
```

```dart
final opacity = clamp(userInput, 0.0, 1.0);
final volume  = clamp(rawVolume, 0.0, 100.0);
```

---

## Lifecycle and cancellation

Both `debounce` and `throttle` return objects with a `cancel()` method. **Always call `cancel()` in `dispose()`** to prevent callbacks from firing after a widget is removed:

```dart
@override
void dispose() {
  _debouncedSearch.cancel();
  _throttledScroll.cancel();
  super.dispose();
}
```

---

## Platform support

| Platform                                | Supported |
| --------------------------------------- | --------- |
| Flutter iOS                             | ✅        |
| Flutter Android                         | ✅        |
| Flutter Web                             | ✅        |
| Flutter Desktop (Windows, macOS, Linux) | ✅        |
| Dart VM (server-side)                   | ✅        |
| Dart Web (compiled to JS)               | ✅        |

**Compatibility:** Flutter 3.0+ · Dart SDK ≥ 3.0.0

---

## Documentation

- **[Flutter Guide](../../../docs/flutter.md)** — Detailed usage with complete widget examples
- **[Main README](../../../README.md)** — Project overview and cross-platform APIs
- **[Architecture](../../../docs/ARCHITECTURE.md)** — API parity contract and platform differences
- **[Recipes](../../../docs/recipes.md)** — Real-world usage patterns across all platforms
- **[API Reference](../../../docs/api/flutter/)** — DartDoc generated documentation _(generated locally via `dart doc`)_

## Testing

```bash
flutter test        # Flutter projects
dart test           # Dart-only projects
flutter test --coverage  # with coverage report
```
