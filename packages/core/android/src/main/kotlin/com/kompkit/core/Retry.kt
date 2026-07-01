@file:Suppress("MatchingDeclarationName")

package com.kompkit.core

import kotlinx.coroutines.delay
import kotlin.math.min
import kotlin.math.pow

/**
 * Configuration for [retry] with exponential backoff.
 *
 * @property maxAttempts Maximum number of attempts (including the initial call). Must be >= 1.
 * @property baseDelayMs Base delay in milliseconds before the first retry. Must be >= 0.
 * @property maxDelayMs Maximum delay in milliseconds (caps the exponential growth). Must be >= [baseDelayMs].
 * @property multiplier Multiplier applied to the delay after each failed attempt. Must be >= 1.0.
 * @property retryIf Optional predicate called with each error. Return `true` to retry,
 *   `false` to rethrow immediately. Defaults to always retry.
 */
data class RetryOptions(
  val maxAttempts: Int = 3,
  val baseDelayMs: Long = 1_000L,
  val maxDelayMs: Long = 30_000L,
  val multiplier: Double = 2.0,
  val retryIf: ((Throwable) -> Boolean)? = null,
) {
  init {
    require(maxAttempts >= 1) {
      "retry: maxAttempts must be >= 1 (got $maxAttempts)."
    }
    require(baseDelayMs >= 0) {
      "retry: baseDelayMs must be >= 0 (got $baseDelayMs)."
    }
    require(maxDelayMs >= baseDelayMs) {
      "retry: maxDelayMs must be >= baseDelayMs (got maxDelayMs=$maxDelayMs, baseDelayMs=$baseDelayMs)."
    }
    require(multiplier >= 1.0) {
      "retry: multiplier must be >= 1.0 (got $multiplier)."
    }
  }
}

/**
 * Executes a suspending [action] with automatic retries and exponential backoff.
 *
 * On each failure the delay grows: `baseDelayMs`, `baseDelayMs * multiplier`,
 * `baseDelayMs * multiplier²`, … capped at `maxDelayMs`. If all attempts fail,
 * the last exception is rethrown.
 *
 * @param T The return type of [action].
 * @param options Retry configuration. Defaults to 3 attempts, 1 s base delay, ×2 multiplier.
 * @param action The suspending block to execute.
 * @return The result of [action] on the first successful attempt.
 * @throws [Throwable] The last exception thrown by [action] after all attempts are exhausted,
 *   or immediately if [RetryOptions.retryIf] returns `false`.
 * @throws IllegalArgumentException If any [RetryOptions] value is out of range.
 *
 * @sample
 * ```kotlin
 * val data = retry { api.fetchData() }
 *
 * val result = retry(RetryOptions(maxAttempts = 5, baseDelayMs = 500)) {
 *     unreliableCall()
 * }
 *
 * retry(RetryOptions(retryIf = { it !is AuthException })) {
 *     fetchWithAuth()
 * }
 * ```
 */
suspend fun <T> retry(
  options: RetryOptions = RetryOptions(),
  action: suspend () -> T,
): T {
  var lastException: Throwable? = null

  for (attempt in 0 until options.maxAttempts) {
    try {
      return action()
    } catch (
      @Suppress("TooGenericExceptionCaught") e: Throwable,
    ) {
      lastException = e

      if (options.retryIf != null && !options.retryIf.invoke(e)) {
        throw e
      }

      if (attempt < options.maxAttempts - 1) {
        val delayMs =
          min(
            (options.baseDelayMs * options.multiplier.pow(attempt.toDouble())).toLong(),
            options.maxDelayMs,
          )
        delay(delayMs)
      }
    }
  }

  throw lastException!!
}
