/// Constrains a number within the inclusive range [min, max].
///
/// **Parameters:**
/// - [value] - The number to clamp. Must be finite.
/// - [min] - The lower bound (inclusive). Must be finite.
/// - [max] - The upper bound (inclusive). Must be finite.
///
/// **Returns:** The clamped value.
/// @throws [ArgumentError] if any argument is not finite, or if [min] > [max].
///
/// **Example:**
/// ```dart
/// clamp(5.0, 0.0, 10.0)   // 5.0
/// clamp(-3.0, 0.0, 10.0)  // 0.0
/// clamp(15.0, 0.0, 10.0)  // 10.0
/// ```
double clamp(double value, double min, double max) {
  if (!value.isFinite || !min.isFinite || !max.isFinite) {
    throw ArgumentError(
      'clamp: all arguments must be finite numbers (got value=$value, min=$min, max=$max).',
    );
  }
  if (min > max) {
    throw ArgumentError(
      'clamp: min ($min) must not be greater than max ($max).',
    );
  }
  return value.clamp(min, max).toDouble();
}
