/**
 * Options for configuring retry behavior with exponential backoff.
 */
export interface RetryOptions {
  /**
   * Maximum number of attempts (including the initial call).
   * Must be a positive integer. Defaults to 3.
   */
  maxAttempts?: number;

  /**
   * Base delay in milliseconds before the first retry.
   * Must be >= 0. Defaults to 1000.
   */
  baseDelay?: number;

  /**
   * Maximum delay in milliseconds between retries (caps the exponential growth).
   * Must be >= `baseDelay`. Defaults to 30000.
   */
  maxDelay?: number;

  /**
   * Multiplier applied to the delay after each failed attempt.
   * Must be >= 1. Defaults to 2.
   */
  multiplier?: number;

  /**
   * Optional predicate called with each error. Return `true` to retry,
   * `false` to rethrow immediately. Defaults to always retry.
   */
  retryIf?: (error: unknown) => boolean;
}

/**
 * Executes an async function with automatic retries and exponential backoff.
 *
 * On each failure the delay doubles (by default): `baseDelay`, `baseDelay * multiplier`,
 * `baseDelay * multiplier²`, … capped at `maxDelay`. If all attempts fail, the last
 * error is rethrown.
 *
 * @param fn - An async (or sync) function to execute. Called with no arguments.
 * @param options - Optional retry configuration.
 * @returns The resolved value of `fn`.
 * @throws The last error thrown by `fn` after all attempts are exhausted,
 *         or immediately if `retryIf` returns `false`.
 * @throws {RangeError} If any option value is out of its valid range.
 *
 * @example
 * ```ts
 * const data = await retry(() => fetch('/api/data').then(r => r.json()));
 *
 * const result = await retry(
 *   () => unreliableCall(),
 *   { maxAttempts: 5, baseDelay: 500, multiplier: 3 },
 * );
 *
 * await retry(
 *   () => fetchWithAuth(),
 *   { retryIf: (err) => (err as Response)?.status !== 401 },
 * );
 * ```
 */
export async function retry<T>(
  fn: () => T | Promise<T>,
  options?: RetryOptions,
): Promise<T> {
  const maxAttempts = options?.maxAttempts ?? 3;
  const baseDelay = options?.baseDelay ?? 1000;
  const maxDelay = options?.maxDelay ?? 30_000;
  const multiplier = options?.multiplier ?? 2;
  const retryIf = options?.retryIf;

  if (!Number.isInteger(maxAttempts) || maxAttempts < 1) {
    throw new RangeError(
      `retry: maxAttempts must be a positive integer (got ${maxAttempts}).`,
    );
  }
  if (!Number.isFinite(baseDelay) || baseDelay < 0) {
    throw new RangeError(
      `retry: baseDelay must be a non-negative finite number (got ${baseDelay}).`,
    );
  }
  if (!Number.isFinite(maxDelay) || maxDelay < baseDelay) {
    throw new RangeError(
      `retry: maxDelay must be >= baseDelay (got maxDelay=${maxDelay}, baseDelay=${baseDelay}).`,
    );
  }
  if (!Number.isFinite(multiplier) || multiplier < 1) {
    throw new RangeError(
      `retry: multiplier must be >= 1 (got ${multiplier}).`,
    );
  }

  let lastError: unknown;

  for (let attempt = 0; attempt < maxAttempts; attempt++) {
    try {
      return await fn();
    } catch (error) {
      lastError = error;

      if (retryIf && !retryIf(error)) {
        throw error;
      }

      if (attempt < maxAttempts - 1) {
        const delay = Math.min(baseDelay * multiplier ** attempt, maxDelay);
        await new Promise((resolve) => setTimeout(resolve, delay));
      }
    }
  }

  throw lastError;
}
