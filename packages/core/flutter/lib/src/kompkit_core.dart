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
/// - **Zero dependencies**: Minimal external dependencies (only `intl` for formatting)
/// - **Comprehensive testing**: 100% test coverage
/// - **Rich documentation**: Detailed API docs with examples
/// 
/// ## Available Utilities
/// 
/// - [debounce] - Delay function execution with automatic cancellation
/// - [debounceVoid] - Debounce functions with no parameters
/// - [isEmail] - Email address validation using regex patterns
/// - [formatCurrency] - Localized currency formatting
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
/// // Format currency
/// print(formatCurrency(1234.56, currency: 'USD', locale: 'en_US')); // "$1,234.56"
/// ```
library kompkit_core;

export 'debounce.dart';
export 'validate.dart';
export 'format.dart';
