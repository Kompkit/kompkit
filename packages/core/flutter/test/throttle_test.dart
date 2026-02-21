import 'package:flutter_test/flutter_test.dart';
import '../lib/src/throttle.dart';

void main() {
  group('throttle', () {
    test('executes the function immediately on first call', () async {
      int count = 0;
      final throttled = throttle<void>((_) => count++, const Duration(milliseconds: 200));
      throttled(null);
      expect(count, 1);
    });

    test('ignores subsequent calls within the wait period', () async {
      int count = 0;
      final throttled = throttle<void>((_) => count++, const Duration(milliseconds: 200));
      throttled(null);
      throttled(null);
      throttled(null);
      expect(count, 1);
    });

    test('allows execution again after wait period elapses', () async {
      int count = 0;
      final throttled = throttle<void>((_) => count++, const Duration(milliseconds: 50));
      throttled(null);
      expect(count, 1);
      await Future.delayed(const Duration(milliseconds: 60));
      throttled(null);
      expect(count, 2);
    });

    test('passes arguments correctly', () async {
      String? received;
      final throttled = throttle<String>((v) => received = v, const Duration(milliseconds: 200));
      throttled('hello');
      expect(received, 'hello');
    });

    test('cancel() resets state so next call executes immediately', () async {
      int count = 0;
      final throttled = throttle<void>((_) => count++, const Duration(milliseconds: 200));
      throttled(null);
      expect(count, 1);
      throttled.cancel();
      throttled(null);
      expect(count, 2);
    });

    test('cancel() is safe to call when no call is pending', () {
      final throttled = throttle<void>((_) {}, const Duration(milliseconds: 200));
      expect(() => throttled.cancel(), returnsNormally);
    });

    test('throws ArgumentError if wait is Duration.zero', () {
      expect(
        () => throttle<void>((_) {}, Duration.zero),
        throwsArgumentError,
      );
    });

    test('throws ArgumentError if wait is negative', () {
      expect(
        () => throttle<void>((_) {}, const Duration(milliseconds: -100)),
        throwsArgumentError,
      );
    });
  });
}
