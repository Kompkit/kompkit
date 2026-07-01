/// KompKit Core - Cross-platform utilities for Flutter and Dart
/// 
/// A lightweight utility library providing essential functions for Flutter
/// and Dart applications. Part of the KompKit ecosystem with identical APIs
/// across Web (TypeScript), Android (Kotlin), and Flutter (Dart) platforms.
/// 
/// ## Features
/// 
/// - **Cross-platform compatibility**: Identical APIs across all platforms
/// - **Type safety**: Full Dart null safety support
/// - **Minimal dependencies**: only `intl` (for `formatCurrency`)
/// - **Comprehensive testing**: extensive unit tests
/// - **Rich documentation**: Detailed API docs with examples
/// 
/// ## Available Utilities
/// 
/// - [debounce] - Delay function execution with automatic cancellation
/// - [throttle] - Rate-limit function execution to at most once per interval
/// - [retry] - Automatic retries with exponential backoff
/// - [isEmail] - Email address validation using regex patterns
/// - [formatCurrency] - Localized currency formatting
/// - [clamp] - Constrain a value to a `[min, max]` range
/// 
/// ## Quick Start
/// 
/// ```dart
/// import 'package:kompkit_core/kompkit_core.dart';
/// 
/// // Debounce a search function
/// final search = debounce<String>((query) => print('Searching: $query'), 
///                                 const Duration(milliseconds: 300));
/// 
/// // Validate email addresses
/// print(isEmail('user@example.com')); // true
/// 
/// // Format currency (intl renders the ISO code, not a symbol)
/// print(formatCurrency(1234.56, currency: 'USD', locale: 'en_US')); // "USD1,234.56"
/// ```
library kompkit_core;

export 'src/debounce.dart';
export 'src/validate.dart';
export 'src/format.dart';
export 'src/clamp.dart';
export 'src/throttle.dart';
export 'src/retry.dart';
