/**
 * A debounced function with a cancel method.
 * Call it like the original function; call `.cancel()` to discard any pending execution.
 */
export interface Debounced<T extends (...args: any[]) => void> {
  (...args: Parameters<T>): void;
  /** Cancels any pending invocation without executing it. */
  cancel(): void;
}

/**
 * Debounces a function call by delaying its execution until after a specified wait period.
 * Subsequent calls within the wait period reset the timer.
 * Returns a `Debounced` wrapper with a `cancel()` method for cleanup.
 *
 * @param fn - The function to debounce.
 * @param wait - Milliseconds to wait before invoking the function. Defaults to 250ms.
 * @returns A debounced wrapper with a `cancel()` method.
 *
 * @example
 * ```ts
 * const search = debounce((query: string) => {
 *   console.log('Searching:', query);
 * }, 300);
 *
 * search('hello'); // Will execute after 300ms if no other calls are made
 * search.cancel(); // Discards the pending call (e.g., on component unmount)
 * ```
 */
export function debounce<T extends (...args: any[]) => void>(
  fn: T,
  wait = 250,
): Debounced<T> {
  let timer: ReturnType<typeof setTimeout> | null = null;

  const debounced = (...args: Parameters<T>): void => {
    if (timer) clearTimeout(timer);
    timer = setTimeout(() => fn(...args), wait);
  };

  debounced.cancel = (): void => {
    if (timer) {
      clearTimeout(timer);
      timer = null;
    }
  };

  return debounced as Debounced<T>;
}
