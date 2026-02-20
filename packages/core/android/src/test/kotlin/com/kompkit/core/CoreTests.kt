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
    assertTrue(result.contains("€"), "Expected EUR symbol, got: $result")
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
  fun throwsForInvalidLocale() {
    assertFailsWith<IllegalArgumentException> { formatCurrency(100.0, "USD", "zz-ZZ-invalid") }
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
