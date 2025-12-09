import 'package:flutter_test/flutter_test.dart';
import '../lib/src/format.dart';

void main() {
  group('formatCurrency', () {
    test('should format currency with default EUR and es_ES locale', () {
      final result = formatCurrency(1234.56);
      expect(result, contains('1.234,56'));
      expect(result, contains('EUR'));
    });

    test('should format USD currency with en_US locale', () {
      final result = formatCurrency(1234.56, currency: 'USD', locale: 'en_US');
      expect(result, contains('1,234.56'));
      expect(result, contains('USD'));
    });

    test('should format JPY currency with ja_JP locale', () {
      final result = formatCurrency(1000, currency: 'JPY', locale: 'ja_JP');
      expect(result, contains('1,000'));
      expect(result, contains('JPY'));
    });

    test('should handle zero amounts', () {
      final result = formatCurrency(0);
      expect(result, contains('0'));
    });

    test('should handle negative amounts', () {
      final result = formatCurrency(-100.50, currency: 'USD', locale: 'en_US');
      expect(result, contains('100.50'));
      expect(result.contains('-') || result.contains('('), true);
    });

    test('should handle large amounts', () {
      final result = formatCurrency(1000000.99, currency: 'USD', locale: 'en_US');
      expect(result, contains('1,000,000.99'));
    });

    test('should handle decimal amounts', () {
      final result = formatCurrency(0.99, currency: 'USD', locale: 'en_US');
      expect(result, contains('0.99'));
    });

    test('should handle integer amounts', () {
      final result = formatCurrency(100, currency: 'USD', locale: 'en_US');
      expect(result, contains('100'));
    });

    test('should fallback gracefully for unsupported locale/currency combinations', () {
      // This should not throw an error and should return some formatted string
      final result = formatCurrency(100, currency: 'XYZ', locale: 'invalid_locale');
      expect(result, isA<String>());
      expect(result.isNotEmpty, true);
    });
  });
}
