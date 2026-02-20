import { describe, it, expect, vi } from "vitest";
import { debounce, isEmail, formatCurrency } from "../src";

// ---------------------------------------------------------------------------
// isEmail
// ---------------------------------------------------------------------------
describe("isEmail", () => {
  it("returns true for valid emails", () => {
    expect(isEmail("user@example.com")).toBe(true);
    expect(isEmail("test.email+tag@domain.org")).toBe(true);
    expect(isEmail("a@b.co")).toBe(true);
  });

  it("returns false for invalid emails", () => {
    expect(isEmail("invalid@")).toBe(false);
    expect(isEmail("@invalid.com")).toBe(false);
    expect(isEmail("nodomain")).toBe(false);
    expect(isEmail("missing@tld")).toBe(false);
    expect(isEmail("two@@domain.com")).toBe(false);
  });

  it("returns false for empty string", () => {
    expect(isEmail("")).toBe(false);
  });

  it("trims whitespace before validating", () => {
    expect(isEmail("  user@example.com  ")).toBe(true);
    expect(isEmail("  invalid@  ")).toBe(false);
  });
});

// ---------------------------------------------------------------------------
// formatCurrency
// ---------------------------------------------------------------------------
describe("formatCurrency", () => {
  it("formats USD with en-US locale by default", () => {
    const result = formatCurrency(1234.56);
    expect(result).toBe("€1,234.56");
  });

  it("formats USD explicitly", () => {
    expect(formatCurrency(1234.56, "USD", "en-US")).toBe("$1,234.56");
  });

  it("formats EUR with es-ES locale", () => {
    const result = formatCurrency(1234.56, "EUR", "es-ES");
    expect(result).toContain("1234,56");
    expect(result).toContain("€");
  });

  it("formats JPY with ja-JP locale (no decimal places)", () => {
    const result = formatCurrency(1000, "JPY", "ja-JP");
    expect(result).toContain("1,000");
    expect(result).toMatch(/[¥￥]/); // V8 may use narrow ¥ (U+00A5) or fullwidth ￥ (U+FFE5)
  });

  it("handles negative amounts", () => {
    const result = formatCurrency(-50.25, "USD", "en-US");
    expect(result).toContain("50.25");
    expect(result).toMatch(/-|\(/);
  });

  it("handles zero", () => {
    expect(formatCurrency(0, "USD", "en-US")).toBe("$0.00");
  });

  it("throws RangeError for invalid currency code", () => {
    expect(() => formatCurrency(100, "INVALID", "en-US")).toThrow(RangeError);
  });

  it("returns a string for unrecognized locale (V8 silently falls back)", () => {
    // Intl.NumberFormat in V8 does not throw on unknown locales — it falls back.
    // This is a known platform behavior difference vs Kotlin/Dart which throw.
    const result = formatCurrency(100, "USD", "not-a-locale");
    expect(typeof result).toBe("string");
    expect(result.length).toBeGreaterThan(0);
  });
});

// ---------------------------------------------------------------------------
// debounce
// ---------------------------------------------------------------------------
describe("debounce", () => {
  it("does not call the function immediately", () => {
    const mock = vi.fn();
    const fn = debounce(mock, 200);
    fn();
    expect(mock).not.toHaveBeenCalled();
  });

  it("calls the function after the wait period", async () => {
    const mock = vi.fn();
    const fn = debounce(mock, 100);
    fn();
    await new Promise((r) => setTimeout(r, 150));
    expect(mock).toHaveBeenCalledTimes(1);
  });

  it("only calls once for multiple rapid calls (debounce behavior)", async () => {
    const mock = vi.fn();
    const fn = debounce(mock, 100);
    fn("a");
    fn("b");
    fn("c");
    await new Promise((r) => setTimeout(r, 150));
    expect(mock).toHaveBeenCalledTimes(1);
    expect(mock).toHaveBeenCalledWith("c");
  });

  it("passes arguments correctly", async () => {
    const mock = vi.fn();
    const fn = debounce(mock, 100);
    fn("hello", 42);
    await new Promise((r) => setTimeout(r, 150));
    expect(mock).toHaveBeenCalledWith("hello", 42);
  });

  it("cancel() prevents the pending call from executing", async () => {
    const mock = vi.fn();
    const fn = debounce(mock, 100);
    fn();
    fn.cancel();
    await new Promise((r) => setTimeout(r, 150));
    expect(mock).not.toHaveBeenCalled();
  });

  it("cancel() is safe to call when no call is pending", () => {
    const mock = vi.fn();
    const fn = debounce(mock, 100);
    expect(() => fn.cancel()).not.toThrow();
  });

  it("uses 250ms default wait when not specified", async () => {
    const mock = vi.fn();
    const fn = debounce(mock);
    fn();
    await new Promise((r) => setTimeout(r, 200));
    expect(mock).not.toHaveBeenCalled();
    await new Promise((r) => setTimeout(r, 100));
    expect(mock).toHaveBeenCalledTimes(1);
  });
});
