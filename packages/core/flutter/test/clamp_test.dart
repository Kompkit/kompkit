import 'package:flutter_test/flutter_test.dart';
import '../lib/src/clamp.dart';

void main() {
  group('clamp', () {
    test('returns value when within range', () {
      expect(clamp(5.0, 0.0, 10.0), 5.0);
    });

    test('returns min when value is below range', () {
      expect(clamp(-3.0, 0.0, 10.0), 0.0);
    });

    test('returns max when value is above range', () {
      expect(clamp(15.0, 0.0, 10.0), 10.0);
    });

    test('returns min when value equals min', () {
      expect(clamp(0.0, 0.0, 10.0), 0.0);
    });

    test('returns max when value equals max', () {
      expect(clamp(10.0, 0.0, 10.0), 10.0);
    });

    test('works with negative range', () {
      expect(clamp(-5.0, -10.0, -1.0), -5.0);
      expect(clamp(0.0, -10.0, -1.0), -1.0);
      expect(clamp(-20.0, -10.0, -1.0), -10.0);
    });

    test('works when min equals max', () {
      expect(clamp(5.0, 3.0, 3.0), 3.0);
    });

    test('throws ArgumentError when min > max', () {
      expect(() => clamp(5.0, 10.0, 0.0), throwsArgumentError);
    });

    test('throws ArgumentError for NaN value', () {
      expect(() => clamp(double.nan, 0.0, 10.0), throwsArgumentError);
    });

    test('throws ArgumentError for NaN min', () {
      expect(() => clamp(5.0, double.nan, 10.0), throwsArgumentError);
    });

    test('throws ArgumentError for NaN max', () {
      expect(() => clamp(5.0, 0.0, double.nan), throwsArgumentError);
    });

    test('throws ArgumentError for Infinity value', () {
      expect(() => clamp(double.infinity, 0.0, 10.0), throwsArgumentError);
    });

    test('throws ArgumentError for Infinity min', () {
      expect(() => clamp(5.0, double.infinity, 10.0), throwsArgumentError);
    });

    test('throws ArgumentError for Infinity max', () {
      expect(() => clamp(5.0, 0.0, double.infinity), throwsArgumentError);
    });
  });
}
