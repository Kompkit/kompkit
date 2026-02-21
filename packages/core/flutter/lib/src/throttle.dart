import 'dart:async';

/// A throttled function wrapper with a [cancel] method.
///
/// Invoke it like the original function; call [cancel] to reset internal state
/// (e.g., in [State.dispose]).
///
/// ```dart
/// final onScroll = throttle<void>((v) => print('scroll'), Duration(milliseconds: 200));
/// onScroll(null);   // executes immediately
/// onScroll(null);   // ignored within 200ms
/// onScroll.cancel(); // resets state
/// ```
class Throttled<T> {
  final void Function(T) _action;
  final Duration _wait;
  Timer? _timer;

  Throttled._(this._action, this._wait);

  /// Executes [action] immediately if not within the wait period.
  /// Calls within the wait period are silently ignored.
  void call(T arg) {
    if (_timer != null) return;
    _action(arg);
    _timer = Timer(_wait, () {
      _timer = null;
    });
  }

  /// Resets the throttle state, allowing the next call to execute immediately.
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }
}

/// Throttles a function so it executes at most once per [wait] duration.
/// The first call executes immediately. Subsequent calls within the wait period
/// are ignored. After the wait period elapses, the next call executes immediately again.
///
/// Returns a [Throttled] wrapper that can be called like the original function
/// and supports [Throttled.cancel] for cleanup.
///
/// **Parameters:**
/// - [fn] - The function to throttle
/// - [wait] - Duration to suppress subsequent calls after an execution
///
/// **Throws:** [ArgumentError] if [wait] is not greater than [Duration.zero].
///
/// **Example:**
/// ```dart
/// final onScroll = throttle<String>((event) {
///   print('Handling: $event');
/// }, const Duration(milliseconds: 200));
///
/// onScroll('a'); // executes immediately
/// onScroll('b'); // ignored within 200ms
/// onScroll.cancel(); // resets state (e.g., in dispose())
/// ```
Throttled<T> throttle<T>(
  void Function(T) fn,
  Duration wait,
) {
  if (wait <= Duration.zero) {
    throw ArgumentError(
      'throttle: wait must be greater than Duration.zero (got $wait).',
    );
  }
  return Throttled._(fn, wait);
}
