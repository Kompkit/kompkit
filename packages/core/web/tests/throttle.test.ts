import { describe, it, expect, vi, beforeEach, afterEach } from "vitest";
import { throttle } from "../src";

describe("throttle", () => {
  beforeEach(() => {
    vi.useFakeTimers();
  });

  afterEach(() => {
    vi.useRealTimers();
  });

  it("executes the function immediately on first call", () => {
    const fn = vi.fn();
    const throttled = throttle(fn, 200);
    throttled();
    expect(fn).toHaveBeenCalledTimes(1);
  });

  it("ignores subsequent calls within the wait period", () => {
    const fn = vi.fn();
    const throttled = throttle(fn, 200);
    throttled();
    throttled();
    throttled();
    expect(fn).toHaveBeenCalledTimes(1);
  });

  it("allows execution again after wait period elapses", () => {
    const fn = vi.fn();
    const throttled = throttle(fn, 200);
    throttled();
    expect(fn).toHaveBeenCalledTimes(1);
    vi.advanceTimersByTime(200);
    throttled();
    expect(fn).toHaveBeenCalledTimes(2);
  });

  it("passes arguments correctly", () => {
    const fn = vi.fn();
    const throttled = throttle(fn, 200);
    throttled("hello", 42);
    expect(fn).toHaveBeenCalledWith("hello", 42);
  });

  it("cancel() resets state so next call executes immediately", () => {
    const fn = vi.fn();
    const throttled = throttle(fn, 200);
    throttled();
    expect(fn).toHaveBeenCalledTimes(1);
    throttled.cancel();
    throttled();
    expect(fn).toHaveBeenCalledTimes(2);
  });

  it("cancel() is safe to call when no call is pending", () => {
    const fn = vi.fn();
    const throttled = throttle(fn, 200);
    expect(() => throttled.cancel()).not.toThrow();
  });

  it("throws Error if wait <= 0", () => {
    expect(() => throttle(() => {}, 0)).toThrow(Error);
  });

  it("throws Error if wait is negative", () => {
    expect(() => throttle(() => {}, -100)).toThrow(Error);
  });
});
