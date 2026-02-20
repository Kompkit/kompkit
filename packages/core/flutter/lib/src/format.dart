import 'package:intl/intl.dart';

/// Formats a number as a localized currency string using BCP 47 locale identifiers.
///
/// Accepts BCP 47 locale strings (e.g., `"en-US"`, `"es-ES"`, `"ja-JP"`).
/// The `intl` package uses underscore-separated locale identifiers internally;
/// hyphens are converted automatically.
///
/// Throws [ArgumentError] if [currency] is not a valid ISO 4217 code or
/// [locale] is not a recognized locale — consistent with TypeScript and Kotlin behavior.
///
/// **Parameters:**
/// - [amount] - The numeric amount to format (supports both int and double)
/// - [currency] - ISO 4217 currency code (e.g., "USD", "EUR", "JPY"). Defaults to "EUR"
/// - [locale] - BCP 47 locale string (e.g., "en-US", "es-ES", "ja-JP"). Defaults to "en-US"
///
/// **Returns:** A formatted currency string according to the specified locale
/// @throws [ArgumentError] if [currency] or [locale] is invalid.
///
/// **Example:**
/// ```dart
/// formatCurrency(1234.56);                                    // "$1,234.56" (en-US default)
/// formatCurrency(1234.56, currency: "EUR", locale: "es-ES"); // "1.234,56 €"
/// formatCurrency(1000, currency: "JPY", locale: "ja-JP");    // "¥1,000"
/// formatCurrency(999.99, currency: "GBP", locale: "en-GB");  // "£999.99"
/// formatCurrency(-50.25, currency: "USD", locale: "en-US");  // "-$50.25"
/// ```
String formatCurrency(
  num amount, {
  String currency = "EUR",
  String locale = "en-US",
}) {
  // Normalize BCP 47 hyphen separator to the underscore format expected by intl.
  final normalizedLocale = locale.replaceAll('-', '_');
  try {
    final formatter = NumberFormat.currency(
      locale: normalizedLocale,
      name: currency,
    );
    return formatter.format(amount);
  } on ArgumentError {
    rethrow;
  } catch (e) {
    throw ArgumentError('Invalid currency "$currency" or locale "$locale": $e');
  }
}
