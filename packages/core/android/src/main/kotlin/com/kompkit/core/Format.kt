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
 * Throws [IllegalArgumentException] if [amount] is not finite (NaN or Infinity), or if [currency]
 * is not a valid ISO 4217 code. Locale strings are parsed leniently by the JVM; an unrecognized
 * locale falls back to the root locale rather than throwing.
 *
 * @param amount The numeric amount to format. Must be finite.
 * @param currency ISO 4217 currency code (e.g., "USD", "EUR", "JPY"). Defaults to "USD".
 * @param locale BCP 47 locale string (e.g., "en-US", "es-ES"). Defaults to "en-US".
 * @return A formatted currency string.
 * @throws IllegalArgumentException if [amount] is NaN or Infinity, or if [currency] is not a valid
 * ISO 4217 code.
 *
 * @sample
 * ```kotlin
 * formatCurrency(1234.56)                        // "$1,234.56" (en-US / USD default)
 * formatCurrency(1234.56, "EUR", "es-ES")        // "1.234,56 €"
 * formatCurrency(1000.0, "JPY", "ja-JP")         // "¥1,000"
 * ```
 */
fun formatCurrency(
        amount: Double,
        currency: String = "USD",
        locale: String = "en-US",
): String {
        require(amount.isFinite()) { "Invalid amount: $amount. Must be a finite number." }
        val jvmLocale = Locale.forLanguageTag(locale)
        val currencyInstance =
                runCatching { Currency.getInstance(currency) }.getOrElse {
                        throw IllegalArgumentException("Invalid currency code: '$currency'")
                }
        val nf = NumberFormat.getCurrencyInstance(jvmLocale)
        nf.currency = currencyInstance
        return nf.format(amount)
}
