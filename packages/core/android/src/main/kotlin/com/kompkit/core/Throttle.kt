package com.kompkit.core

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

/**
 * A throttled function wrapper with a [cancel] method.
 *
 * Invoke it like a regular function; call [cancel] to reset internal state
 * (e.g., on ViewModel `onCleared` or composable disposal).
 *
 * @param T The type of the argument accepted by the throttled action.
 */
class Throttled<T>(private val invoke: (T) -> Unit) {
  /** Invokes the throttled function with [value]. */
  operator fun invoke(value: T) = invoke.invoke(value)

  /** Resets the throttle state, allowing the next call to execute immediately. */
  fun cancel() = _cancel()

  internal var _cancel: () -> Unit = {}
}

/**
 * Throttles consecutive calls so the action executes at most once per [waitMs] milliseconds.
 * The first call executes immediately. Subsequent calls within the wait period are ignored.
 * After the wait period elapses, the next call executes immediately again.
 *
 * @param T The type of parameter accepted by the throttled action.
 * @param waitMs Milliseconds to suppress subsequent calls after an execution. Must be > 0.
 * @param scope Coroutine scope used to schedule the wait period.
 * @param action The callback to invoke on each allowed execution.
 * @return A [Throttled] wrapper.
 * @throws IllegalArgumentException if [waitMs] is not greater than 0.
 *
 * @sample
 * ```kotlin
 * val scope = CoroutineScope(Dispatchers.Main)
 * val onScroll = throttle<Unit>(200L, scope) {
 *     println("scroll event")
 * }
 * onScroll(Unit)   // executes immediately
 * onScroll(Unit)   // ignored within 200ms
 * onScroll.cancel() // resets state
 * ```
 */
fun <T> throttle(
  waitMs: Long,
  scope: CoroutineScope,
  action: (T) -> Unit,
): Throttled<T> {
  require(waitMs > 0) { "throttle: waitMs must be greater than 0 (got $waitMs)." }

  var job: Job? = null
  val throttled = Throttled<T> { param ->
    if (job != null) return@Throttled
    action(param)
    job = scope.launch {
      delay(waitMs)
      job = null
    }
  }
  throttled._cancel = {
    job?.cancel()
    job = null
  }
  return throttled
}
