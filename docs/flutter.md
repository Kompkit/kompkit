# Flutter/Dart Guide

This guide covers using KompKit Core utilities in Flutter and Dart applications.

## Installation

### Flutter Projects

Add KompKit Core to your `pubspec.yaml`:

```yaml
dependencies:
  kompkit_core:
    path: path/to/KompKit/packages/core/flutter
```

Then run:

```bash
flutter pub get
```

### Dart Projects

For server-side Dart projects, add to your `pubspec.yaml`:

```yaml
dependencies:
  kompkit_core:
    path: path/to/KompKit/packages/core/flutter
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
// Default (EUR, es_ES locale)
print(formatCurrency(1234.56)); // "1.234,56 €"

// US Dollar
print(formatCurrency(1234.56, currency: 'USD', locale: 'en_US')); // "$1,234.56"

// Japanese Yen
print(formatCurrency(1000, currency: 'JPY', locale: 'ja_JP')); // "¥1,000"

// British Pound
print(formatCurrency(999.99, currency: 'GBP', locale: 'en_GB')); // "£999.99"
```

#### Flutter Widget Example

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
  _DemoScreenState createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  final _emailController = TextEditingController();
  final _priceController = TextEditingController();
  late final Function(String) _debouncedEmailCheck;
  
  String _emailStatus = '';
  String _formattedPrice = '';
  
  @override
  void initState() {
    super.initState();
    _debouncedEmailCheck = debounce<String>((String email) {
      setState(() {
        _emailStatus = isEmail(email) ? 'Valid email ✅' : 'Invalid email ❌';
      });
    }, const Duration(milliseconds: 300));
  }
  
  void _formatPrice() {
    final price = double.tryParse(_priceController.text) ?? 0;
    setState(() {
      _formattedPrice = formatCurrency(price, currency: 'USD', locale: 'en_US');
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('KompKit Demo')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              onChanged: _debouncedEmailCheck,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Enter email address',
              ),
            ),
            SizedBox(height: 8),
            Text(_emailStatus),
            SizedBox(height: 24),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Price',
                hintText: 'Enter price',
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: _formatPrice,
              child: Text('Format as Currency'),
            ),
            SizedBox(height: 8),
            Text(_formattedPrice, style: TextStyle(fontSize: 18)),
          ],
        ),
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

## Next Steps

- Check out the [API Reference](./api/flutter/) for detailed documentation
- See [Examples](./examples/flutter/) for more usage patterns
- Read the [Contributing Guide](./CONTRIBUTING.md) to contribute improvements
