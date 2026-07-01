import 'package:flutter_test/flutter_test.dart';
import '../lib/src/retry.dart';

void main() {
  group('retry', () {
    test('returns value on first success', () async {
      final result = await retry(() async => 42);
      expect(result, 42);
    });

    test('retries on failure and succeeds on subsequent attempt', () async {
      var attempt = 0;
      final result = await retry(
        () async {
          attempt++;
          if (attempt < 3) throw Exception('fail $attempt');
          return 'ok';
        },
        const RetryOptions(
          baseDelay: Duration(milliseconds: 10),
          maxDelay: Duration(milliseconds: 100),
        ),
      );
      expect(result, 'ok');
      expect(attempt, 3);
    });

    test('throws the last error after all attempts are exhausted', () async {
      var attempt = 0;
      await expectLater(
        retry(
          () async {
            attempt++;
            throw Exception('always fails');
          },
          const RetryOptions(
            maxAttempts: 2,
            baseDelay: Duration(milliseconds: 10),
          ),
        ),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('always fails'),
        )),
      );
      expect(attempt, 2);
    });

    test('defaults to 3 maxAttempts', () async {
      var attempt = 0;
      await expectLater(
        retry(
          () async {
            attempt++;
            throw Exception('fail');
          },
          const RetryOptions(baseDelay: Duration(milliseconds: 10)),
        ),
        throwsA(isA<Exception>()),
      );
      expect(attempt, 3);
    });

    test('retryIf: retries when predicate returns true', () async {
      var attempt = 0;
      final result = await retry(
        () async {
          attempt++;
          if (attempt < 2) throw Exception('transient');
          return 'ok';
        },
        RetryOptions(
          baseDelay: const Duration(milliseconds: 10),
          retryIf: (e) => e.toString().contains('transient'),
        ),
      );
      expect(result, 'ok');
    });

    test('retryIf: rethrows immediately when predicate returns false',
        () async {
      var attempt = 0;
      await expectLater(
        retry(
          () async {
            attempt++;
            throw Exception('fatal');
          },
          RetryOptions(
            maxAttempts: 5,
            baseDelay: const Duration(milliseconds: 10),
            retryIf: (_) => false,
          ),
        ),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('fatal'),
        )),
      );
      expect(attempt, 1);
    });

    test('maxAttempts = 1 executes once with no retries', () async {
      var attempt = 0;
      await expectLater(
        retry(
          () async {
            attempt++;
            throw Exception('fail');
          },
          const RetryOptions(maxAttempts: 1),
        ),
        throwsA(isA<Exception>()),
      );
      expect(attempt, 1);
    });

    test('accepts baseDelay = Duration.zero (no delay)', () async {
      var attempt = 0;
      final result = await retry(
        () async {
          attempt++;
          if (attempt < 2) throw Exception('fail');
          return 'ok';
        },
        const RetryOptions(
          baseDelay: Duration.zero,
          maxDelay: Duration.zero,
        ),
      );
      expect(result, 'ok');
    });

    // --- Validation ---

    test('throws ArgumentError for maxAttempts < 1', () async {
      await expectLater(
        retry(
          () async => 1,
          const RetryOptions(maxAttempts: 0),
        ),
        throwsArgumentError,
      );
    });

    test('throws ArgumentError for negative baseDelay', () async {
      await expectLater(
        retry(
          () async => 1,
          const RetryOptions(baseDelay: Duration(milliseconds: -1)),
        ),
        throwsArgumentError,
      );
    });

    test('throws ArgumentError for maxDelay < baseDelay', () async {
      await expectLater(
        retry(
          () async => 1,
          const RetryOptions(
            baseDelay: Duration(milliseconds: 100),
            maxDelay: Duration(milliseconds: 50),
          ),
        ),
        throwsArgumentError,
      );
    });

    test('throws ArgumentError for multiplier < 1', () async {
      await expectLater(
        retry(
          () async => 1,
          const RetryOptions(multiplier: 0.5),
        ),
        throwsArgumentError,
      );
    });

    test('preserves stack trace on final rethrow', () async {
      await expectLater(
        retry(
          () async {
            throw StateError('traced');
          },
          const RetryOptions(maxAttempts: 1),
        ),
        throwsA(isA<StateError>().having(
          (e) => e.message,
          'message',
          'traced',
        )),
      );
    });
  });
}
