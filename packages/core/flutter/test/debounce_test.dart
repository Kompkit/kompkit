import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import '../lib/src/debounce.dart';

void main() {
  group('debounce', () {
    test('should delay function execution', () async {
      var callCount = 0;
      final debouncedFn = debounce<String>((String value) {
        callCount++;
      }, const Duration(milliseconds: 100));

      debouncedFn('test');
      expect(callCount, 0);

      await Future.delayed(const Duration(milliseconds: 150));
      expect(callCount, 1);
    });

    test('should cancel previous calls when called multiple times', () async {
      var callCount = 0;
      String? lastValue;
      final debouncedFn = debounce<String>((String value) {
        callCount++;
        lastValue = value;
      }, const Duration(milliseconds: 100));

      debouncedFn('first');
      debouncedFn('second');
      debouncedFn('third');

      await Future.delayed(const Duration(milliseconds: 150));
      expect(callCount, 1);
      expect(lastValue, 'third');
    });

    test('should use default wait time of 250ms', () async {
      var callCount = 0;
      final debouncedFn = debounce<String>((String value) {
        callCount++;
      });

      debouncedFn('test');
      
      // Should not execute before 250ms
      await Future.delayed(const Duration(milliseconds: 200));
      expect(callCount, 0);

      // Should execute after 250ms
      await Future.delayed(const Duration(milliseconds: 100));
      expect(callCount, 1);
    });
  });

  group('debounceVoid', () {
    test('should delay void function execution', () async {
      var callCount = 0;
      final debouncedFn = debounceVoid(() {
        callCount++;
      }, const Duration(milliseconds: 100));

      debouncedFn();
      expect(callCount, 0);

      await Future.delayed(const Duration(milliseconds: 150));
      expect(callCount, 1);
    });

    test('should cancel previous void calls when called multiple times', () async {
      var callCount = 0;
      final debouncedFn = debounceVoid(() {
        callCount++;
      }, const Duration(milliseconds: 100));

      debouncedFn();
      debouncedFn();
      debouncedFn();

      await Future.delayed(const Duration(milliseconds: 150));
      expect(callCount, 1);
    });
  });
}
