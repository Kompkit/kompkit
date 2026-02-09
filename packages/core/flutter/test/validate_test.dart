import 'package:flutter_test/flutter_test.dart';
import '../lib/src/validate.dart';

void main() {
  group('isEmail', () {
    test('should return true for valid email addresses', () {
      expect(isEmail('user@example.com'), true);
      expect(isEmail('test@example.com'), true);
      expect(isEmail('test.email@domain.org'), true);
    });

    test('should return false for invalid email addresses', () {
      expect(isEmail(''), false);
      expect(isEmail('invalid'), false);
      expect(isEmail('invalid@'), false);
      expect(isEmail('@invalid.com'), false);
      expect(isEmail('invalid@com'), false);
    });

    test('should handle whitespace by trimming', () {
      expect(isEmail('  user@example.com  '), true);
      expect(isEmail('  invalid@  '), false);
    });
  });
}
