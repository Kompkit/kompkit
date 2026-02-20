import 'package:flutter_test/flutter_test.dart';
import '../lib/src/validate.dart';

void main() {
  group('isEmail', () {
    test('returns true for valid email addresses', () {
      expect(isEmail('user@example.com'), true);
      expect(isEmail('test.email+tag@domain.org'), true);
      expect(isEmail('a@b.co'), true);
    });

    test('returns false for invalid email addresses', () {
      expect(isEmail('invalid@'), false);
      expect(isEmail('@invalid.com'), false);
      expect(isEmail('nodomain'), false);
      expect(isEmail('missing@tld'), false);
      expect(isEmail('two@@domain.com'), false);
    });

    test('returns false for empty string', () {
      expect(isEmail(''), false);
    });

    test('trims whitespace before validating', () {
      expect(isEmail('  user@example.com  '), true);
      expect(isEmail('  invalid@  '), false);
    });
  });
}
