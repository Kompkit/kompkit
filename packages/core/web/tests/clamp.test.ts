import { describe, it, expect } from "vitest";
import { clamp } from "../src";

describe("clamp", () => {
  it("returns value when within range", () => {
    expect(clamp(5, 0, 10)).toBe(5);
  });

  it("returns min when value is below range", () => {
    expect(clamp(-3, 0, 10)).toBe(0);
  });

  it("returns max when value is above range", () => {
    expect(clamp(15, 0, 10)).toBe(10);
  });

  it("returns min when value equals min", () => {
    expect(clamp(0, 0, 10)).toBe(0);
  });

  it("returns max when value equals max", () => {
    expect(clamp(10, 0, 10)).toBe(10);
  });

  it("works with negative range", () => {
    expect(clamp(-5, -10, -1)).toBe(-5);
    expect(clamp(0, -10, -1)).toBe(-1);
    expect(clamp(-20, -10, -1)).toBe(-10);
  });

  it("works when min equals max", () => {
    expect(clamp(5, 3, 3)).toBe(3);
  });

  it("throws RangeError when min > max", () => {
    expect(() => clamp(5, 10, 0)).toThrow(RangeError);
  });

  it("throws RangeError for NaN value", () => {
    expect(() => clamp(NaN, 0, 10)).toThrow(RangeError);
  });

  it("throws RangeError for NaN min", () => {
    expect(() => clamp(5, NaN, 10)).toThrow(RangeError);
  });

  it("throws RangeError for NaN max", () => {
    expect(() => clamp(5, 0, NaN)).toThrow(RangeError);
  });

  it("throws RangeError for Infinity value", () => {
    expect(() => clamp(Infinity, 0, 10)).toThrow(RangeError);
  });

  it("throws RangeError for Infinity min", () => {
    expect(() => clamp(5, Infinity, 10)).toThrow(RangeError);
  });

  it("throws RangeError for Infinity max", () => {
    expect(() => clamp(5, 0, Infinity)).toThrow(RangeError);
  });
});
