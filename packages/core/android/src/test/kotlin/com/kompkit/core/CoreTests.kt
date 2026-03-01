package com.kompkit.core

import kotlin.test.assertEquals
import kotlin.test.assertFailsWith
import kotlin.test.assertFalse
import kotlin.test.assertTrue
import kotlinx.coroutines.delay
import kotlinx.coroutines.runBlocking
import org.junit.Test

class IsEmailTests {
  @Test
  fun validEmails() {
    assertTrue(isEmail("user@example.com"))
    assertTrue(isEmail("test.email+tag@domain.org"))
    assertTrue(isEmail("a@b.co"))
  }

  @Test
  fun invalidEmails() {
    assertFalse(isEmail("invalid@"))
    assertFalse(isEmail("@invalid.com"))
    assertFalse(isEmail("nodomain"))
    assertFalse(isEmail("missing@tld"))
    assertFalse(isEmail("two@@domain.com"))
  }

  @Test
  fun emptyString() {
    assertFalse(isEmail(""))
  }

  @Test
  fun trimsWhitespace() {
    assertTrue(isEmail("  user@example.com  "))
    assertFalse(isEmail("  invalid@  "))
  }
}

class FormatCurrencyTests {
  @Test
  fun defaultLocaleIsEnUs() {
    val result = formatCurrency(1234.56)
    assertTrue(result.contains("1,234.56"), "Expected en-US formatted number, got: $result")
    assertTrue(result.contains("$"), "Expected USD symbol, got: $result")
  }

  @Test
  fun formatsUsdExplicitly() {
    val result = formatCurrency(1234.56, "USD", "en-US")
    assertTrue(result.contains("1,234.56"), "Expected en-US formatted number, got: $result")
    assertTrue(result.contains("$"), "Expected USD symbol, got: $result")
  }

  @Test
  fun formatsEurWithEsEsLocale() {
    val result = formatCurrency(1234.56, "EUR", "es-ES")
    assertTrue(result.contains("1.234,56"), "Expected es-ES formatted number, got: $result")
    assertTrue(result.contains("€"), "Expected EUR symbol, got: $result")
  }

  @Test
  fun formatsJpyWithJaJpLocale() {
    val result = formatCurrency(1000.0, "JPY", "ja-JP")
    assertTrue(result.contains("1,000"), "Expected formatted number, got: $result")
  }

  @Test
  fun handlesZero() {
    val result = formatCurrency(0.0, "USD", "en-US")
    assertTrue(result.contains("0"), "Expected zero, got: $result")
  }

  @Test
  fun handlesNegativeAmounts() {
    val result = formatCurrency(-50.25, "USD", "en-US")
    assertTrue(result.contains("50.25"), "Expected amount, got: $result")
  }

  @Test
  fun throwsForInvalidCurrency() {
    assertFailsWith<IllegalArgumentException> { formatCurrency(100.0, "INVALID", "en-US") }
  }

  @Test
  fun throwsForNaNAmount() {
    assertFailsWith<IllegalArgumentException> { formatCurrency(Double.NaN) }
  }

  @Test
  fun throwsForInfinityAmount() {
    assertFailsWith<IllegalArgumentException> { formatCurrency(Double.POSITIVE_INFINITY) }
    assertFailsWith<IllegalArgumentException> { formatCurrency(Double.NEGATIVE_INFINITY) }
  }

  @Test
  fun unrecognizedLocaleFallsBackGracefully() {
    // JVM Locale.forLanguageTag is lenient — unknown locales fall back to root locale.
    // This matches TypeScript (V8) behavior. Only currency codes are strictly validated.
    val result = formatCurrency(100.0, "USD", "zz-ZZ-unknown")
    assertTrue(result.isNotEmpty(), "Expected non-empty result for unknown locale, got: $result")
  }
}

class DebounceTests {
  @Test
  fun doesNotCallImmediately() = runBlocking {
    var called = false
    val debounced = debounce<String>({ called = true }, 200L, this)
    debounced("a")
    assertFalse(called)
  }

  @Test
  fun callsAfterWaitPeriod() = runBlocking {
    var called = false
    val debounced = debounce<String>({ called = true }, 100L, this)
    debounced("a")
    delay(50)
    assertFalse(called)
    delay(100)
    assertTrue(called)
  }

  @Test
  fun onlyCallsOnceForRapidCalls() = runBlocking {
    var callCount = 0
    var lastValue = ""
    val debounced =
            debounce<String>(
                    { v ->
                      callCount++
                      lastValue = v
                    },
                    100L,
                    this
            )
    debounced("a")
    debounced("b")
    debounced("c")
    delay(200)
    assertEquals(1, callCount)
    assertEquals("c", lastValue)
  }

  @Test
  fun cancelPreventsExecution() = runBlocking {
    var called = false
    val debounced = debounce<String>({ called = true }, 100L, this)
    debounced("a")
    debounced.cancel()
    delay(200)
    assertFalse(called)
  }

  @Test
  fun cancelIsSafeWhenNoPendingCall() = runBlocking {
    val debounced = debounce<String>({}, 100L, this)
    debounced.cancel() // should not throw
  }
}

class ThrottleTests {
  @Test
  fun executesImmediatelyOnFirstCall() = runBlocking {
    var count = 0
    val scope = this
    val throttled = throttle<Unit>(200L, scope) { count++ }
    throttled(Unit)
    assertEquals(1, count)
  }

  @Test
  fun ignoresSubsequentCallsWithinWaitPeriod() = runBlocking {
    var count = 0
    val scope = this
    val throttled = throttle<Unit>(200L, scope) { count++ }
    throttled(Unit)
    throttled(Unit)
    throttled(Unit)
    assertEquals(1, count)
  }

  @Test
  fun allowsExecutionAfterWaitPeriodElapses() = runBlocking {
    var count = 0
    val scope = this
    val throttled = throttle<Unit>(50L, scope) { count++ }
    throttled(Unit)
    assertEquals(1, count)
    delay(60)
    throttled(Unit)
    assertEquals(2, count)
  }

  @Test
  fun passesArgumentsCorrectly() = runBlocking {
    var received: String? = null
    val scope = this
    val throttled = throttle<String>(200L, scope) { received = it }
    throttled("hello")
    assertEquals("hello", received)
  }

  @Test
  fun cancelResetsStateSoNextCallExecutesImmediately() = runBlocking {
    var count = 0
    val scope = this
    val throttled = throttle<Unit>(200L, scope) { count++ }
    throttled(Unit)
    assertEquals(1, count)
    throttled.cancel()
    throttled(Unit)
    assertEquals(2, count)
  }

  @Test
  fun cancelIsSafeWhenNoPendingCall() = runBlocking {
    val scope = this
    val throttled = throttle<Unit>(200L, scope) {}
    throttled.cancel() // should not throw
  }

  @Test
  fun throwsWhenWaitIsZero() {
    runBlocking { assertFailsWith<IllegalArgumentException> { throttle<Unit>(0L, this) {} } }
  }

  @Test
  fun throwsWhenWaitIsNegative() {
    runBlocking { assertFailsWith<IllegalArgumentException> { throttle<Unit>(-100L, this) {} } }
  }
}

class ClampTests {
  @Test
  fun returnsValueWhenWithinRange() {
    assertEquals(5.0, clamp(5.0, 0.0, 10.0))
  }

  @Test
  fun returnsMinWhenBelowRange() {
    assertEquals(0.0, clamp(-3.0, 0.0, 10.0))
  }

  @Test
  fun returnsMaxWhenAboveRange() {
    assertEquals(10.0, clamp(15.0, 0.0, 10.0))
  }

  @Test
  fun returnsMinWhenValueEqualsMin() {
    assertEquals(0.0, clamp(0.0, 0.0, 10.0))
  }

  @Test
  fun returnsMaxWhenValueEqualsMax() {
    assertEquals(10.0, clamp(10.0, 0.0, 10.0))
  }

  @Test
  fun worksWithNegativeRange() {
    assertEquals(-5.0, clamp(-5.0, -10.0, -1.0))
    assertEquals(-1.0, clamp(0.0, -10.0, -1.0))
    assertEquals(-10.0, clamp(-20.0, -10.0, -1.0))
  }

  @Test
  fun worksWhenMinEqualsMax() {
    assertEquals(3.0, clamp(5.0, 3.0, 3.0))
  }

  @Test
  fun throwsWhenMinGreaterThanMax() {
    assertFailsWith<IllegalArgumentException> { clamp(5.0, 10.0, 0.0) }
  }

  @Test
  fun throwsForNaNValue() {
    assertFailsWith<IllegalArgumentException> { clamp(Double.NaN, 0.0, 10.0) }
  }

  @Test
  fun throwsForNaNMin() {
    assertFailsWith<IllegalArgumentException> { clamp(5.0, Double.NaN, 10.0) }
  }

  @Test
  fun throwsForNaNMax() {
    assertFailsWith<IllegalArgumentException> { clamp(5.0, 0.0, Double.NaN) }
  }

  @Test
  fun throwsForInfinityValue() {
    assertFailsWith<IllegalArgumentException> { clamp(Double.POSITIVE_INFINITY, 0.0, 10.0) }
  }

  @Test
  fun throwsForInfinityMin() {
    assertFailsWith<IllegalArgumentException> { clamp(5.0, Double.POSITIVE_INFINITY, 10.0) }
  }

  @Test
  fun throwsForInfinityMax() {
    assertFailsWith<IllegalArgumentException> { clamp(5.0, 0.0, Double.POSITIVE_INFINITY) }
  }
}
