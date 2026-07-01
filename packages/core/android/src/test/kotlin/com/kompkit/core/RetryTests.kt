package com.kompkit.core

import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.test.runTest
import org.junit.Test
import java.io.IOException
import kotlin.test.assertEquals
import kotlin.test.assertFailsWith

@OptIn(ExperimentalCoroutinesApi::class)
class RetryTests {
  @Test
  fun returnsValueOnFirstSuccess() =
    runTest {
      val result = retry { 42 }
      assertEquals(42, result)
    }

  @Test
  fun retriesOnFailureAndSucceeds() =
    runTest {
      var attempt = 0
      val result =
        retry(RetryOptions(baseDelayMs = 100)) {
          attempt++
          if (attempt < 3) throw IOException("fail $attempt")
          "ok"
        }
      assertEquals("ok", result)
      assertEquals(3, attempt)
    }

  @Test
  fun throwsLastErrorAfterAllAttempts() =
    runTest {
      var attempt = 0
      val ex =
        assertFailsWith<IOException> {
          retry(RetryOptions(maxAttempts = 2, baseDelayMs = 50)) {
            attempt++
            throw IOException("always fails")
          }
        }
      assertEquals("always fails", ex.message)
      assertEquals(2, attempt)
    }

  @Test
  fun defaultsToThreeAttempts() =
    runTest {
      var attempt = 0
      assertFailsWith<IOException> {
        retry(RetryOptions(baseDelayMs = 10)) {
          attempt++
          throw IOException("fail")
        }
      }
      assertEquals(3, attempt)
    }

  @Test
  fun appliesExponentialBackoff() =
    runTest {
      var attempt = 0
      val startTime = testScheduler.currentTime
      val timestamps = mutableListOf<Long>()

      retry(RetryOptions(maxAttempts = 4, baseDelayMs = 100, multiplier = 2.0)) {
        attempt++
        timestamps.add(testScheduler.currentTime - startTime)
        if (attempt <= 3) throw IOException("fail")
        "done"
      }

      assertEquals(4, attempt)
      // attempt 1 at t=0, attempt 2 at t=100, attempt 3 at t=300, attempt 4 at t=700
      assertEquals(0L, timestamps[0])
      assertEquals(100L, timestamps[1])
      assertEquals(300L, timestamps[2])
      assertEquals(700L, timestamps[3])
    }

  @Test
  fun capsDelayAtMaxDelay() =
    runTest {
      var attempt = 0
      val startTime = testScheduler.currentTime
      val timestamps = mutableListOf<Long>()

      retry(
        RetryOptions(
          maxAttempts = 4,
          baseDelayMs = 100,
          multiplier = 10.0,
          maxDelayMs = 500,
        ),
      ) {
        attempt++
        timestamps.add(testScheduler.currentTime - startTime)
        if (attempt <= 3) throw IOException("fail")
        "done"
      }

      assertEquals(4, attempt)
      // delay 1: min(100*10^0, 500) = 100 → t=100
      // delay 2: min(100*10^1, 500) = 500 → t=600
      // delay 3: min(100*10^2, 500) = 500 → t=1100
      assertEquals(0L, timestamps[0])
      assertEquals(100L, timestamps[1])
      assertEquals(600L, timestamps[2])
      assertEquals(1100L, timestamps[3])
    }

  @Test
  fun retryIfRetriesWhenPredicateReturnsTrue() =
    runTest {
      var attempt = 0
      val result =
        retry(
          RetryOptions(
            baseDelayMs = 10,
            retryIf = { it.message == "transient" },
          ),
        ) {
          attempt++
          if (attempt < 2) throw IOException("transient")
          "ok"
        }
      assertEquals("ok", result)
    }

  @Test
  fun retryIfRethrowsImmediatelyWhenPredicateReturnsFalse() =
    runTest {
      var attempt = 0
      val ex =
        assertFailsWith<IOException> {
          retry(
            RetryOptions(
              maxAttempts = 5,
              baseDelayMs = 10,
              retryIf = { false },
            ),
          ) {
            attempt++
            throw IOException("fatal")
          }
        }
      assertEquals("fatal", ex.message)
      assertEquals(1, attempt)
    }

  @Test
  fun maxAttemptsOneExecutesOnceWithNoRetries() =
    runTest {
      var attempt = 0
      assertFailsWith<IOException> {
        retry(RetryOptions(maxAttempts = 1)) {
          attempt++
          throw IOException("fail")
        }
      }
      assertEquals(1, attempt)
    }

  @Test
  fun acceptsBaseDelayZero() =
    runTest {
      var attempt = 0
      val result =
        retry(RetryOptions(baseDelayMs = 0, maxDelayMs = 0)) {
          attempt++
          if (attempt < 2) throw IOException("fail")
          "ok"
        }
      assertEquals("ok", result)
    }

  // --- Validation ---

  @Test
  fun throwsForMaxAttemptsLessThanOne() {
    assertFailsWith<IllegalArgumentException> {
      RetryOptions(maxAttempts = 0)
    }
  }

  @Test
  fun throwsForNegativeBaseDelay() {
    assertFailsWith<IllegalArgumentException> {
      RetryOptions(baseDelayMs = -1)
    }
  }

  @Test
  fun throwsForMaxDelayLessThanBaseDelay() {
    assertFailsWith<IllegalArgumentException> {
      RetryOptions(baseDelayMs = 100, maxDelayMs = 50)
    }
  }

  @Test
  fun throwsForMultiplierLessThanOne() {
    assertFailsWith<IllegalArgumentException> {
      RetryOptions(multiplier = 0.5)
    }
  }
}
