/// Regular expression pattern for basic email validation.
/// 
/// This pattern validates the basic structure of an email address:
/// - Local part (before @): one or more non-whitespace, non-@ characters
/// - @ symbol
/// - Domain part (after @): one or more non-whitespace, non-@ characters
/// - Dot separator
/// - Top-level domain: one or more non-whitespace, non-@ characters
final RegExp _emailRegExp = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

/// Validates whether a string matches a basic email pattern.
/// 
/// This function performs a simple regex-based validation to check if the provided
/// string follows the basic email format. It automatically trims whitespace from
/// the input before validation.
/// 
/// **Note:** This is a basic validation and may not catch all edge cases of valid
/// or invalid email addresses according to RFC specifications. For production use
/// with strict requirements, consider using a more comprehensive email validation library.
/// 
/// **Parameters:**
/// - [value] - The string to validate
/// 
/// **Returns:** `true` if the string is a valid email format, `false` otherwise
/// 
/// **Example:**
/// ```dart
/// isEmail('user@example.com');        // true
/// isEmail('test.email@domain.org');   // true
/// isEmail('invalid@');                // false
/// isEmail('@invalid.com');            // false
/// isEmail('  test@domain.org  ');     // true (whitespace is trimmed)
/// isEmail('user name@domain.com');    // false (contains space)
/// ```
bool isEmail(String value) {
  return _emailRegExp.hasMatch(value.trim());
}
