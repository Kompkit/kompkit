import 'package:flutter_test/flutter_test.dart';
import '../lib/src/format.dart';

void main() {
  group('formatCurrency', () {
    test('default locale is en-US with EUR', () {
      final result = formatCurrency(1234.56);
      expect(result, contains('1,234.56'));
      expect(result, contains('EUR'));
    });

    test('formats USD with en-US locale using BCP 47 string', () {
      final result = formatCurrency(1234.56, currency: 'USD', locale: 'en-US');
      expect(result, contains('1,234.56'));
      expect(result, contains('USD'));
    });

    test('formats EUR with es-ES locale using BCP 47 string', () {
      final result = formatCurrency(1234.56, currency: 'EUR', locale: 'es-ES');
      expect(result, contains('1.234,56'));
      expect(result, contains('EUR'));
    });

    test('formats JPY with ja-JP locale using BCP 47 string', () {
      final result = formatCurrency(1000, currency: 'JPY', locale: 'ja-JP');
      expect(result, contains('1,000'));
      expect(result, contains('JPY'));
    });

    test('handles zero', () {
      final result = formatCurrency(0, currency: 'USD', locale: 'en-US');
      expect(result, contains('0'));
    });

    test('handles negative amounts', () {
      final result = formatCurrency(-100.50, currency: 'USD', locale: 'en-US');
      expect(result, contains('100.50'));
      expect(result.contains('-') || result.contains('('), true);
    });

    test('handles large amounts', () {
      final result = formatCurrency(1000000.99, currency: 'USD', locale: 'en-US');
      expect(result, contains('1,000,000.99'));
    });

    test('handles decimal amounts', () {
      final result = formatCurrency(0.99, currency: 'USD', locale: 'en-US');
      expect(result, contains('0.99'));
    });

    test('throws ArgumentError for invalid currency code', () {
      expect(
        () => formatCurrency(100, currency: 'INVALID', locale: 'en-US'),
        throwsArgumentError,
      );
    });

    test('throws ArgumentError for invalid locale', () {
      expect(
        () => formatCurrency(100, currency: 'USD', locale: 'not-a-real-locale-xyz'),
        throwsArgumentError,
      );
    });
  });
}
