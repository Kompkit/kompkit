import 'package:intl/intl.dart';

/// Formats a number as a localized currency string.
/// 
/// This function uses the Dart `intl` package to format numbers according to
/// the specified currency and locale conventions. It handles decimal places,
/// thousands separators, and currency symbols based on the locale.
/// 
/// The function automatically determines the appropriate currency symbol and
/// formatting rules for the given locale. If an unsupported locale/currency
/// combination is provided, it falls back gracefully.
/// 
/// **Parameters:**
/// - [amount] - The numeric amount to format (supports both int and double)
/// - [currency] - The ISO 4217 currency code (e.g., "USD", "EUR", "JPY"). Defaults to "EUR"
/// - [locale] - The locale identifier (e.g., "en_US", "es_ES", "ja_JP"). Defaults to "es_ES"
/// 
/// **Returns:** A formatted currency string according to the specified locale
/// 
/// **Example:**
/// ```dart
/// // Default (EUR, Spanish locale)
/// formatCurrency(1234.56);                                    // "1.234,56 €"
/// 
/// // US Dollar
/// formatCurrency(1234.56, currency: "USD", locale: "en_US");  // "$1,234.56"
/// 
/// // Japanese Yen (no decimal places)
/// formatCurrency(1000, currency: "JPY", locale: "ja_JP");     // "¥1,000"
/// 
/// // British Pound
/// formatCurrency(999.99, currency: "GBP", locale: "en_GB");   // "£999.99"
/// 
/// // Negative amounts
/// formatCurrency(-50.25, currency: "USD", locale: "en_US");   // "-$50.25"
/// ```
String formatCurrency(
  num amount, {
  String currency = "EUR",
  String locale = "es_ES",
}) {
  try {
    final formatter = NumberFormat.currency(
      locale: locale,
      name: currency,
    );
    return formatter.format(amount);
  } catch (e) {
    // Fallback to a basic format if locale/currency combination is not supported
    try {
      final fallbackFormatter = NumberFormat.currency(
        locale: 'en_US',
        name: currency,
      );
      return fallbackFormatter.format(amount);
    } catch (e2) {
      // Ultimate fallback: just return the number with currency code
      return '$currency${amount.toStringAsFixed(2)}';
    }
  }
}
