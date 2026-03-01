/**
 * Formats a number as a localized currency string using BCP 47 locale identifiers.
 *
 * Throws a `RangeError` if `amount` is not a finite number, `currency` is not a
 * valid ISO 4217 code, or `locale` is not a valid BCP 47 locale string.
 *
 * @param amount - The numeric amount to format. Must be a finite number.
 * @param currency - ISO 4217 currency code (e.g., "USD", "EUR", "JPY"). Defaults to "USD".
 * @param locale - BCP 47 locale string (e.g., "en-US", "es-ES", "ja-JP"). Defaults to "en-US".
 * @returns A formatted currency string.
 * @throws {RangeError} If `amount` is NaN or Infinity, or if `currency` or `locale` is invalid.
 *
 * @example
 * ```ts
 * formatCurrency(1234.56);                    // "$1,234.56" (en-US / USD default)
 * formatCurrency(1234.56, "EUR", "es-ES");    // "1.234,56 €"
 * formatCurrency(1000, "JPY", "ja-JP");       // "¥1,000"
 * formatCurrency(NaN);                        // throws RangeError
 * ```
 */
export function formatCurrency(
  amount: number,
  currency = "USD",
  locale = "en-US",
): string {
  if (!Number.isFinite(amount)) {
    throw new RangeError(`Invalid amount: ${amount}. Must be a finite number.`);
  }
  return new Intl.NumberFormat(locale, { style: "currency", currency }).format(
    amount,
  );
}
