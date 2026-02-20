import 'package:flutter_test/flutter_test.dart';
import '../lib/src/debounce.dart';

void main() {
  group('debounce', () {
    test('does not call the action immediately', () async {
      var callCount = 0;
      final fn = debounce<String>((String value) {
        callCount++;
      }, const Duration(milliseconds: 100));

      fn('test');
      expect(callCount, 0);
    });

    test('calls the action after the wait period', () async {
      var callCount = 0;
      final fn = debounce<String>((String value) {
        callCount++;
      }, const Duration(milliseconds: 100));

      fn('test');
      await Future.delayed(const Duration(milliseconds: 150));
      expect(callCount, 1);
    });

    test('only calls once for multiple rapid calls (debounce behavior)', () async {
      var callCount = 0;
      String? lastValue;
      final fn = debounce<String>((String value) {
        callCount++;
        lastValue = value;
      }, const Duration(milliseconds: 100));

      fn('first');
      fn('second');
      fn('third');

      await Future.delayed(const Duration(milliseconds: 150));
      expect(callCount, 1);
      expect(lastValue, 'third');
    });

    test('uses 250ms default wait when not specified', () async {
      var callCount = 0;
      final fn = debounce<String>((String value) => callCount++);

      fn('test');
      await Future.delayed(const Duration(milliseconds: 200));
      expect(callCount, 0);

      await Future.delayed(const Duration(milliseconds: 100));
      expect(callCount, 1);
    });

    test('cancel() prevents the pending call from executing', () async {
      var callCount = 0;
      final fn = debounce<String>((String value) => callCount++,
          const Duration(milliseconds: 100));

      fn('test');
      fn.cancel();

      await Future.delayed(const Duration(milliseconds: 150));
      expect(callCount, 0);
    });

    test('cancel() is safe to call when no call is pending', () {
      final fn = debounce<String>((String value) {});
      expect(() => fn.cancel(), returnsNormally);
    });

    test('void action works via debounce<void>', () async {
      var callCount = 0;
      final fn = debounce<void>((_) => callCount++,
          const Duration(milliseconds: 100));

      fn(null);
      fn(null);
      fn(null);

      await Future.delayed(const Duration(milliseconds: 150));
      expect(callCount, 1);
    });
  });
}
