import 'dart:async';

/// A debounced function wrapper with a [cancel] method.
///
/// Invoke it like the original function; call [cancel] to discard any pending
/// execution without invoking the action (e.g., in [State.dispose]).
///
/// ```dart
/// final search = debounce<String>((query) => print('Searching: $query'));
/// search('hello');   // schedules execution after 250ms
/// search.cancel();   // discards the pending call
/// ```
class Debounced<T> {
  final void Function(T) _action;
  final Duration _wait;
  Timer? _timer;

  Debounced._(this._action, this._wait);

  /// Schedules [action] to be called with [arg] after the wait period.
  /// Resets the timer if called again before the wait elapses.
  void call(T arg) {
    _timer?.cancel();
    _timer = Timer(_wait, () => _action(arg));
  }

  /// Cancels any pending invocation without executing it.
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }
}

/// Debounces a function call by delaying its execution until after a specified wait period.
/// Subsequent calls within the wait period reset the timer.
///
/// Returns a [Debounced] wrapper that can be called like the original function
/// and supports [Debounced.cancel] for cleanup.
///
/// **Parameters:**
/// - [action] - The function to debounce
/// - [wait] - Duration to wait before invoking the function (defaults to 250ms)
///
/// **Example:**
/// ```dart
/// final search = debounce<String>((String query) {
///   print('Searching: $query');
/// }, const Duration(milliseconds: 300));
///
/// search('hello'); // Will execute after 300ms if no other calls are made
/// search('world'); // Previous call is cancelled, this will execute after 300ms
/// search.cancel(); // Discards the pending call (e.g., in dispose())
/// ```
Debounced<T> debounce<T>(
  void Function(T) action, [
  Duration wait = const Duration(milliseconds: 250),
]) {
  return Debounced._(action, wait);
}
