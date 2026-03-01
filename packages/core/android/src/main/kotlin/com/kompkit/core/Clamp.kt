package com.kompkit.core

/**
 * Constrains a number within the inclusive range [min, max].
 *
 * @param value The number to clamp. Must be finite.
 * @param min The lower bound (inclusive). Must be finite.
 * @param max The upper bound (inclusive). Must be finite.
 * @return The clamped value.
 * @throws IllegalArgumentException if any argument is not finite, or if min > max.
 *
 * @sample
 * ```kotlin
 * clamp(5.0, 0.0, 10.0)   // 5.0
 * clamp(-3.0, 0.0, 10.0)  // 0.0
 * clamp(15.0, 0.0, 10.0)  // 10.0
 * ```
 */
fun clamp(value: Double, min: Double, max: Double): Double {
        require(value.isFinite() && min.isFinite() && max.isFinite()) {
                "clamp: all arguments must be finite numbers (got value=$value, min=$min, max=$max)."
        }
        require(min <= max) {
                "clamp: min ($min) must not be greater than max ($max)."
        }
        return value.coerceIn(min, max)
}
