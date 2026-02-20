package com.kompkit.core

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

/**
 * A debounced function wrapper with a [cancel] method.
 *
 * Invoke it like a regular function; call [cancel] to discard any pending execution
 * without invoking the action (e.g., on ViewModel `onCleared` or composable disposal).
 *
 * @param T The type of the argument accepted by the debounced action.
 */
class Debounced<T>(private val invoke: (T) -> Unit) {
  /** Invokes the debounced function with [value]. */
  operator fun invoke(value: T) = invoke.invoke(value)

  /** Cancels any pending invocation without executing it. */
  fun cancel() = _cancel()

  internal var _cancel: () -> Unit = {}
}

/**
 * Debounces consecutive calls and emits only the last one after [waitMs] milliseconds.
 * Subsequent calls within the wait period cancel the previous scheduled execution.
 *
 * The [action] is the conceptual first argument — what to debounce.
 * [waitMs] configures the delay (default 250ms).
 * [scope] is a platform constraint required for structured concurrency.
 *
 * Returns a [Debounced] wrapper that can be invoked like a function and supports [Debounced.cancel].
 *
 * @param T The type of parameter accepted by the debounced action.
 * @param action The callback to invoke after the debounce period elapses.
 * @param waitMs Milliseconds to wait before invoking [action]. Defaults to 250ms.
 * @param scope Coroutine scope used to schedule the delayed execution.
 * @return A [Debounced] wrapper.
 *
 * @sample
 * ```kotlin
 * val scope = CoroutineScope(Dispatchers.Main)
 * val search = debounce<String>(scope = scope) { query ->
 *     println("Searching: $query")
 * }
 * search("hello")   // Will execute after 250ms if no other calls are made
 * search.cancel()   // Discards the pending call (e.g., in onCleared)
 * ```
 */
fun <T> debounce(
  action: (T) -> Unit,
  waitMs: Long = 250L,
  scope: CoroutineScope,
): Debounced<T> {
  var job: Job? = null
  val debounced = Debounced<T> { param ->
    job?.cancel()
    job = scope.launch {
      delay(waitMs)
      action(param)
    }
  }
  debounced._cancel = { job?.cancel(); job = null }
  return debounced
}
