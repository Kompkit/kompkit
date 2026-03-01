/**
 * Constrains a number within the inclusive range [min, max].
 *
 * @param value - The number to clamp. Must be finite.
 * @param min - The lower bound (inclusive). Must be finite.
 * @param max - The upper bound (inclusive). Must be finite.
 * @returns The clamped value.
 * @throws {RangeError} If any argument is not finite, or if `min > max`.
 *
 * @example
 * ```ts
 * clamp(5, 0, 10)   // 5
 * clamp(-3, 0, 10)  // 0
 * clamp(15, 0, 10)  // 10
 * ```
 */
export function clamp(value: number, min: number, max: number): number {
  if (!Number.isFinite(value) || !Number.isFinite(min) || !Number.isFinite(max)) {
    throw new RangeError(`clamp: all arguments must be finite numbers (got value=${value}, min=${min}, max=${max}).`);
  }
  if (min > max) {
    throw new RangeError(`clamp: min (${min}) must not be greater than max (${max}).`);
  }
  return Math.min(Math.max(value, min), max);
}
