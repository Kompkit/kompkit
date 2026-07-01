import 'dart:math';

/// Configuration for [retry] with exponential backoff.
///
/// All defaults match the Web (TypeScript) and Android (Kotlin) implementations:
/// 3 attempts, 1 s base delay, 30 s cap, ×2 multiplier.
class RetryOptions {
  /// Maximum number of attempts (including the initial call). Must be >= 1.
  final int maxAttempts;

  /// Base delay before the first retry. Must be non-negative.
  final Duration baseDelay;

  /// Maximum delay between retries (caps the exponential growth).
  /// Must be >= [baseDelay].
  final Duration maxDelay;

  /// Multiplier applied to the delay after each failed attempt. Must be >= 1.
  final double multiplier;

  /// Optional predicate called with each error. Return `true` to retry,
  /// `false` to rethrow immediately. Defaults to always retry.
  final bool Function(Object)? retryIf;

  /// Creates retry options with exponential backoff configuration.
  const RetryOptions({
    this.maxAttempts = 3,
    this.baseDelay = const Duration(seconds: 1),
    this.maxDelay = const Duration(seconds: 30),
    this.multiplier = 2.0,
    this.retryIf,
  });

  void _validate() {
    if (maxAttempts < 1) {
      throw ArgumentError(
        'retry: maxAttempts must be >= 1 (got $maxAttempts).',
      );
    }
    if (baseDelay.isNegative) {
      throw ArgumentError(
        'retry: baseDelay must be non-negative (got $baseDelay).',
      );
    }
    if (maxDelay < baseDelay) {
      throw ArgumentError(
        'retry: maxDelay must be >= baseDelay '
        '(got maxDelay=$maxDelay, baseDelay=$baseDelay).',
      );
    }
    if (multiplier < 1) {
      throw ArgumentError(
        'retry: multiplier must be >= 1 (got $multiplier).',
      );
    }
  }
}

/// Executes an async [fn] with automatic retries and exponential backoff.
///
/// On each failure the delay grows: `baseDelay`, `baseDelay × multiplier`,
/// `baseDelay × multiplier²`, … capped at `maxDelay`. If all attempts fail,
/// the last error is rethrown.
///
/// **Parameters:**
/// - [fn] - The async function to execute
/// - [options] - Retry configuration (defaults to 3 attempts, 1 s base, ×2)
///
/// **Example:**
/// ```dart
/// final data = await retry(() => httpClient.get('/api/data'));
///
/// final result = await retry(
///   () => unreliableCall(),
///   const RetryOptions(maxAttempts: 5, baseDelay: Duration(milliseconds: 500)),
/// );
///
/// await retry(
///   () => fetchWithAuth(),
///   RetryOptions(retryIf: (e) => e is! AuthException),
/// );
/// ```
Future<T> retry<T>(
  Future<T> Function() fn, [
  RetryOptions options = const RetryOptions(),
]) async {
  options._validate();

  Object? lastError;
  StackTrace? lastStack;

  for (int attempt = 0; attempt < options.maxAttempts; attempt++) {
    try {
      return await fn();
    } catch (e, stack) {
      lastError = e;
      lastStack = stack;

      if (options.retryIf != null && !options.retryIf!(e)) {
        rethrow;
      }

      if (attempt < options.maxAttempts - 1) {
        final delayMs = min(
          (options.baseDelay.inMilliseconds *
                  pow(options.multiplier, attempt))
              .toInt(),
          options.maxDelay.inMilliseconds,
        );
        await Future.delayed(Duration(milliseconds: delayMs));
      }
    }
  }

  Error.throwWithStackTrace(lastError!, lastStack!);
}
