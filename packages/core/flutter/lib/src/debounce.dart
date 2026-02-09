import 'dart:async';

/// Debounces a function call by delaying its execution until after a specified wait period.
/// 
/// Subsequent calls within the wait period reset the timer, ensuring that the function
/// is only called once after the specified delay has elapsed without any new calls.
/// 
/// This is particularly useful for scenarios like search input fields, where you want
/// to wait for the user to stop typing before making an API call.
/// 
/// **Parameters:**
/// - [fn] - The function to debounce
/// - [wait] - Duration to wait before invoking the function (defaults to 250ms)
/// 
/// **Returns:** A debounced version of the function that accepts a parameter of type [T]
/// 
/// **Example:**
/// ```dart
/// final search = debounce<String>((String query) {
///   print('Searching: $query');
/// }, const Duration(milliseconds: 300));
/// 
/// search('hello'); // Will execute after 300ms if no other calls are made
/// search('world'); // Previous call is cancelled, this will execute after 300ms
/// ```
Function debounce<T>(Function fn, [Duration wait = const Duration(milliseconds: 250)]) {
  Timer? timer;
  
  return (T arg) {
    timer?.cancel();
    timer = Timer(wait, () => fn(arg));
  };
}

/// Debounces a void function (function with no parameters).
/// 
/// Similar to [debounce], but specifically designed for functions that don't take parameters.
/// Useful for actions like saving data, refreshing UI, or other side effects.
/// 
/// **Parameters:**
/// - [fn] - The void function to debounce
/// - [wait] - Duration to wait before invoking the function (defaults to 250ms)
/// 
/// **Returns:** A debounced version of the void function
/// 
/// **Example:**
/// ```dart
/// final saveData = debounceVoid(() {
///   print('Saving data...');
/// }, const Duration(milliseconds: 500));
/// 
/// saveData(); // Will execute after 500ms if no other calls are made
/// saveData(); // Previous call is cancelled, this will execute after 500ms
/// ```
VoidCallback debounceVoid(VoidCallback fn, [Duration wait = const Duration(milliseconds: 250)]) {
  Timer? timer;
  
  return () {
    timer?.cancel();
    timer = Timer(wait, fn);
  };
}

/// Type definition for void callback functions
typedef VoidCallback = void Function();
