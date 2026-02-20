package com.kompkit.core

import java.text.NumberFormat
import java.util.Currency
import java.util.Locale

/**
 * Formats a number as a localized currency string.
 *
 * Accepts a BCP 47 locale string (e.g., `"en-US"`, `"es-ES"`, `"ja-JP"`) and converts it internally
 * to a [Locale] as required by the JVM — callers do not need to construct [Locale] objects
 * directly.
 *
 * Throws [IllegalArgumentException] if [currency] is not a valid ISO 4217 code. Throws
 * [IllegalArgumentException] if [locale] cannot be parsed into a valid [Locale].
 *
 * @param amount The numeric amount to format.
 * @param currency ISO 4217 currency code (e.g., "USD", "EUR", "JPY"). Defaults to "EUR".
 * @param locale BCP 47 locale string (e.g., "en-US", "es-ES"). Defaults to "en-US".
 * @return A formatted currency string.
 * @throws IllegalArgumentException if [currency] or [locale] is invalid.
 *
 * @sample
 * ```kotlin
 * formatCurrency(1234.56)                        // "$1,234.56" (en-US default)
 * formatCurrency(1234.56, "EUR", "es-ES")        // "1.234,56 €"
 * formatCurrency(1000.0, "JPY", "ja-JP")         // "¥1,000"
 * ```
 */
fun formatCurrency(
        amount: Double,
        currency: String = "EUR",
        locale: String = "en-US",
): String {
  val jvmLocale =
          Locale.forLanguageTag(locale).takeIf { it.language.isNotEmpty() }
                  ?: throw IllegalArgumentException("Invalid locale: '$locale'")
  val currencyInstance =
          runCatching { Currency.getInstance(currency) }.getOrElse {
            throw IllegalArgumentException("Invalid currency code: '$currency'")
          }
  val nf = NumberFormat.getCurrencyInstance(jvmLocale)
  nf.currency = currencyInstance
  return nf.format(amount)
}
