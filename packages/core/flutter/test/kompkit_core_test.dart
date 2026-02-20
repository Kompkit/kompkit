import 'package:flutter_test/flutter_test.dart';
import '../lib/kompkit_core.dart';

void main() {
  group('KompKit Core — exports', () {
    test('all utilities are accessible through the main export', () {
      expect(debounce, isA<Function>());
      expect(isEmail, isA<Function>());
      expect(formatCurrency, isA<Function>());
    });

    test('debounce returns a Debounced instance', () {
      final fn = debounce<String>((String v) {});
      expect(fn, isA<Debounced<String>>());
    });
  });

  group('KompKit Core — integration', () {
    test('debounce + isEmail work together', () async {
      final results = <String>[];

      final debouncedSearch = debounce<String>((String query) {
        results.add(isEmail(query) ? 'valid: $query' : 'invalid: $query');
      }, const Duration(milliseconds: 100));

      debouncedSearch('not-an-email');
      debouncedSearch('user@example.com');

      await Future.delayed(const Duration(milliseconds: 150));

      expect(results.length, 1);
      expect(results.first, 'valid: user@example.com');
    });

    test('cancel() stops pending debounced call', () async {
      final results = <String>[];

      final debouncedSearch = debounce<String>((String query) {
        results.add(query);
      }, const Duration(milliseconds: 100));

      debouncedSearch('user@example.com');
      debouncedSearch.cancel();

      await Future.delayed(const Duration(milliseconds: 150));
      expect(results, isEmpty);
    });

    test('formatCurrency uses en-US default', () {
      final price = formatCurrency(99.99, currency: 'USD', locale: 'en-US');
      expect(price, contains('99.99'));
      expect(price, contains('USD'));
    });
  });
}
