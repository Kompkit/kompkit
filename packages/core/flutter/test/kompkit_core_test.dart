import 'package:flutter_test/flutter_test.dart';
import '../lib/kompkit_core.dart';

void main() {
  group('KompKit Core Integration Tests', () {
    test('should export all utilities', () {
      // Test that all utilities are accessible through the main export
      expect(debounce, isA<Function>());
      expect(debounceVoid, isA<Function>());
      expect(isEmail, isA<Function>());
      expect(formatCurrency, isA<Function>());
    });

    test('should work together in a realistic scenario', () async {
      // Simulate a search input with debounced email validation and currency formatting
      var searchResults = <String>[];
      
      final debouncedSearch = debounce<String>((String query) {
        if (isEmail(query)) {
          searchResults.add('Found user: $query');
        } else {
          searchResults.add('Invalid email: $query');
        }
      }, const Duration(milliseconds: 100));

      // Test the integration
      debouncedSearch('invalid-email');
      debouncedSearch('user@example.com');
      
      await Future.delayed(const Duration(milliseconds: 150));
      
      expect(searchResults.length, 1);
      expect(searchResults.first, 'Found user: user@example.com');
      
      // Test currency formatting
      final price = formatCurrency(99.99, currency: 'USD', locale: 'en_US');
      expect(price, contains('99.99'));
    });
  });
}
