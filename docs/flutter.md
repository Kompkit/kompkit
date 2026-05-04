# Flutter/Dart Guide

This guide covers using KompKit Core utilities in Flutter and Dart applications.

Status: `v0.4.1-alpha.0`.

## Installation

### Flutter Projects

Add KompKit Core to your `pubspec.yaml`:

```yaml
dependencies:
  kompkit_core: ^0.4.1-alpha.0
```

Then run:

```bash
flutter pub get
```

> Published on [pub.dev/packages/kompkit_core](https://pub.dev/packages/kompkit_core)

### Dart Projects

For server-side Dart projects, add to your `pubspec.yaml`:

```yaml
dependencies:
  kompkit_core: ^0.4.1-alpha.0
```

Then run:

```bash
dart pub get
```

## Usage

Import the package in your Dart files:

```dart
import 'package:kompkit_core/kompkit_core.dart';
```

## Utilities

### Debounce

Delay function execution to prevent excessive calls:

```dart
// For functions with parameters
final searchDebounced = debounce<String>((String query) {
  print('Searching for: $query');
  // Perform search logic here
}, const Duration(milliseconds: 300));

// Usage
searchDebounced('flutter');
searchDebounced('dart'); // Previous call is cancelled

// For void functions (no parameters)
final saveDebounced = debounceVoid(() {
  print('Saving data...');
  // Perform save logic here
}, const Duration(milliseconds: 500));

// Usage
saveDebounced();
```

#### Flutter Widget Example

```dart
class SearchWidget extends StatefulWidget {
  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  late final Function(String) _debouncedSearch;

  @override
  void initState() {
    super.initState();
    _debouncedSearch = debounce<String>((String query) {
      // Perform search API call
      _performSearch(query);
    }, const Duration(milliseconds: 300));
  }

  void _performSearch(String query) {
    // Your search logic here
    print('Searching for: $query');
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: _debouncedSearch,
      decoration: InputDecoration(
        hintText: 'Search...',
      ),
    );
  }
}
```

### Email Validation

Validate email addresses with a simple function:

```dart
// Basic validation
print(isEmail('user@example.com')); // true
print(isEmail('invalid-email'));    // false

// Handles whitespace
print(isEmail('  test@domain.org  ')); // true (trimmed)

// Form validation example
String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Email is required';
  }
  if (!isEmail(value)) {
    return 'Please enter a valid email';
  }
  return null;
}

// Usage in Flutter Form
TextFormField(
  validator: validateEmail,
  decoration: InputDecoration(
    labelText: 'Email',
  ),
)
```

### Currency Formatting

Format numbers as localized currency strings:

```dart
// Default (USD, en-US locale)
print(formatCurrency(1234.56)); // "$1,234.56"

// Euro
print(formatCurrency(1234.56, currency: 'EUR', locale: 'es-ES')); // "1.234,56 EUR"

// Japanese Yen
print(formatCurrency(1000, currency: 'JPY', locale: 'ja-JP')); // "JPY1,000"

// British Pound
print(formatCurrency(999.99, currency: 'GBP', locale: 'en-GB')); // "GBP999.99"
```

### Clamp

Constrain a number within an inclusive `[min, max]` range:

```dart
clamp(5.0, 0.0, 10.0)   // 5.0
clamp(-3.0, 0.0, 10.0)  // 0.0
clamp(15.0, 0.0, 10.0)  // 10.0
```

Useful for bounding any user-controlled numeric value:

```dart
final opacity = clamp(userInput, 0.0, 1.0);
final page = clamp(requestedPage, 1.0, totalPages.toDouble());
final scrollOffset = clamp(rawOffset, 0.0, maxScrollExtent);
```

#### Flutter Widget Example

```dart
class VolumeSlider extends StatefulWidget {
  @override
  State<VolumeSlider> createState() => _VolumeSliderState();
}

class _VolumeSliderState extends State<VolumeSlider> {
  double _volume = 50;

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: _volume,
      min: 0,
      max: 100,
      onChanged: (raw) => setState(() {
        _volume = clamp(raw, 0.0, 100.0);
      }),
    );
  }
}
```

### Throttle

Limit a function to execute at most once per wait duration. The first call executes immediately; subsequent calls within the wait period are ignored.

```dart
final onScroll = throttle<void>((_) {
  print('scroll event');
}, const Duration(milliseconds: 200));

onScroll(null);    // executes immediately
onScroll(null);    // ignored within 200ms
onScroll.cancel(); // reset state (e.g. in dispose())
```

Unlike `debounce` (which waits until calls stop), `throttle` fires immediately then enforces a cooldown — ideal for scroll, sensor, and pointer events where you want immediate feedback at a controlled rate.

Useful for scroll listeners, resize handlers, or any high-frequency event:

```dart
final onResize = throttle<Size>((size) {
  setState(() => _size = size);
}, const Duration(milliseconds: 100));
```

#### Flutter Widget Example — Throttled scroll tracker

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
        Text('Scroll offset: ${_offset.toStringAsFixed(1)}'),
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

#### Flutter Widget Example — formatCurrency display

```dart
class PriceDisplay extends StatelessWidget {
  final double price;
  final String currency;
  final String locale;

  const PriceDisplay({
    Key? key,
    required this.price,
    this.currency = 'USD',
    this.locale = 'en_US',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      formatCurrency(price, currency: currency, locale: locale),
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }
}

// Usage
PriceDisplay(price: 29.99, currency: 'USD', locale: 'en_US')
```

## Complete Example

Here's a complete Flutter app example using all KompKit utilities:

```dart
import 'package:flutter/material.dart';
import 'package:kompkit_core/kompkit_core.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KompKit Demo',
      home: DemoScreen(),
    );
  }
}

class DemoScreen extends StatefulWidget {
  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  final _emailController = TextEditingController();
  final _priceController = TextEditingController();
  final _scrollController = ScrollController();

  late final Debounced<String> _debouncedEmailCheck;
  late final Throttled<double> _throttledScroll;

  String _emailStatus = '';
  String _formattedPrice = '';
  double _volume = 50;
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();

    _debouncedEmailCheck = debounce<String>((email) {
      setState(() {
        _emailStatus = isEmail(email) ? 'Valid email ✅' : 'Invalid email ❌';
      });
    }, const Duration(milliseconds: 300));

    _throttledScroll = throttle<double>(
      (offset) => setState(() => _scrollOffset = offset),
      const Duration(milliseconds: 200),
    );

    _scrollController.addListener(
      () => _throttledScroll(_scrollController.offset),
    );
  }

  @override
  void dispose() {
    _debouncedEmailCheck.cancel();
    _throttledScroll.cancel();
    _scrollController.dispose();
    _emailController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _formatPrice() {
    final raw = double.tryParse(_priceController.text) ?? 0;
    final price = clamp(raw, 0.0, 1000000.0);
    setState(() {
      _formattedPrice = formatCurrency(price, currency: 'USD', locale: 'en_US');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('KompKit Demo')),
      body: Row(
        children: [
          // Left panel — form controls
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // debounce: email validation
                  TextField(
                    controller: _emailController,
                    onChanged: _debouncedEmailCheck.call,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter email address',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(_emailStatus),
                  const SizedBox(height: 24),

                  // formatCurrency + clamp: price formatting
                  TextField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Price (0 – 1,000,000)',
                      hintText: 'Enter price',
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _formatPrice,
                    child: const Text('Format as Currency'),
                  ),
                  const SizedBox(height: 8),
                  Text(_formattedPrice, style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 24),

                  // clamp: volume slider
                  Text('Volume: ${_volume.toStringAsFixed(0)}'),
                  Slider(
                    value: _volume,
                    min: 0,
                    max: 100,
                    onChanged: (raw) => setState(() {
                      _volume = clamp(raw, 0.0, 100.0);
                    }),
                  ),

                  // throttle: scroll offset display
                  const SizedBox(height: 16),
                  Text('Scroll offset: ${_scrollOffset.toStringAsFixed(1)}'),
                ],
              ),
            ),
          ),

          // Right panel — scrollable list (throttled scroll tracking)
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: 100,
              itemBuilder: (_, i) => ListTile(title: Text('Item $i')),
            ),
          ),
        ],
      ),
    );
  }
}
```

## Testing

Run tests for your Flutter project:

```bash
flutter test
```

For Dart-only projects:

```bash
dart test
```

## Platform Support

KompKit Core for Flutter/Dart works on:

- ✅ Flutter iOS
- ✅ Flutter Android
- ✅ Flutter Web
- ✅ Flutter Desktop (Windows, macOS, Linux)
- ✅ Dart VM (Server-side)
- ✅ Dart Web (compiled to JavaScript)

## Performance Notes

- **Debounce**: Uses Dart's `Timer` class for efficient scheduling
- **Email Validation**: Compiled regex for fast validation
- **Currency Formatting**: Leverages Dart's `intl` package for optimal localization
- **Clamp**: Pure arithmetic — zero overhead
- **Throttle**: Uses Dart's `Timer` class — same mechanism as debounce

## Next Steps

- Check out the [API Reference](./api/flutter/) for detailed documentation
- See [Examples](./examples/flutter/) for more usage patterns
- Read the [Contributing Guide](./CONTRIBUTING.md) to contribute improvements
