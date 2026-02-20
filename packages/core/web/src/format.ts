/**
 * Formats a number as a localized currency string using BCP 47 locale identifiers.
 *
 * Throws a `RangeError` if `currency` is not a valid ISO 4217 code or `locale` is
 * not a valid BCP 47 locale string — consistent with the behavior of `Intl.NumberFormat`.
 *
 * @param amount - The numeric amount to format.
 * @param currency - ISO 4217 currency code (e.g., "USD", "EUR", "JPY"). Defaults to "EUR".
 * @param locale - BCP 47 locale string (e.g., "en-US", "es-ES", "ja-JP"). Defaults to "en-US".
 * @returns A formatted currency string.
 * @throws {RangeError} If `currency` or `locale` is invalid.
 *
 * @example
 * ```ts
 * formatCurrency(1234.56);                    // "$1,234.56" (en-US default)
 * formatCurrency(1234.56, "EUR", "es-ES");    // "1.234,56 €"
 * formatCurrency(1000, "JPY", "ja-JP");       // "¥1,000"
 * formatCurrency(NaN, "USD", "en-US");        // "NaN" — Intl.NumberFormat behaviour
 * ```
 */
export function formatCurrency(
  amount: number,
  currency = "EUR",
  locale = "en-US",
): string {
  return new Intl.NumberFormat(locale, { style: "currency", currency }).format(
    amount,
  );
}
