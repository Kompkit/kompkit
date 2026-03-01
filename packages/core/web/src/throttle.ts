/**
 * A throttled function with a cancel method.
 * Call it like the original function; call `.cancel()` to reset internal state.
 */
export interface Throttled<T extends (...args: any[]) => void> {
  (...args: Parameters<T>): void;
  /** Resets the throttle state, allowing the next call to execute immediately. */
  cancel(): void;
}

/**
 * Throttles a function so it executes at most once per `wait` milliseconds.
 * The first call executes immediately. Subsequent calls within the wait period
 * are ignored. After the wait period elapses, the next call executes immediately again.
 *
 * @param fn - The function to throttle.
 * @param wait - Milliseconds to suppress subsequent calls after an execution.
 * @returns A throttled wrapper with a `cancel()` method.
 * @throws {Error} If `wait` is not greater than 0.
 *
 * @example
 * ```ts
 * const onScroll = throttle(() => {
 *   console.log('scroll event');
 * }, 200);
 *
 * window.addEventListener('scroll', onScroll);
 * onScroll.cancel(); // Reset state (e.g., on component unmount)
 * ```
 */
export function throttle<T extends (...args: any[]) => void>(
  fn: T,
  wait: number,
): Throttled<T> {
  if (wait <= 0) {
    throw new Error(`throttle: wait must be greater than 0 (got ${wait}).`);
  }

  let timer: ReturnType<typeof setTimeout> | null = null;

  const throttled = (...args: Parameters<T>): void => {
    if (timer !== null) return;
    fn(...args);
    timer = setTimeout(() => {
      timer = null;
    }, wait);
  };

  throttled.cancel = (): void => {
    if (timer !== null) {
      clearTimeout(timer);
      timer = null;
    }
  };

  return throttled as Throttled<T>;
}
