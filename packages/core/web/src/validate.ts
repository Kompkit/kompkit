const EMAIL_RE = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

/**
 * Validates whether a string matches a basic email pattern.
 *
 * @param value - The string to validate.
 * @returns `true` if the string is a valid email format, `false` otherwise.
 *
 * @example
 * ```ts
 * isEmail('user@example.com'); // true
 * isEmail('invalid@');         // false
 * isEmail('  test@domain.org  '); // true (whitespace is trimmed)
 * ```
 */
export function isEmail(value: string): boolean {
  return EMAIL_RE.test(value.trim());
}
